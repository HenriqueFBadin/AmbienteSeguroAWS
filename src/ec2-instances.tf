# EC2 Instâncias com volumes EBS, IP público, e user_data

resource "aws_instance" "frontend" {
  ami                         = "ami-0e58b56aa4d64231b"
  instance_type               = "t2.small"
  subnet_id                   = module.vpc.public_subnets[0]
  key_name                    = "ChavesDatabase"
  vpc_security_group_ids      = [module.sg-frontend.security_group_id]
  associate_public_ip_address = true

  user_data_base64 = "IyEvYmluL2Jhc2gKc3VkbyBzdQp5dW0gdXBkYXRlIC15CmFtYXpvbi1saW51eC1leHRyYXMgaW5zdGFsbCBkb2NrZXIgLXkKc3VkbyBzZXJ2aWNlIGRvY2tlciBzdGFydApzdWRvIHVzZXJtb2QgLWFHIGRvY2tlciBlYzItdXNlcgpkb2NrZXIgcHVsbCBoZW5yaXF1ZWZiL3NpdGUtY29kZS1hd3M6dGVycmFmb3JtCmlmIFsgIiQoZG9ja2VyIHBzIC1hcSAtZiBuYW1lPXNpdGUpIiBdOyB0aGVuCiAgICBkb2NrZXIgc3RvcCBzaXRlIHx8IHRydWUKICAgIGRvY2tlciBybSBzaXRlIHx8IHRydWUKZmkKZG9ja2VyIHJ1biAtZCAtLW5hbWUgc2l0ZSAtcCA4MDozMDAwIC1wIDQ0MzozMDAwIGhlbnJpcXVlZmIvc2l0ZS1jb2RlLWF3czp0ZXJyYWZvcm0KZWNobyAiQ29udGFpbmVyIGluaWNpYWRvIGVtICQoZGF0ZSkiID4+IC92YXIvbG9nL3VzZXItZGF0YS1ydW4ubG9nCmRvY2tlciBwcyA+PiAvdmFyL2xvZy91c2VyLWRhdGEtcnVuLmxvZwpzdWRvIHJwbSAtLWltcG9ydCBodHRwczovL3BhY2thZ2VzLndhenVoLmNvbS9rZXkvR1BHLUtFWS1XQVpVSApzdWRvIHRlZSBjYXQgPiAvZXRjL3l1bS5yZXBvcy5kL3dhenVoLnJlcG8gPDwgRU9GClt3YXp1aF0KZ3BnY2hlY2s9MQpncGdrZXk9aHR0cHM6Ly9wYWNrYWdlcy53YXp1aC5jb20va2V5L0dQRy1LRVktV0FaVUgKZW5hYmxlZD0xCm5hbWU9RUwtXCRyZWxlYXNldmVyIC0gV2F6dWgKYmFzZXVybD1odHRwczovL3BhY2thZ2VzLndhenVoLmNvbS80LngveXVtLwpwcm90ZWN0PTEKRU9GCnN1ZG8gV0FaVUhfTUFOQUdFUj0iMTAuMC4wLjgxIiB5dW0gaW5zdGFsbCB3YXp1aC1hZ2VudCAteQpzdWRvIHNlZCAtaSAnLzxjbGllbnQ+LywvPFwvY2xpZW50Pi9jXDxjbGllbnQ+XG4gIDxzZXJ2ZXI+XG4gICAgPGFkZHJlc3M+MTAuMC4wLjgxPC9hZGRyZXNzPlxuICAgIDxwb3J0PjE1MTQ8L3BvcnQ+XG4gICAgPHByb3RvY29sPnRjcDwvcHJvdG9jb2w+XG4gIDwvc2VydmVyPlxuPC9jbGllbnQ+JyAvdmFyL29zc2VjL2V0Yy9vc3NlYy5jb25mCnN1ZG8gc3lzdGVtY3RsIGRhZW1vbi1yZWxvYWQKc3VkbyBzeXN0ZW1jdGwgZW5hYmxlIHdhenVoLWFnZW50CnN1ZG8gc3lzdGVtY3RsIHN0YXJ0IHdhenVoLWFnZW50CnN1ZG8gc2VkIC1pICJzL15lbmFibGVkPTEvZW5hYmxlZD0wLyIgL2V0Yy95dW0ucmVwb3MuZC93YXp1aC5yZXBv"

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name       = "Frontend-Terraform"
    project    = "terraform-final-techack"
    enviroment = "study"
  }
}

