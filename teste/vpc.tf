# modulo VPC (https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
# Módulo VPC com subnets públicas, privadas, IGW, NAT, Route tables e endpoints

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "projeto_terraform-vpc"
  cidr = "10.0.0.0/22"

  azs = ["us-east-1a", "us-east-1b"]

  public_subnets  = ["10.0.0.0/26", "10.0.0.64/26"]
  private_subnets = ["10.0.2.0/26", "10.0.2.64/26"]

  enable_nat_gateway = true
  single_nat_gateway = true
  reuse_nat_ips      = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    project    = "terraform-final-techack"
    enviroment = "study"
  }

  public_subnet_tags = {
    project    = "terraform-final-techack"
    enviroment = "study"
  }

  private_subnet_tags = {
    project    = "terraform-final-techack"
    enviroment = "study"
  }

  igw_tags = {
    Name       = "projeto_terraform-igw"
    project    = "terraform-final-techack"
    enviroment = "study"
  }

  nat_gateway_tags = {
    Name = "NAT-gateway-vpc-terraform"
  }

}

resource "aws_default_security_group" "default" {
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol    = "-1"
    self        = true
    from_port   = 0
    to_port     = 0
    description = "Permitir todo o trafego interno"
  }

  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    description = "Permitir todo o trafego de saida"
  }

  tags = {
    Name       = "terraform-sg-default"
    project    = "terraform-final-techack"
    enviroment = "study"
  }
}


resource "aws_ec2_instance_connect_endpoint" "endpoint_terraform_db" {
  subnet_id          = module.vpc.private_subnets[1] # us-east-1b
  security_group_ids = [aws_default_security_group.default.id]

  tags = {
    Name = "endpoint-db"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = module.vpc.private_route_table_ids

  tags = {
    Name       = "projeto_terraform-vpce-s3"
    project    = "terraform-final-techack"
    enviroment = "study"
  }
}
