
resource "aws_instance" "terraform_wapp" {
    ami = "${var.instance_ami}"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids =  [ "${aws_security_group.terraform_private_sg.id}" ]
    subnet_id     = "${element(aws_subnet.public.*.id, 1)}"
    key_name               = "${var.key_name}"
    count         = 1
    associate_public_ip_address = true
    tags = {
      Name              = "terraform_ec2_wapp_awsdev"
      "Environment" = var.environment_tag

    }
}
resource "aws_instance" "terraform_web" {
    ami = "${var.instance_ami}"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids =  [ "${aws_security_group.terraform_web_sg.id}" ]
    subnet_id     = "${element(aws_subnet.private.*.id, 1)}"
    key_name               = "${var.key_name}"
    count         = 1
    associate_public_ip_address = false
    tags = {
      Name              = "web1"
      "Environment" = var.environment_tag
    }
}
