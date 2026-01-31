variable "name" { type = string }
variable "description" { type = string }
variable "tags" { type = list(string) }
variable "target" { type = number }
variable "warning" { type = number }
variable "timeframe" { type = string }
variable "good_query" { type = string }
variable "total_query" { type = string }

resource "datadog_service_level_objective" "this" {
  name        = var.name
  description = var.description
  type        = "metric"
  tags        = var.tags

  query {
    numerator   = var.good_query
    denominator = var.total_query
  }

  thresholds {
    timeframe = var.timeframe
    target    = var.target
    warning   = var.warning
  }
}

output "slo_id" {
  value = datadog_service_level_objective.this.id
}
