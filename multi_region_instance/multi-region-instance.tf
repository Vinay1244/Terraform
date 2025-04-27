provider "aws" {
alias = "ser1"
region = "ap-southeast-1"
}

provider "aws"{
alias = "ser2"
region = "ap-southeast-2"
}

resource "aws_key_pair" "vinay-tf"{
provider = "aws.ser2"
key_name = "vinay-tf"
public_key = file("/home/ubuntu/vinay/vinay-tf.pub")
}

resource "aws_instance" "instance_Singapore" {
provider = "aws.ser1"
ami = "ami-0c1907b6d738188e5"
instance_type = "t2.micro"
subnet_id = "subnet-0f95624d3ff01aa62"
key_name="vinay-tf"
tags = {
Name = "instance_Singapore"
}
}

resource "aws_instance" "instance_Sydney" {
provider = "aws.ser2"
ami = "ami-0a2e29e3b4fc39212"
instance_type = "t2.micro"
subnet_id = "subnet-0345da7bbd6673259"
key_name = "vinay-tf"
depends_on = [
    aws_key_pair.vinay-tf
  ]
tags = {
Name = "instance_Sydney"
}
}
