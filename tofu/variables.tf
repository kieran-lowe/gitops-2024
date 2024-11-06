variable "environment" {
  type        = string
  description = "Name of the environment infrastrucutre is being deployed to"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
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

variable "instance_name" {
  type        = string
  description = "Name of the Grafana instance"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.instance_name))
    error_message = "${format("%#v", var.instance_name)} is not a valid instance name. Ensure your instance name is alphanumeric and lowercase!"
  }
}

variable "instance_type" {
  type        = string
  description = "Instance size to use for the Grafana server"

  validation {
    condition     = contains(["t3.micro"], var.instance_type)
    error_message = "${format("%#v", var.instance_type)} is not a valid instance type. Allowed values are: ${format("%#v", ["t3.micro"])}!"
  }
}

variable "volume_size" {
  type        = number
  description = "Size of the root EBS volume (in GB) for the Grafana instance"
  default     = 8

  validation {
    condition     = var.volume_size <= 10
    error_message = "${format("%#v", var.volume_size)} is not valid! It must be less than or equal to 10."
  }
}

variable "additional_tags" {
  type        = map(string)
  description = "Apply additional tags to Grafana instance"

  validation {
    condition     = alltrue([for key in keys(var.additional_tags) : can(regex("^[a-z0-9-]+$", key))])
    error_message = "All keys in your additional tags must be alphanumeric and lowercase! If word seperation is present, use hyphens (-)."
  }

  validation {
    condition     = anytrue([for key in keys(var.additional_tags) : startswith("aws:", key)]) ? false : true
    error_message = "You cannot use tags that begin with 'aws:' as they are reserved for AWS use."
  }

  validation {
    condition     = alltrue([for key in keys(var.additional_tags) : length(key) >= 1 && length(key) <= 128])
    error_message = "All keys in your additional tags must be at least 1 character long and no more than 128 characters long."
  }

  validation {
    condition     = alltrue([for value in values(var.additional_tags) : length(value) >= 0 && length(value) <= 256])
    error_message = "All values in your additional tags must be at least 0 characters long and no more than 256 characters long."
  }
}

variable "deployment_role_arn" {
  type        = string
  description = "The ARN of the role to assume when deploying resources"

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9+=,.@_-]+$", var.deployment_role_arn))
    error_message = "${format("%#v", var.deployment_role_arn)} is not a valid ARN!"
  }
}

variable "role_session_name" {
  type        = string
  description = "The name of the session when assuming the role"

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.role_session_name))
    error_message = "${format("%#v", var.role_session_name)} is not a valid session name!"
  }
}
