variable "provider_region" {
  type = string
  # default = "ap-southeast-1"
  default     = null
  description = "required at the provider declaration"
}

variable "vpc_cidr" {
  # default     = "10.0.0.0/16"
  type        = string
  default     = null
  description = "CIDR ip reservation for the VPC"
}

variable "subnet" {
  type    = list(string)
  default = []
  # default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
  description = "CIDR IP reservation for the subnet"
}

variable "availability_zone" {
  type = list(string)
  # default     = ["ap-southeast-1a", "ap-southeast-1b"]
  default     = []
  description = "AZ on which the application will be deployed"
}