# Sample Service

Endpoints:
- `/` normal traffic
- `/slow` higher latency
- `/error` 500s
- `/health` health check

The service emits DogStatsD metrics:
- `demo.requests`
- `demo.errors`
- `demo.latency_ms`

Tags: `service`, `env`, `version`, `endpoint`, `status`, `latency_bucket`.
