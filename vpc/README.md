VPC:-
-------------
1.Create a VPC with a CIDR block of 10.0.0.0/16.
2.Create a public subnet within the VPC using the CIDR block 10.0.0.0/24.
3.Create a private subnet within the same VPC using the CIDR block 10.0.1.0/24.
4.Create an Internet Gateway (IGW) and attach it to the VPC.
5.Create a route table (rt-pub) for public access and add a route to forward all outbound traffic (0.0.0.0/0) to the Internet Gateway.
6.Associate the (rt-pub) route table with the public subnet to enable internet connectivity.
7.Launch an EC2 instance in the public subnet with a public IP assigned. Ensure it's launched within the created VPC.
8.Connect to the EC2 instance via SSH using its public IP and verify internet connectivity by pinging an external IP (e.g., ping 8.8.8.8).
9.Create a NAT Gateway in the public subnet, assigning it an Elastic IP address.
10.Create a new route table (rt-pvt) for private subnet traffic, and add a route to forward all outbound traffic (0.0.0.0/0) to the NAT Gateway.
11.Associate the (rt-pvt) route table with the private subnet to allow instances in the private subnet to access the internet via the NAT Gateway.
12.Launch a second EC2 instance in the private subnet without a public IP. Ensure it's using the same VPC and private subnet.
13.SSH into the private EC2 instance from the bastion host (the public EC2 instance) using its private IP address, and verify internet access by pinging an external IP (e.g., ping 8.8.8.8)


To create a key from local:- ssh-keygen -t rsa -b 4096 -f vinay-vpc.pem
