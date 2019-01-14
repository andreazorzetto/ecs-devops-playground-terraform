data "template_file" "user_data_user" {
  template = "${file("scripts/user_data_user.sh")}"

  vars {
    ssh_pass = "${var.ssh_password}"
  }
}

resource "aws_instance" "user_instances" {
  ami                       = "${var.ami_id}"
  count                     = "${var.instances_to_deploy}"
  subnet_id                 = "${var.vpc_subnet_id}"
  instance_type             = "${var.instance_type}"
  key_name                  = "${var.key_name}"
  vpc_security_group_ids    = ["${aws_security_group.user_instances.id}"]
  user_data                 = "${data.template_file.user_data_user.rendered}"

  tags {
      Name = "${var.inst_base_name}-${lower(element(var.animals,random_integer.animal_offset.result + count.index))}"
      Owner = "${lower(element(split("/",data.aws_caller_identity.current_user.arn),1))}"
  }
}

resource "aws_security_group" "user_instances" {
  name        = "user_instances_all"
  description = "Allow all traffic for ECS IP"
  vpc_id      = "${var.vpc_id}"


  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["185.183.107.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route53_record" "user_instance" {
  count = "${var.instances_to_deploy}"
  zone_id = "${var.r53_zone_id}"
  name    = "${lower(element(var.animals,random_integer.animal_offset.result + count.index))}"
  type    = "A"
  ttl     = "60"
  records = ["${element(aws_instance.user_instances.*.public_ip,count.index)}"]
}
