provider "aws" {
  region = "us-east-1"
}

# Define Key Pair
resource "aws_key_pair" "server_key" {
  key_name   = "server_key_new"  # Unique name for the key pair
  public_key = file("~/.ssh/id_rsa.pub")  # Path to your public key (adjust if needed)
}

# Define Security Group for SSH and HTTP access
resource "aws_security_group" "web_server_sg" {
  name        = "web_server_sg"
  description = "Allow SSH and HTTP access"
  vpc_id      = "vpc-059491580e941a250"  # Replace with your actual VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define EC2 Instance for the web server
resource "aws_instance" "web_server" {
  ami                    = "ami-0004c164b2bb803ba"  # Amazon Linux 2 AMI ID (us-east-1)
  instance_type          = "t2.micro"                # Choose instance size (t2.micro for free tier)
  key_name               = aws_key_pair.server_key.key_name  # Reference the SSH key pair
  security_groups        = [aws_security_group.web_server_sg.name]  # Attach the security group
  associate_public_ip_address = true  # Assign a public IP to the instance

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
