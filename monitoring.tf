data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.domain}-es-dashboard"

  dashboard_body = <<EOF
 {
   "widgets": [
       {
          "title": "Free Storage Space",
          "type":"metric",
          "x":0,
          "y":0,
          "width":6,
          "height":6,
          "properties":{
                "metrics": [
                    [ "AWS/ES", "FreeStorageSpace", "DomainName", "${var.domain}", "ClientId", "${data.aws_caller_identity.current.account_id}", { "period": 900 } ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "eu-central-1"
            }
       },
        {
            "title": "CPU Utilization",
            "type":"metric",
            "x":6,
            "y":0,
            "width":6,
            "height":6,
            "properties": {
                "metrics": [
                    [ "AWS/ES", "CPUUtilization", "DomainName", "${var.domain}", "ClientId", "${data.aws_caller_identity.current.account_id}", { "period": 900 } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "eu-central-1",
                
                "yAxis": {
                    "left": {
                        "min": 0,
                        "max": 100
                    }
                }
            }
        },
    {
          "type":"metric",
          "x":0,
          "y":7,
          "width":12,
          "height":3,
          "properties": {
            "metrics": [
                [ "AWS/ES", "ClusterStatus.green", "DomainName", "${var.domain}", "ClientId", "${data.aws_caller_identity.current.account_id}", { "color": "#2ca02c" } ],
                [ ".", "ClusterStatus.red", ".", ".", ".", ".", { "color": "#d62728" } ],
                [ ".", "ClusterStatus.yellow", ".", ".", ".", ".", { "color": "#bcbd22" } ]
            ],
            "view": "singleValue",
            "region": "eu-central-1",
            "period": 300
        }
    },
       {
          "type":"text",
          "x":0,
          "y":10,
          "width":12,
          "height":3,
          "properties":{
             "markdown":"This dashboard displays some basic stats from the elastic search cluster. Ideally it would give enough info at a glance to be able to determine what to do in case of an alarm or outage."
          }
       }
   ]
 }
 EOF
}
