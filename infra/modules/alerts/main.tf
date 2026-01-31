variable "name" { type = string }
variable "message" { type = string }
variable "query" { type = string }
variable "tags" { type = list(string) }
variable "alert_type" { type = string }
variable "priority" { type = number }

resource "datadog_monitor" "this" {
  name     = var.name
  type     = var.alert_type
  message  = var.message
  query    = var.query
  tags     = var.tags
  priority = var.priority

  notify_no_data = false
  renotify_interval = 0
  include_tags = true
}

output "monitor_id" {
  value = datadog_monitor.this.id
}
