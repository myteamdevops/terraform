resource "aws_elb" "web" {
  name = "elb-${var.name}"

  subnets         = ["${var.subnet_id}"]
  security_groups = ["${var.elb_sg_id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

output "elb_name" {
  value = "${aws_elb.web.name}"
}

output "address" {
  value = "${aws_elb.web.dns_name}"
}