resource "aws_instance" "zabbix" {
  ami                         = "ami-0a7d80731ae1b2435"
  instance_type               = "t2.large"
  subnet_id                   = module.vpc.public_subnets[1]
  private_ip                  = "10.0.0.121"
  key_name                    = "ChavesDatabase"
  vpc_security_group_ids      = [module.sg-zabbix.security_group_id]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name       = "Zabbix-Terraform"
    project    = "terraform-final-techack"
    enviroment = "study"
  }
}

resource "aws_instance" "backend" {
  ami                         = "ami-0e58b56aa4d64231b"
  instance_type               = "t2.small"
  subnet_id                   = module.vpc.private_subnets[0]
  private_ip                  = "10.0.2.20"
  key_name                    = "ChavesDatabase"
  vpc_security_group_ids      = [module.sg-backend.security_group_id]
  associate_public_ip_address = true

  user_data_base64 = "IyEvYmluL2Jhc2gKc3VkbyBzdQp5dW0gdXBkYXRlIC15CmFtYXpvbi1saW51eC1leHRyYXMgaW5zdGFsbCBkb2NrZXIgLXkKc3VkbyBzZXJ2aWNlIGRvY2tlciBzdGFydApzdWRvIHVzZXJtb2QgLWFHIGRvY2tlciBlYzItdXNlcgpzdGFydF90aW1lPSQoZGF0ZSArJXMpCnRpbWVvdXQ9NjAwCndoaWxlIHRydWU7IGRvCiAgICBlY2hvICJUZW50YW5kbyBwdXhhciBpbWFnZW0gRG9ja2VyIGRvY2tlciBwdWxsIGhlbnJpcXVlZmIvYmFja2VuZC1jb2RlLWF3czpsYXRlc3QuLi4iCiAgICBkb2NrZXIgcHVsbCBoZW5yaXF1ZWZiL2JhY2tlbmQtY29kZS1hd3M6bGF0ZXN0ICYmIGJyZWFrCiAgICBjdXJyZW50X3RpbWU9JChkYXRlICslcykKICAgIGVsYXBzZWQ9JCgoY3VycmVudF90aW1lIC0gc3RhcnRfdGltZSkpCiAgICBpZiBbICIkZWxhcHNlZCIgLWdlICIkdGltZW91dCIgXTsgdGhlbgogICAgICAgIGVjaG8gIkVSUk86IFRpbWVvdXQgYW8gdGVudGFyIHB1eGFyIGltYWdlbSBwb3N0Z3JlczoxNSIKICAgICAgICBleGl0IDEKICAgIGZpCiAgICBlY2hvICJGYWxoYSwgdGVudGFuZG8gbm92YW1lbnRlIGVtIDEwcy4uLiIKICAgIHNsZWVwIDEwCmRvbmUKaWYgWyAiJChkb2NrZXIgcHMgLWFxIC1mIG5hbWU9YmFja2VuZCkiIF07IHRoZW4KICAgIGRvY2tlciBzdG9wIGJhY2tlbmQgfHwgdHJ1ZQogICAgZG9ja2VyIHJtIGJhY2tlbmQgfHwgdHJ1ZQpmaQpkb2NrZXIgcnVuIC1kICAgLS1uYW1lIGJhY2tlbmQgICAtcCA1MDAwOjUwMDAgICAtZSBEQl9IT1NUPTEwLjAuMi45MCAgIC1lIERCX1BPUlQ9NTQzMiAgIC1lIERCX1VTRVI9cHJvamV0byAgIC1lIERCX1BBU1NXT1JEPXByb2pldG8gICAtZSBEQl9OQU1FPXByb2pldG8gICBoZW5yaXF1ZWZiL2JhY2tlbmQtY29kZS1hd3M6bGF0ZXN0CmVjaG8gIkNvbnRhaW5lciBpbmljaWFkbyBlbSAkKGRhdGUpIiA+PiAvdmFyL2xvZy91c2VyLWRhdGEtcnVuLmxvZwpkb2NrZXIgcHMgPj4gL3Zhci9sb2cvdXNlci1kYXRhLXJ1bi5sb2cKc3VkbyBycG0gLS1pbXBvcnQgaHR0cHM6Ly9wYWNrYWdlcy53YXp1aC5jb20va2V5L0dQRy1LRVktV0FaVUgKc3VkbyB0ZWUgY2F0ID4gL2V0Yy95dW0ucmVwb3MuZC93YXp1aC5yZXBvIDw8IEVPRgpbd2F6dWhdCmdwZ2NoZWNrPTEKZ3Bna2V5PWh0dHBzOi8vcGFja2FnZXMud2F6dWguY29tL2tleS9HUEctS0VZLVdBWlVICmVuYWJsZWQ9MQpuYW1lPUVMLVwkcmVsZWFzZXZlciAtIFdhenVoCmJhc2V1cmw9aHR0cHM6Ly9wYWNrYWdlcy53YXp1aC5jb20vNC54L3l1bS8KcHJvdGVjdD0xCkVPRgpzdWRvIFdBWlVIX01BTkFHRVI9IjEwLjAuMC44MSIgeXVtIGluc3RhbGwgd2F6dWgtYWdlbnQgLXkKc3VkbyBzZWQgLWkgJy88Y2xpZW50Pi8sLzxcL2NsaWVudD4vY1w8Y2xpZW50PlxuICA8c2VydmVyPlxuICAgIDxhZGRyZXNzPjEwLjAuMC44MTwvYWRkcmVzcz5cbiAgICA8cG9ydD4xNTE0PC9wb3J0PlxuICAgIDxwcm90b2NvbD50Y3A8L3Byb3RvY29sPlxuICA8L3NlcnZlcj5cbjwvY2xpZW50PicgL3Zhci9vc3NlYy9ldGMvb3NzZWMuY29uZgpzdWRvIHN5c3RlbWN0bCBkYWVtb24tcmVsb2FkCnN1ZG8gc3lzdGVtY3RsIGVuYWJsZSB3YXp1aC1hZ2VudApzdWRvIHN5c3RlbWN0bCBzdGFydCB3YXp1aC1hZ2VudApzdWRvIHNlZCAtaSAicy9eZW5hYmxlZD0xL2VuYWJsZWQ9MC8iIC9ldGMveXVtLnJlcG9zLmQvd2F6dWgucmVwbwpzdGFydF90aW1lPSQoZGF0ZSArJXMpCnRpbWVvdXQ9NjAwCndoaWxlIHRydWU7IGRvCiAgICBlY2hvICJFc3BlcmFuZG8gbyBiYWNrZW5kIHJlc3BvbmRlciBuYSBwb3J0YSA1MDAwLi4uIgogICAgaWYgY3VybCAtcyBodHRwOi8vMTAuMC4yLjIwOjUwMDAvID4gL2Rldi9udWxsOyB0aGVuCiAgICAgICAgZWNobyAiQmFja2VuZCBlc3TDoSByZXNwb25kZW5kbyEiCiAgICAgICAgYnJlYWsKICAgIGZpCiAgICBjdXJyZW50X3RpbWU9JChkYXRlICslcykKICAgIGVsYXBzZWQ9JCgoY3VycmVudF90aW1lIC0gc3RhcnRfdGltZSkpCiAgICBpZiBbICIkZWxhcHNlZCIgLWdlICIkdGltZW91dCIgXTsgdGhlbgogICAgICAgIGVjaG8gIkVSUk86IFRpbWVvdXQgYW8gZXNwZXJhciBvIGJhY2tlbmQgc3ViaXIiCiAgICAgICAgZXhpdCAxCiAgICBmaQogICAgc2xlZXAgNQpkb25lCmN1cmwgLVggUE9TVCBodHRwOi8vMTAuMC4yLjIwOjUwMDAvZW1wbG95ZWVzIC1IICJDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL2pzb24iIC1kICd7Im5hbWUiOiJIZW5yaXF1ZSIsICJsYXN0bmFtZSI6Ik1heW9yIiwgInBvc2l0aW9uIjoiRGlyZXRvciBUZWNoIiwgImxpbmtlZGluIjoiaHR0cHM6Ly93d3cubGlua2VkaW4uY29tL2luL2hlbnJpcXVlLW1heW9yLTUyMWExYjI4OC8ifScgJiYgXApjdXJsIC1YIFBPU1QgaHR0cDovLzEwLjAuMi4yMDo1MDAwL2VtcGxveWVlcyAtSCAiQ29udGVudC1UeXBlOiBhcHBsaWNhdGlvbi9qc29uIiAtZCAneyJuYW1lIjoiSGVucmlxdWUiLCAibGFzdG5hbWUiOiJUdXJjbyIsICJwb3NpdGlvbiI6IkRpcmV0b3IgZGUgUkgiLCAibGlua2VkaW4iOiJodHRwczovL3d3dy5saW5rZWRpbi5jb20vaW4vaGVucmlxdWUtdHVyY28tZ2VyYS8ifScgJiYgXApjdXJsIC1YIFBPU1QgaHR0cDovLzEwLjAuMi4yMDo1MDAwL2VtcGxveWVlcyAtSCAiQ29udGVudC1UeXBlOiBhcHBsaWNhdGlvbi9qc29uIiAtZCAneyJuYW1lIjoiRW1pbHkiLCAibGFzdG5hbWUiOiJCcml0dG8iLCAicG9zaXRpb24iOiJDb29yZGVuYWRvciIsICJsaW5rZWRpbiI6Imh0dHBzOi8vd3d3LmxpbmtlZGluLmNvbS9pbi9lbWlseWJydHQvIn0nICYmIFwKY3VybCAtWCBQT1NUIGh0dHA6Ly8xMC4wLjIuMjA6NTAwMC9lbXBsb3llZXMgLUggIkNvbnRlbnQtVHlwZTogYXBwbGljYXRpb24vanNvbiIgLWQgJ3sibmFtZSI6IkVkdWFyZG8iLCAibGFzdG5hbWUiOiJZYWdpbnVtYSIsICJwb3NpdGlvbiI6IkNvb3JkZW5hZG9yIiwgImxpbmtlZGluIjoiaHR0cHM6Ly93d3cubGlua2VkaW4uY29tL2luL2VkdWFyZG8tdGFrZWkteWFnaW51bWEtMjY1MTg1MjcxLyJ9JyAmJiBcCmN1cmwgLVggUE9TVCBodHRwOi8vMTAuMC4yLjIwOjUwMDAvZW1wbG95ZWVzIC1IICJDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL2pzb24iIC1kICd7Im5hbWUiOiJHYWJyaWVsYSIsICJsYXN0bmFtZSI6IkFiaWIiLCAicG9zaXRpb24iOiJDb29yZGVuYWRvciIsICJsaW5rZWRpbiI6Imh0dHBzOi8vd3d3LmxpbmtlZGluLmNvbS9pbi9nYWJyaWVsYS1hLTUxYjY5NTM1MC8ifScgJiYgXApjdXJsIC1YIFBPU1QgaHR0cDovLzEwLjAuMi4yMDo1MDAwL2VtcGxveWVlcyAtSCAiQ29udGVudC1UeXBlOiBhcHBsaWNhdGlvbi9qc29uIiAtZCAneyJuYW1lIjoiV2VzbGV5IiwgImxhc3RuYW1lIjoiQ2F2YWxjYW50ZSIsICJwb3NpdGlvbiI6IkNvb3JkZW5hZG9yIiwgImxpbmtlZGluIjoiaHR0cHM6Ly93d3cubGlua2VkaW4uY29tL2luL3dlc2xleS1hbHZlcy1jYXZhbGNhbnRlLTAzNDYyNzMwNS8ifSc="

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name       = "Backend-Terraform"
    project    = "terraform-final-techack"
    enviroment = "study"
  }
}

