
{{- define "kubevious-parser.fullname" -}}
{{ include "kubevious.fullname" . }}-parser
{{- end }}

{{/*
Create the name of the service account to use for the parser
*/}}
{{- define "kubevious-parser.serviceAccountName" -}}
{{- if .Values.parser.serviceAccount.create }}
{{- default (include "kubevious-parser.fullname" .) .Values.parser.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.parser.serviceAccount.name }}
{{- end }}
{{- end }}
