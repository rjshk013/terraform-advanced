resource "aws_instance" "terraform_wapp" {
    ami = "${var.instance_ami}"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids =  [ "${aws_security_group.terraform_private_sg.id}" ]
    subnet_id     = "${element(aws_subnet.public_subnet.*.id,count.index)}"
    key_name               = "${var.key_name}"
    count         = 3
    associate_public_ip_address = true
    tags = {
      Name              = "terraform-Server-${count.index}"
      "Environment" = var.environment_tag

    }
}

