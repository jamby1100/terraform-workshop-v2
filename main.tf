
/**
 * # Flask Product App
 * 
 * This is the main template for the flask product app
 * We have much documentation coming soon
 */

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "./.ssh/terraform_rsa"
}

resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "./.ssh/terraform_rsa.pub"
}

resource "aws_key_pair" "deployer" {
  key_name   = "{{team-name}}-ubuntu-ssh-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_dynamodb_table" "products_table" {
  name           = "${local.team_name}-products-table"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key       = "product_id"

  attribute {
    name = "product_id"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  tags = {
    Name        = "${local.team_name}-products-table"
    Environment = "production"
  }
}

module "ec2_instance_profile" {
  source = "./modules/ec2_instance_profile"
  profile_name = "jamby-terra"
  iam_policies = [
    {
      effect = "Allow",
      actions = [
        "dynamodb:PutItem",
        "dynamodb:Scan"
      ]
      resources = [
        aws_dynamodb_table.products_table.arn
      ]
    }
  ]
}

module "aws_network" {
  source = "./modules/vpc"
}

module "ec2_web_instance" {
  source = "./modules/ec2"
  iam_instance_profile = module.ec2_instance_profile.profile_name
  keypair_name = aws_key_pair.deployer.key_name
  ec2_instance_name = "jamby-webserver"
  aws_subnet_id = module.aws_network.public_subnet_one
  aws_vpc_id = module.aws_network.aws_vpc_id
  
  user_data = <<-EOF
                #!/bin/bash
                apt update -y
                apt install -y python3 python3-pip git nginx
  
                # Clone your repo
                git clone ${local.flask_github_repo} /home/ubuntu/app
                cd /home/ubuntu/app
                
                export AWS_REGION=${local.assigned_aws_region}
                export DYNAMODB_TABLE_NAME=${aws_dynamodb_table.products_table.name}
  
                # Install Python dependencies
                pip3 install --upgrade pip
                pip3 install -r requirements.txt
  
                # Start the Flask app using nohup (assumes app.py runs on 0.0.0.0:5000)
                nohup python3 app.py > app.log 2>&1 &
  
                # Configure NGINX to proxy traffic to the Flask app
                tee /etc/nginx/sites-available/default > /dev/null << EOL
                server {
                    listen 80 default_server;
                    listen [::]:80 default_server;
  
                    location / {
                        proxy_pass http://127.0.0.1:5000;
                        proxy_set_header Host \$host;
                        proxy_set_header X-Real-IP \$remote_addr;
                        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                        proxy_set_header X-Forwarded-Proto \$scheme;
                    }
                }
                EOL
  
                # Restart NGINX
                systemctl restart nginx
    EOF
}