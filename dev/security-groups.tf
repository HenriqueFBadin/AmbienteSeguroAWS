# Módulo Terraform para todos os Security Groups do projeto

########################################
# GRUPO: WEB (Frontend, ALB)
########################################

module "sg-frontend" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "terraform-sg-frontend"
  description = "Permite acesso as portas 80, 443 e SSH para o frontend"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = "0.0.0.0/0" },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = "0.0.0.0/0" },
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = "0.0.0.0/0" }
  ]

  ingress_with_source_security_group_id = [
    { from_port = 10050, to_port = 10050, protocol = "tcp", source_security_group_id = module.sg-zabbix.security_group_id }
  ]

  egress_with_cidr_blocks = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = "0.0.0.0/0" }
  ]

  egress_with_source_security_group_id = [
    { from_port = 1514, to_port = 1514, protocol = "tcp", source_security_group_id = module.sg-security.security_group_id }
  ]

  tags = {
    Name = "terraform-sg-frontend", project = "terraform-final-techack", enviroment = "study"
  }
}

module "sg-alb-frontend" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "terraform-sg-alb-frontend"
  description = "Acesso publico HTTP para ALB do Frontend"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = "0.0.0.0/0" }
  ]

  egress_with_cidr_blocks = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = "0.0.0.0/0" }
  ]

  tags = {
    Name = "terraform-sg-alb-frontend", project = "terraform-final-techack", enviroment = "study"
  }
}

########################################
# GRUPO: ACESSO E MEDIAÇÃO (Mediador)
########################################

module "sg-mediador" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "terraform-sg-mediador"
  description = "Acesso SSH para mediacao das instancias privadas"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = "0.0.0.0/0" }
  ]

  egress_with_cidr_blocks = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = "0.0.0.0/0" }
  ]

  tags = {
    Name = "terraform-sg-mediador", project = "terraform-final-techack", enviroment = "study"
  }
}

########################################
# GRUPO: BANCO DE DADOS (DB)
########################################

module "sg-db" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "terraform-sg-db"
  description = "Permissoes de acesso ao banco de dados"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    { from_port = 5432, to_port = 5432, protocol = "tcp", source_security_group_id = module.sg-backend.security_group_id },
    { from_port = 5432, to_port = 5432, protocol = "tcp", source_security_group_id = module.sg-mediador.security_group_id },
    { from_port = 22, to_port = 22, protocol = "tcp", source_security_group_id = module.sg-mediador.security_group_id },
    { from_port = 10050, to_port = 10050, protocol = "tcp", source_security_group_id = module.sg-zabbix.security_group_id }
  ]

  egress_with_cidr_blocks = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = "0.0.0.0/0" }
  ]

  egress_with_source_security_group_id = [
    { from_port = 1514, to_port = 1514, protocol = "tcp", source_security_group_id = module.sg-security.security_group_id }
  ]

  tags = {
    Name = "terraform-sg-db", project = "terraform-final-techack", enviroment = "study"
  }
}

########################################
# GRUPO: MONITORAMENTO (Zabbix)
########################################

module "sg-zabbix" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "terraform-sg-zabbix"
  description = "Acesso ao servidor Zabbix"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = "0.0.0.0/0" },
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = "0.0.0.0/0" },
    { from_port = 10050, to_port = 10050, protocol = "tcp", cidr_blocks = "0.0.0.0/0" },
    { from_port = 10051, to_port = 10051, protocol = "tcp", cidr_blocks = "0.0.0.0/0" }
  ]

  egress_with_cidr_blocks = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = "0.0.0.0/0" }
  ]

  tags = {
    Name = "terraform-sg-zabbix", project = "terraform-final-techack", enviroment = "study"
  }
}

########################################
# GRUPO: BACKEND (API, processamento)
########################################

module "sg-backend" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "terraform-sg-backend"
  description = "Acesso ao backend"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    { from_port = 22, to_port = 22, protocol = "tcp", source_security_group_id = module.sg-mediador.security_group_id },
    { from_port = 5000, to_port = 5000, protocol = "tcp", source_security_group_id = module.sg-frontend.security_group_id },
    { from_port = 10050, to_port = 10050, protocol = "tcp", source_security_group_id = module.sg-zabbix.security_group_id }
  ]

  ingress_with_cidr_blocks = [
    { from_port = -1, to_port = -1, protocol = "-1", cidr_blocks = "0.0.0.0/0" }
  ]

  egress_with_source_security_group_id = [
    { from_port = 1514, to_port = 1514, protocol = "tcp", source_security_group_id = module.sg-security.security_group_id },
    { from_port = 1515, to_port = 1515, protocol = "tcp", source_security_group_id = module.sg-security.security_group_id }
  ]

  egress_with_cidr_blocks = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = "0.0.0.0/0" }
  ]

  tags = {
    Name = "terraform-sg-backend", project = "terraform-final-techack", enviroment = "study"
  }
}

########################################
# GRUPO: SEGURANÇA (Wazuh, painel)
########################################

module "sg-security" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "terraform-sg-security"
  description = "Grupo para o dashboard de seguranca - Wazuh"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = "0.0.0.0/0" },
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = "0.0.0.0/0" },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = "0.0.0.0/0" }
  ]

  ingress_with_source_security_group_id = [
    { from_port = 1515, to_port = 1515, protocol = "tcp", source_security_group_id = module.sg-frontend.security_group_id },
    { from_port = 1515, to_port = 1515, protocol = "tcp", source_security_group_id = module.sg-backend.security_group_id },
    { from_port = 1515, to_port = 1515, protocol = "tcp", source_security_group_id = module.sg-db.security_group_id },
    { from_port = 1514, to_port = 1514, protocol = "tcp", source_security_group_id = module.sg-frontend.security_group_id },
    { from_port = 1514, to_port = 1514, protocol = "tcp", source_security_group_id = module.sg-backend.security_group_id },
    { from_port = 1514, to_port = 1514, protocol = "tcp", source_security_group_id = module.sg-db.security_group_id }
  ]

  egress_with_cidr_blocks = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = "0.0.0.0/0" }
  ]

  tags = {
    Name = "terraform-sg-security", project = "terraform-final-techack", enviroment = "study"
  }
}
