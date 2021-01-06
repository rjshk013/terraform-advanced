variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "subnets_cidr" {
	type = "list"
	default = ["10.20.1.0/24", "10.20.2.0/24","10.20.3.0/24" ]
}

variable "azs" {
	type = "list"
	default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "main_vpc_cidr" {
    description = "CIDR of the VPC"
    default = "10.20.0.0/16"
}

variable "privatesubnets_cidr" {
        type = "list"
        default = ["10.20.4.0/24", "10.20.5.0/24","10.20.6.0/24" ]
}
variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default = "ami-0817d428a6fb68645"
}
variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "t2.micro"
}
variable "key_name" {
  description = "Public key path"
  default     = "testebs"
}
variable "environment_tag" {
  description = "Environment tag"
  default     = "Production"
}
