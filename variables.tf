variable "aws_region" {
  description = "AWS region where resources will be created"
  default     = "eu-central-1"
}

variable "ami_id" {
  description = "Amazon Machine Image ID used to launch EC2 instances"
  default     = "ami-0faab6bdbac9486fb"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "user_keypair_name" {
  description = "Name of the existing AWS Key Pair for SSH access"
  default     = "id_rsa"
}

variable "additional_ssh_key" {
  description = "Path to an additional public SSH key to be added to the servers"
  default     = "~/.ssh/id_ed25519.pub"
}

variable "db_ports" {
  description = "List of database ports that are allowed for inbound traffic between servers"
  type        = list(number)
  default     = [5432, 5433, 5434, 5435]
}
