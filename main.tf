resource "aws_launch_template" "web_server_as" {
    name = "myproject"
    image_id           = "ami-079c0d2990b4033f4"
    instance_type = "t2.micro"
    key_name = "new kp"   
}
  resource "aws_elb" "web_server_lb"{
     name = "web-server-lb"
     security_groups = [aws_security_group.web_server.id]
     subnets = ["subnet-072783de2af7f1236", "subnet-0beb4d458a202fdbf"]
     listener {
      instance_port     = 8000
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }
    tags = {
      Name = "terraform-elb"
    }
  }
resource "aws_autoscaling_group" "web_server_asg" {
    name                 = "web-server-asg"
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    health_check_type    = "EC2"
    load_balancers       = [aws_elb.web_server_lb.name]
    availability_zones    = ["us-west-2c", "us-west-2d"] 
    launch_template {
        id      = aws_launch_template.web_server_as.id
        version = "$Latest"
      }
  }

