variable "environment" {
  type        = string
  description = "Name of the environment infrastrucutre is being deployed to"

  validation {
    condition     = contains(["mgmt", "dev", "test", "prod"], var.environment)
    error_message = "${format("%#v", var.environment)} is not a valid environment. Allowed values are: ${format("%#v", ["mgmt", "dev", "test", "prod"])}!"
  }
}

variable "region" {
  type        = string
  description = "AWS region to deploy resources to"

  validation {
    condition     = contains(["eu-west-2"], var.region)
    error_message = "${format("%#v", var.region)} is not a valid region. Allowed values are: ${format("%#v", ["eu-west-2"])}!"
  }
}
