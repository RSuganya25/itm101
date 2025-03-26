resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI ID (us-east-1)
  instance_type = "t2.micro"                # Choose instance size (t2.micro for free tier)

  tags = {
    Name = "DockerAppServer"
  }

  # User data to install Docker and run a web app
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y docker
              sudo service docker start
              sudo systemctl enable docker
              sudo docker run -d -p 80:80 --name webapp nginx
              EOF
}

# Output the instance's public IP
output "instance_ip" {
  value = aws_instance.web_server.public_ip
}
