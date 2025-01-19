output "aws_alb_public_dns" {
  value = aws_lb.nginx-lb.dns_name
}