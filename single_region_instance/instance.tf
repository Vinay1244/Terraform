provider "aws"{
     region = "ap-southeast-1"
}

resource "aws_instance" "tf-server" {
ami = "ami-0c1907b6d738188e5"
instance_type = "t2.micro"
subnet_id = "subnet-0f95624d3ff01aa62"
key_name = "vinay-tf"
}
