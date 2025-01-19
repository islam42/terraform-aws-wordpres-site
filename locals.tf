locals {
  common_tags = {
    company      = var.company
    project      = "${var.company} - ${var.project}"
    billing_code = var.billing_code
  }

  s3_bucket_name = "${local.name_prefix}-website-s3-bucket"

  name_prefix = "arcloudops-${terraform.workspace}"
} 