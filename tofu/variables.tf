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

variable "instances" {
  description = "Object containing details about the instance to be created"
  type = map(object({
    enable_detailed_monitoring = optional(bool)
    volume_size                = number
    instance_type              = string
    additional_tags            = optional(map(string))
  }))
  nullable = false

  validation {
    condition     = alltrue([for name, config in var.instances : can(regex("^[a-z0-9-]+$", name))])
    error_message = "The following instances have an invalid name: ${format("%#v", [for name, config in var.instances : name if !can(regex("^[a-z0-9-]+$", name))])}. Ensure your instance names are alphanumeric and lowercase!"
  }

  validation {
    condition     = alltrue([for name, config in var.instances : contains(["t3.micro"], config.instance_type)])
    error_message = "The following instances have an invalid instance type: ${format("%#v", [for name, config in var.instances : name if config.instance_type == "t3.micro"])}. Allowed values are: ${format("%#v", ["t3.micro"])}!"
  }

  validation {
    condition     = alltrue([for name, config in var.instances : config.volume_size <= 30])
    error_message = "The following instances have a volume size bigger than 30GB: ${format("%#v", [for name, config in var.instances : name if config.volume_size > 30])}. Ensure your volumes are 30GB or lower!"
  }
}
