# Launch an EC2 instance

In this guide you will be building EC2 instances, target groups Aplication Load Balancer (ALB) using terraform with the following requisites:

- Instance name: `httpserver1`
- Instance type: `t2.micro`
- Image: `ami-06d5e0de6baf595ca`
- Key pair: `pgpcc-key1`
- Security Group: `default` and `tio1-sig`
- Security Group Rules:
  - Allow HTTP(80) and SSH(22) ingress from any
  - Allow any traffic egress
- VPC: `default`
- HTTP Servers must be configured
- Configure a new service called `tio.service`

## AWS Cli

You will need to have an AWS account (free tier works) and install and configure AWS CLI to use this code. Please follow the [AWS Command Line Interface Guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html) if this is your first time using AWS CLI.

## Terraform

If this is your first time using Terraform, please follow [Get Started - AWS](https://developer.hashicorp.com/terraform/tutorials/aws-get-started) to get familirized. You will also find the [Install Terraform Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

## How to use this code

First clone this repository on your computer. (Not sure what clone this repo means? [Here](https://www.coursera.org/learn/introduction-git-github?specialization=google-it-automation&utm_medium=sem&utm_source=gg&utm_campaign=B2C_NAMER_google-it-automation_google_FTCOF_professional-certificates_country-CA&campaignid=19667787599&adgroupid=148957580787&device=c&keyword=&matchtype=&network=g&devicemodel=&adposition=&creativeid=647783020004&hide_mobile_promo&gad_source=1&gclid=CjwKCAjwkuqvBhAQEiwA65XxQBnia_JFxQnJ1l6fG52BEQuzp0nbDjO-Mr2hNskB2-cuMNF2SIKNrxoCCy8QAvD_BwE#modules) you go! This is free git and github course from Coursera.

Step 1: Make sure you have terraform and aws cli installed and configured.

#

Step 2: Clone the repo

```bash
git clone https://github.com/wbox/pgp-cc.git
```

#

Step 3: Change to `pgp-cc/terraform/ec2/tio1` directory

```bash
cd pgp-cc/terraform/ec2/tio1
```

#

Step 4: Create key pair using aws cli

Currently terraform doesn't not support creation of key pair so we will need to use aws cli for this task. Make sure you save the output from this command since it will be the key to use to connect to your new instance via ssh.

```bash
aws ec2 create-key-pair --key-name pgpcc-key1
```


#

Step 5: Initialize terraform

```bash
terraform init
```

#

Step 6: Execute a terraform plan to view the changes. Don't worry, nothing is going to be created in your AWS account. This is just a step for you to validate/view the changes.

```bash
terraform plan
```

<details>
   <summary>Results from terraform plan</summary>
You will see something like this

```text
data.aws_vpc.default: Reading...
data.aws_vpc.default: Read complete after 1s [id=vpc-0ad75bed265a85bc0]
data.aws_security_group.selected: Reading...
data.aws_security_group.selected: Read complete after 0s [id=sg-02f83bf146918fe6d]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.web_server will be created
  + resource "aws_instance" "web_server" {
      + ami                                  = "ami-06d5e0de6baf595ca"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "httpserver1"
        }
      + tags_all                             = {
          + "Name" = "httpserver1"
        }
      + tenancy                              = (known after apply)
      + user_data                            = "d85175867767fc039cb63f364dd639f1c4eefe85"
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)
    }

  # aws_security_group.tio1-sig will be created
  + resource "aws_security_group" "tio1-sig" {
      + arn                    = (known after apply)
      + description            = "Opens security groups for ssh and http"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = "tio1-sg"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "tio1-sig"
        }
      + tags_all               = {
          + "Name" = "tio1-sig"
        }
      + vpc_id                 = "vpc-0ad75bed265a85bc0"
    }

  # aws_vpc_security_group_egress_rule.allow_all_ipv4 will be created
  + resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
      + arn                    = (known after apply)
      + cidr_ipv4              = "0.0.0.0/0"
      + id                     = (known after apply)
      + ip_protocol            = "-1"
      + security_group_id      = (known after apply)
      + security_group_rule_id = (known after apply)
      + tags_all               = {}
    }

  # aws_vpc_security_group_ingress_rule.allow_http will be created
  + resource "aws_vpc_security_group_ingress_rule" "allow_http" {
      + arn                    = (known after apply)
      + cidr_ipv4              = "0.0.0.0/0"
      + from_port              = 80
      + id                     = (known after apply)
      + ip_protocol            = "tcp"
      + security_group_id      = (known after apply)
      + security_group_rule_id = (known after apply)
      + tags_all               = {}
      + to_port                = 80
    }

  # aws_vpc_security_group_ingress_rule.allow_ssh will be created
  + resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
      + arn                    = (known after apply)
      + cidr_ipv4              = "0.0.0.0/0"
      + from_port              = 22
      + id                     = (known after apply)
      + ip_protocol            = "tcp"
      + security_group_id      = (known after apply)
      + security_group_rule_id = (known after apply)
      + tags_all               = {}
      + to_port                = 22
    }

Plan: 5 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + aws_security_group_id  = "sg-02f83bf146918fe6d"
  + ec2_instance_id        = (known after apply)
  + ec2_instance_public_ip = (known after apply)
  + ec2_instance_sg_id     = (known after apply)

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you
run "terraform apply" now.
```

</details>

#

Step 7: Now is time to create your new instance.

```bash
terraform apply -auto-approve
```

<details>
  <summary>Results from terraform apply</summary>

```text
data.aws_vpc.default: Reading...
data.aws_vpc.default: Read complete after 1s [id=vpc-0ad75bed265a85bc0]
data.aws_security_group.selected: Reading...
data.aws_security_group.selected: Read complete after 0s [id=sg-02f83bf146918fe6d]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.web_server will be created
  + resource "aws_instance" "web_server" {
      + ami                                  = "ami-06d5e0de6baf595ca"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "httpserver1"
        }
      + tags_all                             = {
          + "Name" = "httpserver1"
        }
      + tenancy                              = (known after apply)
      + user_data                            = "d85175867767fc039cb63f364dd639f1c4eefe85"
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)
    }

  # aws_security_group.tio1-sig will be created
  + resource "aws_security_group" "tio1-sig" {
      + arn                    = (known after apply)
      + description            = "Opens security groups for ssh and http"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = "tio1-sg"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "tio1-sig"
        }
      + tags_all               = {
          + "Name" = "tio1-sig"
        }
      + vpc_id                 = "vpc-0ad75bed265a85bc0"
    }

  # aws_vpc_security_group_egress_rule.allow_all_ipv4 will be created
  + resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
      + arn                    = (known after apply)
      + cidr_ipv4              = "0.0.0.0/0"
      + id                     = (known after apply)
      + ip_protocol            = "-1"
      + security_group_id      = (known after apply)
      + security_group_rule_id = (known after apply)
      + tags_all               = {}
    }

  # aws_vpc_security_group_ingress_rule.allow_http will be created
  + resource "aws_vpc_security_group_ingress_rule" "allow_http" {
      + arn                    = (known after apply)
      + cidr_ipv4              = "0.0.0.0/0"
      + from_port              = 80
      + id                     = (known after apply)
      + ip_protocol            = "tcp"
      + security_group_id      = (known after apply)
      + security_group_rule_id = (known after apply)
      + tags_all               = {}
      + to_port                = 80
    }

  # aws_vpc_security_group_ingress_rule.allow_ssh will be created
  + resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
      + arn                    = (known after apply)
      + cidr_ipv4              = "0.0.0.0/0"
      + from_port              = 22
      + id                     = (known after apply)
      + ip_protocol            = "tcp"
      + security_group_id      = (known after apply)
      + security_group_rule_id = (known after apply)
      + tags_all               = {}
      + to_port                = 22
    }

Plan: 5 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + aws_security_group_id  = "sg-02f83bf146918fe6d"
  + ec2_instance_id        = (known after apply)
  + ec2_instance_public_ip = (known after apply)
  + ec2_instance_sg_id     = (known after apply)
aws_security_group.tio1-sig: Creating...
aws_security_group.tio1-sig: Creation complete after 2s [id=sg-0dc4cb92b59fc443d]
aws_vpc_security_group_egress_rule.allow_all_ipv4: Creating...
aws_vpc_security_group_ingress_rule.allow_http: Creating...
aws_vpc_security_group_ingress_rule.allow_ssh: Creating...
aws_instance.web_server: Creating...
aws_vpc_security_group_egress_rule.allow_all_ipv4: Creation complete after 0s [id=sgr-027faa53555dfd8e5]
aws_vpc_security_group_ingress_rule.allow_ssh: Creation complete after 0s [id=sgr-0f3c966a9adcd3dc5]
aws_vpc_security_group_ingress_rule.allow_http: Creation complete after 0s [id=sgr-0d26374e3aabbf871]
aws_instance.web_server: Still creating... [10s elapsed]
aws_instance.web_server: Still creating... [20s elapsed]
aws_instance.web_server: Still creating... [30s elapsed]
aws_instance.web_server: Creation complete after 32s [id=i-0e01d9fb8abd43bb7]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

aws_security_group_id = "sg-02f83bf146918fe6d"
ec2_instance_id = "i-0e01d9fb8abd43bb7"
ec2_instance_public_ip = "3.89.250.229"
ec2_instance_sg_id = toset([
  "default",
  "tio1-sg",
])
```

</details>

#

Check on your AWS Management Console and you will see a new instance. Compare with the values from outputs. To check if your instance is running as expected run the following command or open your browser using the ip address in the `ec2_instance_public_ip` above. In this example the IP address is 3.89.250.229. It will be different in your case.

```bash
curl http://3.89.250.229
```
#

Step 8: Now is time to destroy everything.

```bash
terraform destroy -auto-approve
```

You might see something like this

<details>
  <summary>Results from terraform destroy</summary>

```text
data.aws_vpc.default: Reading...
data.aws_vpc.default: Read complete after 0s [id=vpc-0ad75bed265a85bc0]
data.aws_security_group.selected: Reading...
aws_security_group.tio1-sig: Refreshing state... [id=sg-0dc4cb92b59fc443d]
aws_vpc_security_group_egress_rule.allow_all_ipv4: Refreshing state... [id=sgr-027faa53555dfd8e5]
aws_vpc_security_group_ingress_rule.allow_http: Refreshing state... [id=sgr-0d26374e3aabbf871]
aws_vpc_security_group_ingress_rule.allow_ssh: Refreshing state... [id=sgr-0f3c966a9adcd3dc5]
data.aws_security_group.selected: Read complete after 0s [id=sg-02f83bf146918fe6d]
aws_instance.web_server: Refreshing state... [id=i-0e01d9fb8abd43bb7]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  - destroy

Terraform will perform the following actions:

  # aws_instance.web_server will be destroyed
  - resource "aws_instance" "web_server" {
      - ami                                  = "ami-06d5e0de6baf595ca" -> null
      - arn                                  = "arn:aws:ec2:us-east-1:987447366745:instance/i-0e01d9fb8abd43bb7" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "us-east-1b" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 1 -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-0e01d9fb8abd43bb7" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t2.micro" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - monitoring                           = false -> null
      - placement_partition_number           = 0 -> null
      - primary_network_interface_id         = "eni-06215593d960546ba" -> null
      - private_dns                          = "ip-172-31-94-9.ec2.internal" -> null
      - private_ip                           = "172.31.94.9" -> null
      - public_dns                           = "ec2-3-89-250-229.compute-1.amazonaws.com" -> null
      - public_ip                            = "3.89.250.229" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [
          - "default",
          - "tio1-sg",
        ] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-069b9a43a6bf699c9" -> null
      - tags                                 = {
          - "Name" = "httpserver1"
        } -> null
      - tags_all                             = {
          - "Name" = "httpserver1"
        } -> null
      - tenancy                              = "default" -> null
      - user_data                            = "d85175867767fc039cb63f364dd639f1c4eefe85" -> null
      - user_data_replace_on_change          = false -> null
      - vpc_security_group_ids               = [
          - "sg-02f83bf146918fe6d",
          - "sg-0dc4cb92b59fc443d",
        ] -> null

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - cpu_options {
          - core_count       = 1 -> null
          - threads_per_core = 1 -> null
        }

      - credit_specification {
          - cpu_credits = "standard" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_protocol_ipv6          = "disabled" -> null
          - http_put_response_hop_limit = 1 -> null
          - http_tokens                 = "optional" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/xvda" -> null
          - encrypted             = false -> null
          - iops                  = 100 -> null
          - tags                  = {} -> null
          - tags_all              = {} -> null
          - throughput            = 0 -> null
          - volume_id             = "vol-0bb46289958f26c02" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp2" -> null
        }
    }

  # aws_security_group.tio1-sig will be destroyed
  - resource "aws_security_group" "tio1-sig" {
      - arn                    = "arn:aws:ec2:us-east-1:987447366745:security-group/sg-0dc4cb92b59fc443d" -> null
      - description            = "Opens security groups for ssh and http" -> null
      - egress                 = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = ""
              - from_port        = 0
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "-1"
              - security_groups  = []
              - self             = false
              - to_port          = 0
            },
        ] -> null
      - id                     = "sg-0dc4cb92b59fc443d" -> null
      - ingress                = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = ""
              - from_port        = 22
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 22
            },
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = ""
              - from_port        = 80
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 80
            },
        ] -> null
      - name                   = "tio1-sg" -> null
      - owner_id               = "987447366745" -> null
      - revoke_rules_on_delete = false -> null
      - tags                   = {
          - "Name" = "tio1-sig"
        } -> null
      - tags_all               = {
          - "Name" = "tio1-sig"
        } -> null
      - vpc_id                 = "vpc-0ad75bed265a85bc0" -> null
    }

  # aws_vpc_security_group_egress_rule.allow_all_ipv4 will be destroyed
  - resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
      - arn                    = "arn:aws:ec2:us-east-1:987447366745:security-group-rule/sgr-027faa53555dfd8e5" -> null
      - cidr_ipv4              = "0.0.0.0/0" -> null
      - id                     = "sgr-027faa53555dfd8e5" -> null
      - ip_protocol            = "-1" -> null
      - security_group_id      = "sg-0dc4cb92b59fc443d" -> null
      - security_group_rule_id = "sgr-027faa53555dfd8e5" -> null
      - tags_all               = {} -> null
    }

  # aws_vpc_security_group_ingress_rule.allow_http will be destroyed
  - resource "aws_vpc_security_group_ingress_rule" "allow_http" {
      - arn                    = "arn:aws:ec2:us-east-1:987447366745:security-group-rule/sgr-0d26374e3aabbf871" -> null
      - cidr_ipv4              = "0.0.0.0/0" -> null
      - from_port              = 80 -> null
      - id                     = "sgr-0d26374e3aabbf871" -> null
      - ip_protocol            = "tcp" -> null
      - security_group_id      = "sg-0dc4cb92b59fc443d" -> null
      - security_group_rule_id = "sgr-0d26374e3aabbf871" -> null
      - tags_all               = {} -> null
      - to_port                = 80 -> null
    }

  # aws_vpc_security_group_ingress_rule.allow_ssh will be destroyed
  - resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
      - arn                    = "arn:aws:ec2:us-east-1:987447366745:security-group-rule/sgr-0f3c966a9adcd3dc5" -> null
      - cidr_ipv4              = "0.0.0.0/0" -> null
      - from_port              = 22 -> null
      - id                     = "sgr-0f3c966a9adcd3dc5" -> null
      - ip_protocol            = "tcp" -> null
      - security_group_id      = "sg-0dc4cb92b59fc443d" -> null
      - security_group_rule_id = "sgr-0f3c966a9adcd3dc5" -> null
      - tags_all               = {} -> null
      - to_port                = 22 -> null
    }

Plan: 0 to add, 0 to change, 5 to destroy.

Changes to Outputs:
  - aws_security_group_id  = "sg-02f83bf146918fe6d" -> null
  - ec2_instance_id        = "i-0e01d9fb8abd43bb7" -> null
  - ec2_instance_public_ip = "3.89.250.229" -> null
  - ec2_instance_sg_id     = [
      - "default",
      - "tio1-sg",
    ] -> null
aws_vpc_security_group_ingress_rule.allow_ssh: Destroying... [id=sgr-0f3c966a9adcd3dc5]
aws_vpc_security_group_egress_rule.allow_all_ipv4: Destroying... [id=sgr-027faa53555dfd8e5]
aws_vpc_security_group_ingress_rule.allow_http: Destroying... [id=sgr-0d26374e3aabbf871]
aws_instance.web_server: Destroying... [id=i-0e01d9fb8abd43bb7]
aws_vpc_security_group_egress_rule.allow_all_ipv4: Destruction complete after 1s
aws_vpc_security_group_ingress_rule.allow_http: Destruction complete after 1s
aws_vpc_security_group_ingress_rule.allow_ssh: Destruction complete after 1s
aws_instance.web_server: Still destroying... [id=i-0e01d9fb8abd43bb7, 10s elapsed]
aws_instance.web_server: Still destroying... [id=i-0e01d9fb8abd43bb7, 20s elapsed]
aws_instance.web_server: Still destroying... [id=i-0e01d9fb8abd43bb7, 30s elapsed]
aws_instance.web_server: Still destroying... [id=i-0e01d9fb8abd43bb7, 40s elapsed]
aws_instance.web_server: Destruction complete after 41s
aws_security_group.tio1-sig: Destroying... [id=sg-0dc4cb92b59fc443d]
aws_security_group.tio1-sig: Destruction complete after 1s

Destroy complete! Resources: 5 destroyed.
```

</details>