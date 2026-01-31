# Demo runbook

## Flow
1) Start the service and Datadog agent (Docker compose).
2) Generate traffic (normal, slow, and error routes).
3) Apply Terraform in `infra/environments/dev` to create SLOs and monitors.
4) Show SLO burn and alert triggers in Datadog.

## Quick commands
- `docker compose -f apps/sample-service/docker-compose.yml --env-file apps/sample-service/.env up --build`
- `curl http://localhost:8080/`
- `curl http://localhost:8080/slow`
- `curl http://localhost:8080/error`
