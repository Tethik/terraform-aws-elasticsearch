module "aws-elasticsearch" {
  source = "./aws-elasticsearch"

  domain     = "example"
  vpc_id     = "vpc-6071d40b"
  subnet_ids = ["subnet-a5bcd2ce"]
}

module "aws-elasticsearch-cloudwatch-dashboard" {
  source = "./aws-elasticsearch-cloudwatch-dashboard"

  domain = "example"
}

module "aws-elasticsearch-cloudwatch-sns-alerting" {
  source = "./aws-elasticsearch-cloudwatch-sns-alerting"

  domain       = "example"
  alarms_email = "tethik@blacknode.se"
}

# Allow for any connections to the elasticsearch cluster to help make debugging easier.
resource "aws_elasticsearch_domain_policy" "allow_anything_aws" {
  domain_name = "${module.aws-elasticsearch.main.domain_name}"

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
            "Resource": "${module.aws-elasticsearch.main.domain_name.arn}/*"
        }
    ]
}
POLICIES
}
