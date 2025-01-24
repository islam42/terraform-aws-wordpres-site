# variable "aws_access_key" {
#   type        = string
#   description = "value of access key for AWS account"
#   sensitive   = true
# }

# variable "aws_secret_key" {
#   type        = string
#   description = "value of secret key for AWS account"
#   sensitive   = true
# }

variable "region" {
  type        = string
  description = "region where resources will be created"
  default     = "us-east-1"
}

variable "aws_instance_count" {
  type        = map(number)
  description = "Number of instances to create"
}

variable "vpc_cidr_block" {
  type        = map(string)
  description = "CIDR block for VPC"
}

variable "vpc_subnet_mask" {
  type        = number
  description = "CIDR subnet mask for Subnet"
}

variable "vpc_subnet_count" {
  type        = number
  description = "Number of subnets to create"
}

variable "aws_instance_type" {
  type        = string
  description = "Instance type for EC2"
}

variable "enable_dns_hostnames" {
  type        = string
  description = "Enable DNS hostnames for VPC"
  default     = "true"

}

variable "map_public_ip_on_launch" {
  type        = string
  description = "Map public IP on launch for subnet"
  default     = "true"
}

variable "project" {
  type        = string
  description = "Name of the project"
}

variable "company" {
  type        = string
  description = "Name of the company"
  default     = "arcloudops"
}

variable "billing_code" {
  type        = string
  description = "Billing code for the project"
}