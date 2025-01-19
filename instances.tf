# instances

resource "aws_instance" "nginx-instances" {
  count         = var.aws_instance_count[terraform.workspace]
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = var.aws_instance_type
  #   subnet_id              = aws_subnet.subnets[(count.index % var.vpc_subnet_count)].id
  subnet_id              = module.vpc.public_subnets[(count.index % var.vpc_subnet_count)]
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  #   depends_on = [aws_iam_instance_profile.ec2-s3-access]
  depends_on = [module.web_app_s3]

  #   iam_instance_profile = aws_iam_instance_profile.ec2-s3-access.name
  iam_instance_profile = module.web_app_s3.instance_profile.name

  key_name = "islam"

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-instance" })

  user_data = templatefile("${path.module}/userdata.tpl", {
    s3_bucket_name = module.web_app_s3.website_bucket.id
  })
}
