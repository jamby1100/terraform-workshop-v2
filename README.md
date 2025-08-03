## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.18.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.18.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.3 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_network"></a> [aws\_network](#module\_aws\_network) | ./modules/vpc | n/a |
| <a name="module_ec2_instance_profile"></a> [ec2\_instance\_profile](#module\_ec2\_instance\_profile) | ./modules/ec2_instance_profile | n/a |
| <a name="module_ec2_web_instance"></a> [ec2\_web\_instance](#module\_ec2\_web\_instance) | ./modules/ec2 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.products_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_key_pair.deployer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [local_file.private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.public_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [tls_private_key.ssh_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ubuntu_instance_public_ip"></a> [ubuntu\_instance\_public\_ip](#output\_ubuntu\_instance\_public\_ip) | n/a |
