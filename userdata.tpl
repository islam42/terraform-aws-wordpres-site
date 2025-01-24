 #!/bin/bash
yum update -y
yum install httpd -y
sudo aws s3 cp s3://${s3_bucket_name}/website/index.html /var/www/html/index.html
sudo aws s3 cp s3://${s3_bucket_name}/website/graphics/logo.png /var/www/html/logo.png
systemctl start httpd
systemctl enable httpd
#echo "<h1>Welcome to Terraform Server 2</h1>" > /var/www/html/index.html