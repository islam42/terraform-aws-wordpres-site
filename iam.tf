# resource "aws_iam_role" "s3-access" {
#   name = "s3-access"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = "sts:AssumeRole",
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })

#   tags = local.common_tags
# }

# resource "aws_iam_policy" "s3-access-policy" {
#   name        = "s3-access-policy"
#   description = "Allow EC2 instances to access S3 bucket"
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "s3:GetObject",
#           "s3:PutObject"
#         ],
#         Resource = [
#           "arn:aws:s3:::${local.s3_bucket_name}/*"
#         ]
#       }
#     ]
#   })

#   tags = local.common_tags
# }

# resource "aws_iam_role_policy_attachment" "s3-access-policy-attachment" {
#   role       = aws_iam_role.s3-access.name
#   policy_arn = aws_iam_policy.s3-access-policy.arn
# }

# resource "aws_iam_instance_profile" "ec2-s3-access" {
#   name = "ec2-s3-access"
#   role = aws_iam_role.s3-access.name

#   tags = local.common_tags
# }
