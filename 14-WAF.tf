resource "aws_wafv2_web_acl" "appl_waf_acl"{
 name          = "app1-web-acl"
 description   = "web acl for app1"
 scope         = "regional"
}
 default_action {
    type = "allow"
}

rule {
    name = "IPBlockRule"
    priority = 1

    action {
      block {}
    }
}
 statement {
    ip_set_refence_statement {
        data "aws_arn" "db_instance" {
        arn = aws_wafv2_ipset.ip_block_list.arn
        }
    }
visibility_config {
        cloudwatch_metrics_enabled = false
        metric_name                = "IPBlockRule"
        sampled_requests_enabled   = false
    }
}

rule {
    name     ="AWSManagedRulesKnownBadInputs"
    priority = 2
}
override_action {
    none {}
}

statement {
    mananged_rule_group_statement {
        name        = "AWSManangedRulesKnownBadInputsRuleSet"
        vendor_name = false
    }
}

visibility_config {
        cloudwatch_metrics_enabled = false
        metric_name                = "AWSManangedRulesKnownBadInputs"
        sampled_requests_enabled   = false
}


visibility_config {
    
    cloudwatch_metrics_enabled = false
    metric_name                = "app1WebACL"
    sampled_requests_enabled   = false
    }

tags = {
    Name    = "app1-web-acl"
    Service = "App1"
    Owner   = "BlkVadar"
    Project = "WAF"
}

resource "aws_wafv2_web_acl" "appl_waf_acl"{
 name               = "ip-block-list"
 description        = "List of Blocked ip Addresses"
 scope              = "regional"
 ip_address_version = "IPV4"
}

address = [
    "1.188.0.0/16",
    "1.80.0.0/16",
    "101.144.0.0/16",
    "101.16.0.0/16"
]


 tags = {
        Name    = "ip-block-list"
        Service = "App1"
        Owner   = "BlkVadar"
        Project = "WAF"
}



resource "aws_wafv2_web_acl_association" "appl_waf_alb_association"{
    resource_arn = aws_lb.app1_alb.arn
    web_acl_arn =  aws_wafv2_web_acl.appl_waf_acl.arn
}

#AWS-AWSManagedRulesKnownBadInputsRuleSet
#AWS-AWSManagedRulesAmazonIpRepitationList
#AWS-AWSManagedRulesAnonymousIpList
#AWS-AWSManagedRulesCommonRuleSet
#AWS-AWSManagedRulesLinuxSet
