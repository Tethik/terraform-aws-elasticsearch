variable "domain" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "subnet_id" {
  type = "string"
}

variable "alarms_email" {
  type = "string"
}

module "aws-elasticsearch" {
  source = "git::git@github.com:Tethik/terraform-aws-elasticsearch.git//aws-elasticsearch?ref=0.1.1"

  #   source = "./aws-elasticsearch"

  domain     = "${var.domain}"
  vpc_id     = "${var.vpc_id}"
  subnet_ids = ["${var.subnet_id}"]
}

module "aws-elasticsearch-cloudwatch-dashboard" {
  source = "git::git@github.com:Tethik/terraform-aws-elasticsearch.git//aws-elasticsearch-cloudwatch-dashboard?ref=0.1.1"

  #   source = "./aws-elasticsearch-cloudwatch-dashboard"

  domain = "${var.domain}"
}

module "aws-elasticsearch-cloudwatch-sns-alerting" {
  source = "git::git@github.com:Tethik/terraform-aws-elasticsearch.git//aws-elasticsearch-cloudwatch-sns-alerting?ref=0.1.1"

  #   source = "./aws-elasticsearch-cloudwatch-sns-alerting"

  domain       = "${var.domain}"
  alarms_email = "${var.alarms_email}"
}

# Allow for any connections to the elasticsearch cluster to help make debugging easier.
resource "aws_elasticsearch_domain_policy" "allow_anything_aws" {
  domain_name = "${var.domain}"

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
            "Resource": "${module.aws-elasticsearch.elasticsearch_domain_arn}/*"
        }
    ]
}
POLICIES
}

output "kibana_endpoint" {
  depends_on = ["${module.aws-elasticsearch}"]
  value      = "${module.aws-elasticsearch.kibana_endpoint}"
}

output "elasticsearch_endpoint" {
  depends_on = ["${module.aws-elasticsearch.main}"]
  value      = "${module.aws-elasticsearch.elasticsearch_endpoint}"
}
