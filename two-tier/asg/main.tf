resource "aws_key_pair" "auth" {
  key_name   = "key-${var.role}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_launch_configuration" "web" {
  instance_type    = "${var.instance_type}"
  image_id         = "${lookup(var.aws_amis, var.aws_region)}"
  name             = "web"
  security_groups  = ["${var.sg_id}"]
  key_name         = "${aws_key_pair.auth.id}"
  user_data        = "${data.template_file.provision.rendered}"
}

data "template_file" "provision" {
  template = "${file("provision.tpl")}"
}

resource "aws_autoscaling_group" "web" {
  vpc_zone_identifier  = ["${var.subnet_id}"]
  name                 = "web-asg"
  min_size             = "1"
  max_size             = "3"
  launch_configuration = "${aws_launch_configuration.web.name}"
  load_balancers       = ["${var.elb_name}"]
  tags = [
    {
      key                 = "role"
      value               = "${var.role}"
      propagate_at_launch = true
    }
  ]
}
