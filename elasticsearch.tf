data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

data "aws_subnet_ids" "selected" {
  vpc_id = "${var.vpc_id}"

  # tags {
  #   Tier = "private"
  # }
}

# This security group controls IP-based access.
resource "aws_security_group" "elasticsearch" {
  name        = "${var.domain}-elasticsearch"
  description = "Managed by Terraform"
  vpc_id      = "${data.aws_vpc.selected.id}"

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["${data.aws_vpc.selected.cidr_block}"]
  }
}

resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "main" {
  domain_name           = "${var.domain}"
  elasticsearch_version = "${var.elasticsearch_version}"

  # Configure how many, and how big instances of ES we want to run
  cluster_config {
    instance_type  = "${var.elasticsearch_instance_type}"
    instance_count = "${var.elasticsearch_instance_count}"
  }

  # How much storage space do we want to dedicate? For larger instances we don't need to use EBS.
  ebs_options = {
    ebs_enabled = true
    volume_size = "${var.elasticsearch_volume_size}"
  }

  # Security! We need to make sure the ES is only accessible from hosts inside the correct VPC.
  # The first step is to make sure the cluster is also inside the VPC, so that it can be connected to.
  vpc_options {
    subnet_ids         = ["${var.subnet_ids}"]
    security_group_ids = ["${aws_security_group.elasticsearch.id}"]
  }

  depends_on = [
    "aws_iam_service_linked_role.es",
  ]
}

resource "aws_elasticsearch_domain_policy" "allow_anything_aws" {
  domain_name = "${aws_elasticsearch_domain.main.domain_name}"

  access_policies = <<POLICIES
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal":  {
              "AWS": "*"
            },
            "Effect": "Allow",            
            "Resource": "${aws_elasticsearch_domain.main.arn}/*"
        }
    ]
}
POLICIES
}
