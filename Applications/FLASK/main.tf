Panoss-Air:GrafanaServer panosstrouth$ cat main.tf 
# Create a new instance of the latest Ubuntu 14.04 on an
# t2.micro node with an AWS Tag naming it "HelloWorld"
provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
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


#resource "aws_instance" "web" {
#  ami           = "${data.aws_ami.ubuntu.id}"
#  instance_type = var.instance_type
#  iam_instance_profile = "${aws_iam_instance_profile.grafana_server_profile.name}"
#  key_name = "burdaforward-ec2"
#  tags = {
#    Name = "HelloWorld"
#  }
#  user_data = "${file("bootstraping.sh")}"
#}

module "flask_server" {
  source = "../../modules/EC2/instance" 
  instance_tag_name = "FLASKServer"
}
