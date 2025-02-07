{{/*
Expand the name of the chart.
*/}}
{{- define "testkube-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "testkube-operator.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "testkube-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "testkube-operator.labels" -}}
helm.sh/chart: {{ include "testkube-operator.chart" . }}
{{ include "testkube-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "testkube-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "testkube-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "testkube-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.name }}
{{- default .Values.serviceAccount.name }}
{{- else }}
{{- default "testkube-operator-controller-manager" }}
{{- end }}
{{- end }}

{{/*
Create the name of the webhook service account to use
*/}}
{{- define "testkube-operator.webhook.serviceAccountName" -}}
{{- if .Values.webhook.patch.serviceAccount.name }}
{{- default .Values.webhook.patch.serviceAccount.name }}
{{- else }}
{{- default "testkube-operator-webhook-cert-mgr" }}
{{- end }}
{{- end }}

{{/*
Create testkube operator webhook service name
*/}}
{{- define "testkube-operator.webhookServiceName" -}}
{{- default "testkube-operator-webhook-service" }}
{{- end }}

{{/*
Create testkube operator webhook certificate
*/}}
{{- define "testkube-operator.webhookCertificate" -}}
{{- default "testkube-operator-serving-cert" }}
{{- end }}

{{/*
Create an image pull secret value
*/}}
{{- define "imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.imageCredentials.registry (printf "%s:%s" .Values.imageCredentials.username .Values.imageCredentials.password | b64enc) | b64enc }}
{{- end }}