resource "aws_instance" "mediador" {
  ami                         = "ami-0e58b56aa4d64231b"
  instance_type               = "t2.small"
  subnet_id                   = module.vpc.public_subnets[1]
  key_name                    = "ChavesDatabase"
  vpc_security_group_ids      = [module.sg-mediador.security_group_id]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name       = "Mediador-Terraform"
    project    = "terraform-final-techack"
    enviroment = "study"
  }
}

resource "aws_instance" "db" {
  ami                    = "ami-0e58b56aa4d64231b"
  instance_type          = "t2.small"
  subnet_id              = module.vpc.private_subnets[1]
  private_ip             = "10.0.2.90"
  key_name               = "ChavesDatabase"
  vpc_security_group_ids = [module.sg-db.security_group_id]

  user_data_base64 = "IyEvYmluL2Jhc2gKc3VkbyBzdQp5dW0gdXBkYXRlIC15CmFtYXpvbi1saW51eC1leHRyYXMgaW5zdGFsbCBkb2NrZXIgLXkKc3VkbyBzZXJ2aWNlIGRvY2tlciBzdGFydApzdWRvIHVzZXJtb2QgLWFHIGRvY2tlciBlYzItdXNlcgpzdGFydF90aW1lPSQoZGF0ZSArJXMpCnRpbWVvdXQ9NjAwCndoaWxlIHRydWU7IGRvCiAgICBlY2hvICJUZW50YW5kbyBwdXhhciBpbWFnZW0gRG9ja2VyIHBvc3RncmVzOjE1Li4uIgogICAgZG9ja2VyIHB1bGwgcG9zdGdyZXM6MTUgJiYgYnJlYWsKICAgIGN1cnJlbnRfdGltZT0kKGRhdGUgKyVzKQogICAgZWxhcHNlZD0kKChjdXJyZW50X3RpbWUgLSBzdGFydF90aW1lKSkKICAgIGlmIFsgIiRlbGFwc2VkIiAtZ2UgIiR0aW1lb3V0IiBdOyB0aGVuCiAgICAgICAgZWNobyAiRVJSTzogVGltZW91dCBhbyB0ZW50YXIgcHV4YXIgaW1hZ2VtIHBvc3RncmVzOjE1IgogICAgICAgIGV4aXQgMQogICAgZmkKICAgIGVjaG8gIkZhbGhhLCB0ZW50YW5kbyBub3ZhbWVudGUgZW0gMTBzLi4uIgogICAgc2xlZXAgMTAKZG9uZQpkb2NrZXIgcnVuIC1kICAgLS1uYW1lIHBvc3RncmVzICAgLWUgUE9TVEdSRVNfVVNFUj1wcm9qZXRvICAgLWUgUE9TVEdSRVNfUEFTU1dPUkQ9cHJvamV0byAgIC1lIFBPU1RHUkVTX0RCPXByb2pldG8gICAtcCA1NDMyOjU0MzIgICAtLXJlc3RhcnQ9YWx3YXlzICAgcG9zdGdyZXM6MTUKc3VkbyBycG0gLS1pbXBvcnQgaHR0cHM6Ly9wYWNrYWdlcy53YXp1aC5jb20va2V5L0dQRy1LRVktV0FaVUgKc3VkbyB0ZWUgY2F0ID4gL2V0Yy95dW0ucmVwb3MuZC93YXp1aC5yZXBvIDw8IEVPRjIKW3dhenVoXQpncGdjaGVjaz0xCmdwZ2tleT1odHRwczovL3BhY2thZ2VzLndhenVoLmNvbS9rZXkvR1BHLUtFWS1XQVpVSAplbmFibGVkPTEKbmFtZT1FTC1cJHJlbGVhc2V2ZXIgLSBXYXp1aApiYXNldXJsPWh0dHBzOi8vcGFja2FnZXMud2F6dWguY29tLzQueC95dW0vCnByb3RlY3Q9MQpFT0YyCnN1ZG8gV0FaVUhfTUFOQUdFUj0iMTAuMC4wLjgxIiB5dW0gaW5zdGFsbCB3YXp1aC1hZ2VudCAteQpzdWRvIHNlZCAtaSAnLzxjbGllbnQ+LywvPFwvY2xpZW50Pi9jXDxjbGllbnQ+XG4gIDxzZXJ2ZXI+XG4gICAgPGFkZHJlc3M+MTAuMC4wLjgxPC9hZGRyZXNzPlxuICAgIDxwb3J0PjE1MTQ8L3BvcnQ+XG4gICAgPHByb3RvY29sPnRjcDwvcHJvdG9jb2w+XG4gIDwvc2VydmVyPlxuPC9jbGllbnQ+JyAvdmFyL29zc2VjL2V0Yy9vc3NlYy5jb25mCnN1ZG8gc3lzdGVtY3RsIGRhZW1vbi1yZWxvYWQKc3VkbyBzeXN0ZW1jdGwgZW5hYmxlIHdhenVoLWFnZW50CnN1ZG8gc3lzdGVtY3RsIHN0YXJ0IHdhenVoLWFnZW50CnN1ZG8gc2VkIC1pICJzL15lbmFibGVkPTEvZW5hYmxlZD0wLyIgL2V0Yy95dW0ucmVwb3MuZC93YXp1aC5yZXBvCg=="

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    iops                  = 3000
    delete_on_termination = true
  }

  tags = {
    Name       = "Database-Terraform"
    project    = "terraform-final-techack"
    enviroment = "study"
  }
}

