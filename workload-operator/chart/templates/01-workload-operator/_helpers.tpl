
{{- define "workload-operator.fullname" -}}
{{ include "chart.fullname" . }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "workload-operator.labels" -}}
{{- include "chart.labels" . }}
app.kubernetes.io/component: workload-operator
{{- end }}


{{/*
Match labels
*/}}
{{- define "workload-operator.match-labels" -}}
{{- include "chart.match-labels" . }}
app.kubernetes.io/component: workload-operator
{{- end }}


{{/*
Create the name of the service account to use
*/}}
{{- define "workload-operator.serviceAccountName" -}}
{{- default (include "workload-operator.fullname" .) .Values.operator.serviceAccount.name }}
{{- end }}