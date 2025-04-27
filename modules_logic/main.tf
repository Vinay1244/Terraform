provider "aws" {
region = "var.region_value"
}

module "aws_instance" {
source = "./modules_instance"
#source = "git::https://github.com/Vinay1244/Terraform.git//modules_logic/modules_instance"
ami_value = "ami-0c1907b6d738188e5"
subnet_value="subnet-0f95624d3ff01aa62"
instance_value="t2.micro"
key_value="vinay-tf"
region_value="ap-southeast-1"
}

