resource "aws_s3_bucket" "website-s3" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = var.tags
}

# resource "aws_s3_bucket_acl" "website-s3-acl" {
#   bucket = aws_s3_bucket.website-s3.bucket
#   acl    = "private"
# }

resource "aws_s3_bucket_policy" "alb-access-logs-policy" {
  bucket = aws_s3_bucket.website-s3.bucket
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
        #   AWS = data.aws_elb_service_account.root.arn
          AWS = var.elb_instance_service_role
        },
        Action   = "s3:PutObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.website-s3.bucket}/alb-logs/*"
      },
      {
        Effect = "Allow",
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        },
        Action   = "s3:GetBucketAcl",
        Resource = "arn:aws:s3:::${aws_s3_bucket.website-s3.bucket}"
      },
      {
        Effect = "Allow",
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        },
        Action   = "s3:PutObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.website-s3.bucket}/alb-logs/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role" "s3-access" {
  name = "s3-access"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "s3-access-policy" {
  name        = "s3-access-policy"
  description = "Allow EC2 instances to access S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = [
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "s3-access-policy-attachment" {
  role       = aws_iam_role.s3-access.name
  policy_arn = aws_iam_policy.s3-access-policy.arn
}

resource "aws_iam_instance_profile" "ec2-s3-access" {
  name = "ec2-s3-access"
  role = aws_iam_role.s3-access.name

  tags = var.tags
}
