# terraform-aws-elasticsearch

Task:

```
Search and monitor.

You will have to create a Terraform module that deploys (preferably on AWS) and manages an ElasticSearch (ES) cluster.

The ES cluster should be easily monitored and alerting should be possible.

Everything should be documented thoroughly.

Bonuses:
 - Easy way to display the data
 - Any other bonuses are welcome!
```

## Testing

The AWS documentation describes a good way to test that the cluster works from inside the VPC.
https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-vpc.html#kibana-test

Set the access policy to allow for anything coming from AWS (inside the VPC):

```tf
resource "aws_elasticsearch_domain_policy" "allow_anything_aws" {
  domain_name = "${aws_elasticsearch_domain.main.domain_name}"

  access_policies = <<POLICIES
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal":  {
              "AWS": "*",
            }
            "Effect": "Allow",
            "Resource": "${aws_elasticsearch_domain.main.arn}/*"
        }
    ]
}
POLICIES
}
```

Use an instance inside the VPC as a proxy. E.g.

```
ssh <user@ip> -N -L 9200:vpc-example-n2mczfaqfo25w65nd4afx23yim.eu-central-1.es.amazonaws.com:443
```

## Monitoring

Included is a CloudWatch dashboard with some minimal stats displayed. You'll find it on your AWS account under `CloudWatch -> Dashboards`.
![A nice picture of the dashboard](./dashboard.png)

By default the AWS ES domains publish metrics to CloudWatch. These can then be used elsewhere too.
https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-managedomains.html#es-managedomains-cloudwatchmetrics

## Further Improvements

These are some improvements I would make before considering this module production ready. In the interest of time
I won't delve too much into them, but I want to note them down to show my awareness of the problems that exist.

### Longer term storage

What happens when the cluster runs out of space? This could eventually happen, it will definitely happen
if you log e.g. requests.

Ideally you would not have to keep that data. In which case you could just rotate out old data.

Otherwise you might want to also ship the raw logs somewhere, e.g. S3. Not sure how this would work.

### Version Upgrades

Not sure how upgrades would work, but there should be a strategy and it should be tested. i.e. How do you upgrade to a newer
version of ES without losing data?

### Request Signing

By default AWS ElasticSearch requires any requests to it to be signed by an IAM credential that has the correct authorization.
I still need to figure out how would this actually work in practice with Logstash/Beats.

### Better dashboard/alarms based on ES Domain Knowledge

I don't have much experience using ES long term, and most of my experience has been as a developer. I don't know
which metrics are important to keep track of. Therefore I would have liked to invest more time into reading up on
this, or asking someone more knowledgeable on hosting ES clusters as to what is important to keep track of.

## TODO

My own little todolist before I sign off on this task:

1. Fix Alerting
2. Modularize it. Either one big module or separate for cluster, dashboard and alerts.
3. Versioning (just git flow)
4. Documentation / Writing down what I would do further work on.

## Sources / References

VPC ES setup
https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-vpc.html#es-prerequisites-vpc-endpoints

ES CloudWatch
https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-managedomains.html#es-managedomains-cloudwatchmetrics

Alerting + Monitoring example, especially helpful for the email part.
https://stephenmann.io/post/setting-up-monitoring-and-alerting-on-amazon-aws-with-terraform/
