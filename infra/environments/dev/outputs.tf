output "service_definition_id" {
  value = module.service_definition.service_definition_id
}

output "slo_availability_id" {
  value = module.slo_availability.slo_id
}

output "slo_latency_id" {
  value = module.slo_latency.slo_id
}

output "monitor_error_rate_id" {
  value = module.monitor_error_rate.monitor_id
}

output "monitor_latency_id" {
  value = module.monitor_latency.monitor_id
}
