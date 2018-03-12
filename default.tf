provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "brad811-terraform-state"
    key    = "stripe-mock.tfstate"
    region = "us-east-1"
  }
}

resource "aws_key_pair" "stripe-mock" {
  key_name   = "stripe-mock"
  public_key = "${file("${path.module}/ec2.pub")}"
}

resource "aws_instance" "stripe-mock" {
    count = 1

    instance_type = "t2.micro"
    ami = "ami-66506c1c"
    associate_public_ip_address = true
    key_name = "stripe-mock"

    connection {
        user = "ec2-user"
        private_key = "${file("${path.module}/ec2.key")}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get install -y docker",
            "sudo service docker start",
            "sudo docker pull brad811/stripe-mock:master",
            "sudo docker run -d stripe-mock"
        ]
    }

    tags {
        Name = "Terraform stripe-mock ${count.index}"
    }
}
