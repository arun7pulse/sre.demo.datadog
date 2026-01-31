# Architecture

## Overview
- `apps/sample-service` emits DogStatsD metrics to the Datadog agent.
- `infra/environments/*` applies monitors and SLOs as code via Terraform.
- `ops/service-catalog` holds service definition assets.

## Signals
- `demo.requests` counts requests
- `demo.errors` counts 5xx responses
- `demo.latency_ms` records latency in milliseconds

Tags: `service`, `env`, `version`, `endpoint`, `status`, `latency_bucket`.