resource "aws_instance" "Wazuh" {
  ami                         = "ami-0e58b56aa4d64231b"
  instance_type               = "t2.large"
  subnet_id                   = module.vpc.public_subnets[1]
  private_ip                  = "10.0.0.81"
  key_name                    = "ChavesDatabase"
  vpc_security_group_ids      = [module.sg-security.security_group_id]
  associate_public_ip_address = true

  user_data_base64 = "IyEvYmluL2Jhc2gKc3VkbyBhcHQgdXBkYXRlICYmIHN1ZG8gYXB0IHVwZ3JhZGUgLXkKY3VybCAtc08gaHR0cHM6Ly9wYWNrYWdlcy53YXp1aC5jb20vNC4xMi93YXp1aC1pbnN0YWxsLnNoCmNobW9kICt4IHdhenVoLWluc3RhbGwuc2gKc3VkbyBiYXNoIC4vd2F6dWgtaW5zdGFsbC5zaCAtYSAtbyB8IHRlZSAvdmFyL2xvZy93YXp1aF9pbnN0YWxsX2Z1bGwubG9nIHwgZ3JlcCAnVXNlcjonID4gL3Zhci9sb2cvd2F6dWhfY3JlZGVudGlhbHMudHh0"

  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name       = "Wazuh-Terraform"
    project    = "terraform-final-techack"
    enviroment = "study"
  }
}
