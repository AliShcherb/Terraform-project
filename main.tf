provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "servers_sg" {
  name        = "servers-sg"
  description = "Allow SSH and DB ports"

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "db_ports" {
  for_each = { for port in var.db_ports : port => port }

  type                     = "ingress"
  from_port                = each.value
  to_port                  = each.value
  protocol                 = "tcp"
  security_group_id        = aws_security_group.servers_sg.id
  source_security_group_id = aws_security_group.servers_sg.id
}


resource "aws_instance" "servers" {
  count         = 2
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.user_keypair_name
  vpc_security_group_ids = [aws_security_group.servers_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "${file(var.additional_ssh_key)}" >> /home/ubuntu/.ssh/authorized_keys
              chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys
              chmod 600 /home/ubuntu/.ssh/authorized_keys
              EOF


  tags = {
    Name = "server-${count.index + 1}"
  }
}
