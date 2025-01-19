output "website_bucket" {
  value = aws_s3_bucket.website-s3
}

output "instance_profile" {
    value = aws_iam_instance_profile.ec2-s3-access
}   
