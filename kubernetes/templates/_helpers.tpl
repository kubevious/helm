{{/*
Expand the name of the chart.
*/}}
{{- define "kubevious.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kubevious.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "kubevious.endpoint" -}}
{{ include "kubevious.fullname" . }}.{{ .Release.Namespace}}.svc.{{ .Values.cluster.domain}}:{{ .Values.kubevious.service.port }}
{{- end }}

{{- define "kubevious.collector" -}}
http://{{ include "kubevious.fullname" . }}.{{ .Release.Namespace}}.svc.{{ .Values.cluster.domain}}:{{ .Values.kubevious.service.port }}/api/v1/collect
{{- end }}

{{- define "kubevious-parser.fullname" -}}
{{ include "kubevious.fullname" . }}-parser
{{- end }}

{{- define "kubevious-mysql.fullname" -}}
{{ include "kubevious.fullname" . }}-mysql
{{- end }}

{{- define "kubevious-ui.fullname" -}}
{{ include "kubevious.fullname" . }}-ui
{{- end }}


{{- define "kubevious-mysql.root-password" -}}
{{- if .Values.mysql.root_password }}
{{- .Values.mysql.root_password }}
{{- else }}
{{- randAlphaNum 16 }}
{{- end }}
{{- end }}

{{- define "kubevious-mysql.user-password" -}}
{{- if and (.Values.mysql.db_user) (not (eq .Values.mysql.db_user "root")) }}
{{- if .Values.mysql.db_password }}
{{- .Values.mysql.db_password }}
{{- else }}
{{- randAlphaNum 16 }}
{{- end }}
{{- else }}
{{- include "kubevious-mysql.root-password" . }}
{{- end }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kubevious.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kubevious.labels" -}}
app.kubernetes.io/name: {{ include "kubevious.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
helm.sh/chart: {{ include "kubevious.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kubevious-parser.serviceAccountName" -}}
{{- if .Values.parser.serviceAccount.create }}
{{- default (include "kubevious-parser.fullname" .) .Values.parser.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.parser.serviceAccount.name }}
{{- end }}
{{- end }}
