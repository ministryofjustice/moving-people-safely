{{/* vim: set filetype=mustache: */}}
{{/*
Environment variables for web and worker containers
*/}}
{{- define "deployment.envs" }}
env:
  - name: AWS_ACCESS_KEY_ID
    valueFrom:
      secretKeyRef:
        name: mps-storage-s3-bucket-output
        key: access_key_id

  - name: AWS_SECRET_ACCESS_KEY
    valueFrom:
      secretKeyRef:
        name: mps-storage-s3-bucket-output
        key: secret_access_key

  - name: S3_BUCKET_NAME
    valueFrom:
      secretKeyRef:
        name: mps-storage-s3-bucket-output
        key: bucket_name

  - name: DB_NAME
    valueFrom:
      secretKeyRef:
        name: dps-rds-instance-output
        key: database_name

  - name: DB_HOST
    valueFrom:
      secretKeyRef:
        name: dps-rds-instance-output
        key: rds_instance_address

  - name: DB_USERNAME
    valueFrom:
      secretKeyRef:
        name: dps-rds-instance-output
        key: database_username

  - name: MOVING-PEOPLE-SAFELY_DATABASE_PASSWORD
    valueFrom:
      secretKeyRef:
        name: dps-rds-instance-output
        key: database_password

  - name: SMTP_DOMAIN
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: SMTP_DOMAIN

  - name: SMTP_HOSTNAME
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: SMTP_HOSTNAME

  - name: SMTP_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: SMTP_PASSWORD

  - name: SMTP_PORT
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: SMTP_PORT

  - name: SMTP_USERNAME
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: SMTP_USERNAME

  - name: SERVICE_URL
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: SERVICE_URL

  - name: OFFENDERS_API_CLIENT_ID
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: OFFENDERS_API_CLIENT_ID

  - name: OFFENDERS_API_CLIENT_SECRET
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: OFFENDERS_API_CLIENT_SECRET

  - name: SENTRY_DSN
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: SENTRY_DSN

  - name: ZENDESK_URL
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: ZENDESK_URL

  - name: ZENDESK_USERNAME
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: ZENDESK_USERNAME

  - name: ZENDESK_TOKEN
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: ZENDESK_TOKEN

  - name: SECRET_KEY_BASE 
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: SECRET_KEY_BASE

  - name: MOJSSO_ID
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: MOJSSO_ID

  - name: MOJSSO_SECRET
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: MOJSSO_SECRET

  - name: MOJSSO_URL
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: MOJSSO_URL

  - name: OAUTH_ENDPOINT_URL
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: OAUTH_ENDPOINT_URL

  - name: NOMIS_API_HOST
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: NOMIS_API_HOST

  - name: NOMIS_API_CLIENT_ID
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: NOMIS_API_CLIENT_ID

  - name: NOMIS_API_CLIENT_SECRET
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: NOMIS_API_CLIENT_SECRET

  - name: GECKOBOARD_API_KEY
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: GECKOBOARD_API_KEY

  - name: GECKOBOARD_DATASET_PREFIX
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: GECKOBOARD_DATASET_PREFIX

  - name: RAILS_SERVE_STATIC_FILES
    value: "true"

{{- end -}}
