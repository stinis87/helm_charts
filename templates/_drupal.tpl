{{/*
Return the proper Drupal image name
*/}}
{{- define "drupal.image" -}}
{{- include "kub2.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the MariaDB Hostname
*/}}
{{- define "drupal.databaseHost" -}}
{{- if .Values.mariadb.enabled }}
    {{- if eq .Values.mariadb.architecture "replication" }}
        {{- printf "%s-%s" (include "drupal.mariadb.fullname" .) "primary" | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- if .Values.mariadb.fullnameOverride -}}
            {{- printf "%s" .Values.mariadb.fullnameOverride | trunc 63 | trimSuffix "-" -}}
        {{- else -}}
            {{- printf "%s" (include "drupal.mariadb.fullname" .) -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "drupal.mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default name for database secrets.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "drupal.mariadb.secret" -}}
{{- if .Values.mariadb.fullnameOverride -}}
    {{- printf "%s" .Values.mariadb.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
    {{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the database password key
*/}}
{{- define "drupal.databasePasswordKey" -}}
{{- if .Values.mariadb.enabled -}}
mariadb-password
{{- else -}}
db-password
{{- end -}}
{{- end -}}

{{/*
Return  the proper Storage Class
*/}}
{{- define "drupal.storageClass" -}}
{{- include "common.storage.class" (dict "persistence" .Values.persistence "global" .Values.global) -}}
{{- end -}}

# drupal.imagePullSecrets
{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "drupal.imagePullSecrets" -}}
#{{- include "images.renderPullSecrets" ( dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- include "images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image .Values.certificates.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "drupal.volumePermissions.image" -}}
{{- include "images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}