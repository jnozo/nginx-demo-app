{{/*
Produces base name for resources deployed by this chart.
*/}}
{{- define "nginx-demo.baseName" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels for all resources deployed by this chart. Doubles as selector labels in this demo chart.
*/}}
{{- define "nginx-demo.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
