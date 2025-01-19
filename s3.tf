# resource "aws_s3_bucket" "website-s3" {
#   bucket        = local.s3_bucket_name
#   force_destroy = true

#   tags = local.common_tags
# }

# resource "aws_s3_bucket_acl" "website-s3-acl" {
#   bucket = aws_s3_bucket.website-s3.bucket
#   acl    = "private"
# }

module "web_app_s3" {
  source                    = "./modules/s3"
  bucket_name               = local.s3_bucket_name
  elb_instance_service_role = data.aws_elb_service_account.root.arn
  tags                      = local.common_tags
}

resource "aws_s3_object" "website_s3_objects" {
  for_each = {
    index = "index.html"
    logo  = "graphics/logo.png"
  }
  bucket = module.web_app_s3.website_bucket.id
  key    = "website/${each.value}"
  source = "./website/${each.value}"
  acl    = "private"
}
