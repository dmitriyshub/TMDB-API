# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_security_group.id]
  subnets            = [aws_subnet.vpc_subnet1_public.id, aws_subnet.vpc_subnet2_public.id]


  enable_deletion_protection = true

#  access_logs {
#    bucket  = aws_s3_bucket.lb_logs.bucket
#    prefix  = "test-lb"
#    enabled = true
#  }

  tags = {
    Name = "elb"
    Env = var.Env_tag
  }
}
#################################################################
# ALB Listener
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
#################################################################
# ALB Target Group
resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  target_type = "alb"
  port        = 8080
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc.id

    health_check {
    protocol = "HTTP"
    path = "/api/1/resolve/default?path=/"
    port = 8080
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    interval = 10
    matcher = "200"  # has to be HTTP 200 or fails
  }
}
#################################################################
# AutoScaling Launch Configuration Template
resource "aws_launch_configuration" "launch_template" {
  name          = "launch configuration"
  image_id      = var.ami_id.id
  instance_type = "t2.micro"
  enable_monitoring = true
  security_groups = [aws_security_group.public_security_group]
  key_name = var.key_pair
#  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
}
#################################################################
# AutoScaling Group
resource "aws_autoscaling_group" "auto_scaling_group" {
  name = "auto-scaling-group"
  #availability_zones = [var.az_a, var.az_b]
  vpc_zone_identifier = [aws_subnet.vpc_subnet1_private.id, aws_subnet.vpc_subnet2_private.id]
  launch_configuration = "${aws_launch_configuration.launch_template.name}"
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1
  health_check_grace_period = 300
  health_check_type = "ELB"
  force_delete = true
  #enabled_metrics = [GroupDesiredCapacity, GroupInServiceCapacity, GroupPendingCapacity, GroupMinSize, GroupMaxSize, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupStandbyCapacity, GroupTerminatingCapacity, GroupTerminatingInstances, GroupTotalCapacity, GroupTotalInstances]


  load_balancers = [aws_lb.alb.id]
  target_group_arns = [aws_lb_target_group.target_group.arn]


#  launch_template {
#    id      = aws_launch_configuration.launch_template.id
#    version = "$Latest"
#  }
#    tag = {
#      key = "Name"
#      value = var.Env_tag
#      propagate_at_launch = true
#  }

}
#################################################################
# AutoScaling Policy SCALE OUT
resource "aws_autoscaling_policy" "auto_scaling_policy" {
  name                   = "auto-scaling-policy"
  scaling_adjustment     = "1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "300"
  autoscaling_group_name = aws_autoscaling_group.auto_scaling_group.name
  policy_type = "SimpleScaling"
#  target_tracking_configuration {
#    target_value = 60
#  }
  estimated_instance_warmup = 300
}
#################################################################
# Cloud Watch Alarm SCALE OUT
resource "aws_cloudwatch_metric_alarm" "cpu-alarm" {
alarm_name = "cpu-alarm"
alarm_description = "cpu-alarm"
comparison_operator = "GreaterThanOrEqualToThreshold"
evaluation_periods = "2"
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
period = "120"
statistic = "Average"
threshold = "60"
dimensions = {
"AutoScalingGroupName" = "${aws_autoscaling_group.auto_scaling_group.name}"
}

actions_enabled = true
alarm_actions = ["${aws_autoscaling_policy.auto_scaling_policy.arn}"]
}

#################################################################
# Autoscaling Policy SCALE IN
resource "aws_autoscaling_policy" "cpu-policy-scaledown" {
name = "cpu-policy-scaledown"
autoscaling_group_name = "${aws_autoscaling_group.auto_scaling_group.name}"
adjustment_type = "ChangeInCapacity"
scaling_adjustment = "-1"
cooldown = "300"
policy_type = "SimpleScaling"
}
#################################################################
# Cloud Watch Alarm SCALE IN
resource "aws_cloudwatch_metric_alarm" "cpu-alarm-scaledown" {
alarm_name = "cpu-alarm-scaledown"
alarm_description = "cpu-alarm-scaledown"
comparison_operator = "LessThanOrEqualToThreshold"
evaluation_periods = "2"
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
period = "120"
statistic = "Average"
threshold = "5"
dimensions = {
"AutoScalingGroupName" = "${aws_autoscaling_group.auto_scaling_group.name}"
}
actions_enabled = true
alarm_actions = ["${aws_autoscaling_policy.cpu-policy-scaledown.arn}"]
}
#################################################################
