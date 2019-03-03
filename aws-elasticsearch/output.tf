output "kibana_endpoint" {
  depends_on = ["${aws_elasticsearch_domain.main}"]
  value      = ["${aws_elasticsearch_domain.main.kibana_endpoint}"]
}

output "elasticsearch_endpoint" {
  depends_on = ["${aws_elasticsearch_domain.main}"]
  value      = ["${aws_elasticsearch_domain.main.endpoint}"]
}
