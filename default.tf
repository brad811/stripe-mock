provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "stripe-mock" {
    count = 1

    instance_type = "t2.micro"
    ami = "ami-66506c1c"
    associate_public_ip_address = true

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
