locals {
  service_name = var.service_name
  env          = var.env
  team         = var.team
  tags = [
    "service:${var.service_name}",
    "env:${var.env}",
    "team:${var.team}",
  ]
}

module "service_definition" {
  source = "../../modules/service"

  service_name  = local.service_name
  team          = local.team
  repo_url      = var.repo_url
  slack_channel = var.slack_channel
  tier          = "tier-2"
  service_lifecycle = "production"
  environment   = local.env
}

module "slo_availability" {
  source = "../../modules/slo"

  name        = "${local.env}_${local.service_name} availability"
  description = "Availability SLO based on request success rate."
  tags        = local.tags
  target      = 99.9
  warning     = 99.95
  timeframe   = "30d"

  good_query  = "sum:demo.requests{service:${local.service_name},env:${local.env},status:200,latency_bucket:lt_300}.as_count()"
  total_query = "sum:demo.requests{service:${local.service_name},env:${local.env}}.as_count()"
}

module "slo_latency" {
  source = "../../modules/slo"

  name        = "${local.env}_${local.service_name} latency"
  description = "Latency SLO based on 95th percentile response time."
  tags        = local.tags
  target      = 95
  warning     = 97
  timeframe   = "30d"

  good_query  = "sum:demo.requests{service:${local.service_name},env:${local.env},status:200}.as_count()"
  total_query = "sum:demo.requests{service:${local.service_name},env:${local.env}}.as_count()"
}

module "monitor_error_rate" {
  source = "../../modules/alerts"

  name        = "${local.env}_${local.service_name} error rate"
  message     = "Error rate above 5% on ${local.service_name} (${local.env}). Notify: ${var.slack_channel}"
  query       = "avg(last_5m):100 * (sum:demo.errors{service:${local.service_name},env:${local.env}}.as_count() / sum:demo.requests{service:${local.service_name},env:${local.env}}.as_count()) > 5"
  tags        = local.tags
  alert_type  = "query alert"
  priority    = 3
}

module "monitor_latency" {
  source = "../../modules/alerts"

  name        = "${local.env}_${local.service_name} latency p95"
  message     = "Latency p95 above 300ms on ${local.service_name} (${local.env}). Notify: ${var.slack_channel}"
  query       = "avg(last_5m):p95:demo.latency_ms{service:${local.service_name},env:${local.env}} > 300"
  tags        = local.tags
  alert_type  = "query alert"
  priority    = 3
}
