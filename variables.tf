variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "security_groups" {
  description = "The attribute of security_groups information"
  type = list(object({
    name        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 22
    name        = "Allow incoming ssh connections"
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    }, {
    from_port   = 443
    name        = "Allow incoming HTTPS connections"
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    }, {
    from_port   = 80
    name        = "Allow incoming HTTP connections"
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "ubuntu_ami" {
  description = "ubuntu ami"
  type        = string
  default     = "ami-03f4fa076d2981b45" # ap-northeast-1 Ubuntu Server 22.04 LTS (HVM),EBS General Purpose (SSD) Volume Type.
}

variable "ec2" {
  description = "The attribute of EC2 information"
  type = object({
    name              = string
    os_type           = string
    instance_type     = string
    volume_size       = number
    volume_type       = string
    availability_zone = string
  })
  default = {
    # https://aws.amazon.com/jp/ec2/instance-types/
    instance_type     = "t2.medium"
    name              = "taxin-docker"
    os_type           = "ubuntu"
    volume_size       = 20
    volume_type       = "gp3"
    availability_zone = "ap-northeast-1a"
  }
}
