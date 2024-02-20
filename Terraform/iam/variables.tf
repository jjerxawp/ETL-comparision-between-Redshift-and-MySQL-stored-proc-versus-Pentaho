variable "role_name" {
  type    = string
  default = null
}

variable "role_assume" {
  default = null
}

variable "policy_arns" {
  type    = map(string)
  default = {}
}