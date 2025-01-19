variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the S3 bucket"
  default     = {}
}

variable "elb_instance_service_role" {
  type        = string
  description = "Name of the ELB instance service role"
}
