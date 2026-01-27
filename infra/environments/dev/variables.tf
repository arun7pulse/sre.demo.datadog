variable "datadog_api_key" {
  type      = string
  sensitive = true
}

variable "datadog_app_key" {
  type      = string
  sensitive = true
}

variable "datadog_api_url" {
  type    = string
  default = null
}

variable "env" {
  type    = string
  default = "dev"
}

variable "service_name" {
  type    = string
  default = "sample-api"
}

variable "team" {
  type    = string
  default = "sre-demo"
}

variable "repo_url" {
  type    = string
  default = "https://example.com/sre.demo.datadog"
}

variable "slack_channel" {
  type    = string
  default = "#sre-demo"
}
