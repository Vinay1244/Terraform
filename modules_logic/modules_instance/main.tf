provider "aws" {
region = var.region_value
}

resource "aws_instance" "instance_Singapore" {
ami = var.ami_value
instance_type = var.instance_value
subnet_id = var.subnet_value
key_name = var.key_value
tags = {
Name = "instance_Singapore"
}
}
