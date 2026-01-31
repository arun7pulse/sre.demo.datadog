output "service_definition_id" {
  value = module.service_definition.service_definition_id
}

output "availability_slo_id" {
  value = module.availability_slo.slo_id
}

output "latency_slo_id" {
  value = module.latency_slo.slo_id
}

output "error_rate_monitor_id" {
  value = module.error_rate_monitor.monitor_id
}

output "latency_monitor_id" {
  value = module.latency_monitor.monitor_id
}
