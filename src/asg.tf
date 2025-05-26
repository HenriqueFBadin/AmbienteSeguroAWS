resource "aws_autoscaling_group" "frontend" {
  name                      = "asg-frontend-terraform"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = module.vpc.public_subnets
  target_group_arns         = [aws_lb_target_group.frontend_tg_asg.arn]
  health_check_type         = "EC2"
  health_check_grace_period = 60
  force_delete              = true

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ASG-Terraform-Frontend"
    propagate_at_launch = true
  }

  tag {
    key                 = "project"
    value               = "terraform-final-techack"
    propagate_at_launch = true
  }

  tag {
    key                 = "enviroment"
    value               = "study"
    propagate_at_launch = true
  }
}
