#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "dolphinscheduler.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dolphinscheduler.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "dolphinscheduler.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "dolphinscheduler.labels" -}}
helm.sh/chart: {{ include "dolphinscheduler.chart" . }}
{{ include "dolphinscheduler.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "dolphinscheduler.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dolphinscheduler.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "dolphinscheduler.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "dolphinscheduler.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default docker image registry.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dolphinscheduler.image.registry" -}}
{{- $registry := default "docker.io" .Values.image.registry -}}
{{- printf "%s" $registry | trunc 63 | trimSuffix "/" -}}
{{- end -}}

{{/*
Create a default docker image repository.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dolphinscheduler.image.repository" -}}
{{- printf "%s/%s:%s" (include "dolphinscheduler.image.registry" .) .Values.image.repository .Values.image.tag -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dolphinscheduler.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified zookkeeper name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dolphinscheduler.zookeeper.fullname" -}}
{{- $name := default "zookeeper" .Values.zookeeper.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified zookkeeper quorum.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dolphinscheduler.zookeeper.quorum" -}}
{{- $port := default "2181" (.Values.zookeeper.service.port | toString) -}}
{{- printf "%s:%s" (include "dolphinscheduler.zookeeper.fullname" .) $port | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default dolphinscheduler worker base dir.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dolphinscheduler.worker.base.dir" -}}
{{- $name := default "/tmp/dolphinscheduler" .Values.worker.configmap.DOLPHINSCHEDULER_DATA_BASEDIR_PATH -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "/" -}}
{{- end -}}

{{/*
Create a default dolphinscheduler worker data download dir.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dolphinscheduler.worker.data.download.dir" -}}
{{- printf "%s%s" (include "dolphinscheduler.worker.base.dir" .) "/download" -}}
{{- end -}}

{{/*
Create a default dolphinscheduler worker process exec dir.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dolphinscheduler.worker.process.exec.dir" -}}
{{- printf "%s%s" (include "dolphinscheduler.worker.base.dir" .) "/exec" -}}
{{- end -}}