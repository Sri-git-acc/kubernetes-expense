resource "aws_instance" "instance" {
    ami           = "ami-09c813fb71547fc4f"
    instance_type = "t2.micro"
    security_groups = ["all_traffic"]

    root_block_device {
    volume_size = 50  # Set root volume size to 50GB
    volume_type = "gp3"  # Use gp3 for better performance (optional)
    }

    # user_data = file("instructions.sh")
    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = self.public_ip
    }

    provisioner "local-exec" {
        command = "echo ${self.public_ip} > inventory.ini"
    }

    provisioner "file" {
        source      = "instructions.sh"
        destination = "/tmp/instructions.sh"
    }

    provisioner "remote-exec" {
        # Bootstrap script called with private_ip of each node
        inline = [
            "chmod +x /tmp/instructions.sh",
            "sudo sh /tmp/instructions.sh"
        ]
    }

    tags = {
        Name = "Insta"
    }

} 