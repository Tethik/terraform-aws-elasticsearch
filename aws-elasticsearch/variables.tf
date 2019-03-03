variable "domain" {
  type = "string"
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
  type = "string"
}

variable "subnet_ids" {
  type = "list"
}
