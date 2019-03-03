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
