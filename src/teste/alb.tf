resource "aws_lb" "frontend_alb" {
  name               = "alb-terraform"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.sg-alb-frontend.security_group_id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  tags = {
    Name       = "alb-terraform"
    project    = "terraform-final-techack"
    enviroment = "study"
  }
}

resource "aws_lb_target_group" "frontend_tg_fixa" {
  name        = "tg-frontend-fixa"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"

  tags = {
    Name       = "tg-frontend-fixa"
    project    = "terraform-final-techack"
    enviroment = "study"
  }
}

resource "aws_lb_target_group" "frontend_tg_asg" {
  name        = "tg-frontend-asg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"

  tags = {
    Name       = "tg-frontend-asg"
    project    = "terraform-final-techack"
    enviroment = "study"
  }
}

resource "aws_lb_listener" "frontend_http" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.frontend_tg_fixa.arn
        weight = 1
      }
      target_group {
        arn    = aws_lb_target_group.frontend_tg_asg.arn
        weight = 1
      }
    }
  }
}


resource "aws_lb_target_group_attachment" "frontend_fixa" {
  target_group_arn = aws_lb_target_group.frontend_tg_fixa.arn
  target_id        = aws_instance.frontend.id
  port             = 80
}
