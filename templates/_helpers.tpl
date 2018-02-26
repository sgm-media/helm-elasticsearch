{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 53 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 53 chars (63 - len("-discovery")) because some Kubernetes name fields are limited to 63 (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 53 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for cronjob APIs.
*/}}
{{- define "cronjob.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "batch/v1beta1" -}}
"batch/v1beta1"
{{- else -}}
"batch/v2alpha1"
{{- end -}}
{{- end -}}

{{- define "metrics.snippet" }}
{{- if .Values.metrics.enabled }}
      - name: metrics
        image: "{{ .Values.metrics.image.repository }}:{{ .Values.metrics.image.tag }}"
        imagePullPolicy: {{ .Values.metrics.image.pullPolicy }}
        env:
          - name: POD_IP
            valueFrom:
              fieldRef:
                fieldPath: status.podIP
        resources:
{{ toYaml .Values.metrics.resources | indent 12 }}
        args:
          - -es.uri=http://$(POD_IP):9200
        ports:
        - containerPort: 9108
          name: metrics
          protocol: TCP
{{- end }}
{{- end }}

