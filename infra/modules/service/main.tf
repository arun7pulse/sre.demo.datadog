variable "service_name" { type = string }
variable "team" { type = string }
variable "repo_url" { type = string }
variable "slack_channel" { type = string }
variable "tier" { type = string }
variable "service_lifecycle" { type = string }
variable "environment" { type = string }

resource "datadog_service_definition_yaml" "service" {
  service_definition = templatefile("${path.module}/service-definition.tftpl", {
    service_name  = var.service_name
    team          = var.team
    repo_url      = var.repo_url
    slack_channel = var.slack_channel
    tier          = var.tier
    lifecycle     = var.service_lifecycle
    environment   = var.environment
  })
}

output "service_definition_id" {
  value = datadog_service_definition_yaml.service.id
}
