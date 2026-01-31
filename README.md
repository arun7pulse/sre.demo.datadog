# Observability as Code Demo (Datadog + Terraform)

Production-style repo for a tech session showing a sample service, Datadog monitors, and SLOs managed as code.

## Repo layout
- `apps/` sample services
- `infra/` Terraform modules and environment stacks
- `ops/` runbooks, dashboards, service catalog
- `docs/` architecture notes and demo guide
- `scripts/` helper scripts

## Quick start (local demo)
1) Copy env file and fill in Datadog credentials.
   - `apps/sample-service/.env.example` -> `apps/sample-service/.env`
2) Start the service + Datadog agent:
   - `docker compose -f apps/sample-service/docker-compose.yml --env-file apps/sample-service/.env up --build`
3) Generate traffic:
   - `curl http://localhost:8080/`
   - `curl http://localhost:8080/slow`
   - `curl http://localhost:8080/error`

## Terraform (Dev)
1) Copy `infra/environments/dev/terraform.tfvars.example` to `infra/environments/dev/terraform.tfvars` and fill values.
2) From `infra/environments/dev`:
   - `terraform init`
   - `terraform plan`
   - `terraform apply`
3) List created resources:
   - `terraform output`

## Datadog API URL
Set `datadog_api_url` in `infra/environments/*/terraform.tfvars` if you are not on US1:
- US1: omit or set `null`
- US5: `https://api.us5.datadoghq.com`
- EU: `https://api.datadoghq.eu`

## Notes
- The sample SLOs and monitors rely on DogStatsD metrics emitted by the service.
- Use tags `service`, `env`, `version`, and `latency_bucket` consistently across metrics, logs, and traces.
- Never commit Datadog keys; keep them in `.env` and `terraform.tfvars` only.
