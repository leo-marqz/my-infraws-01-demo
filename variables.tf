
variable "virginia_cidr_block" {
  description = "The CIDR block for the Virginia VPC"
  type        = string
}

variable "virginia_subnets" {
  description = "The CIDR blocks for the Virginia VPC subnets"
  type        = list(string)
}

variable "virginia_azs" {
  description = "The availability zones for the Virginia VPC"
  type        = list(string)
}