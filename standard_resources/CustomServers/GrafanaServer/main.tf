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

module "grafana_server" {
  source = "../../modules/EC2/instance"

  instance_profile = "${aws_iam_instance_profile.grafana_server_profile.name}" 
}


# First role, for the server itself
resource aws_iam_role metrics_server {
  name               = "metrics-server-role"
  assume_role_policy = "${data.aws_iam_policy_document.metrics_server_assume_role.json}"
}

# Trust policy document allowing EC2 service to adopt this role
data aws_iam_policy_document metrics_server_assume_role {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type = "Service"
    }

    effect  = "Allow"
  }
}

# Second role, to give to Grafana
resource aws_iam_role grafana_datasource {
  name               = "grafana-datasource-role"
  assume_role_policy = "${data.aws_iam_policy_document.grafana_datasource_assume_role.json}"
}

# Trust policy document to allow Grafana, running in the metric server EC2 instance, to assume this role
data aws_iam_policy_document grafana_datasource_assume_role {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["${aws_iam_role.metrics_server.arn}"]
      type = "AWS"
    }

    effect  = "Allow"
  }
}

# Policy attachment to allow Grafana the rights to get metrics, etc, cf., https://grafana.com/docs/features/datasources/cloudwatch/
resource aws_iam_role_policy grafana_datasource {
  role = "${aws_iam_role.grafana_datasource.name}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowReadingMetricsFromCloudWatch",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:GetMetricData"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowReadingTagsInstancesRegionsFromEC2",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeTags",
                "ec2:DescribeInstances",
                "ec2:DescribeRegions"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowReadingResourcesForTags",
            "Effect" : "Allow",
            "Action" : "tag:GetResources",
            "Resource" : "*"
        }
    ]
}
EOF
}

# IAM Instance profile for use when setting up the EC2 instance
resource aws_iam_instance_profile metrics_server {
  name = "${aws_iam_role.metrics_server.name}"
  role = "${aws_iam_role.metrics_server.name}"
}


resource "aws_iam_instance_profile" "grafana_server_profile" {
  name = "grafana_server_profile"
  role = "${aws_iam_role.metrics_server.name}"
}

