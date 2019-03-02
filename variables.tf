variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  type    = "string"
  default = "eu-central-1"
}

# ElasticSearch Domain vars

variable "domain" {
  type    = "string"
  default = "example"
}

variable "elasticsearch_version" {
  type    = "string"
  default = "6.4"
}

variable "elasticsearch_instance_type" {
  type    = "string"
  default = "t2.small.elasticsearch"
}

variable "elasticsearch_instance_count" {
  type    = "string"
  default = 1
}

variable "elasticsearch_volume_size" {
  type    = "string"
  default = 10
}

variable "vpc_id" {
  type    = "string"
  default = "vpc-6071d40b"
}

variable "subnet_ids" {
  type    = "list"
  default = ["subnet-a5bcd2ce"]
}
