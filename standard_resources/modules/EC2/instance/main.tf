# Create a new instance of the latest Ubuntu 14.04 on an
# t2.micro node with an AWS Tag naming it "HelloWorld"
provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "user_data_script" {
  type = string
  default = "bootstraping.sh" 
}

variable "instance_profile" {
  type = string
  default = null
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = var.instance_type
  iam_instance_profile = var.instance_profile
  key_name = "burdaforward-ec2"
  tags = {
    Name = "HelloWorld"
  }
  user_data = "${file(var.user_data_script)}"
}
