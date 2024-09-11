resource "aws_instance" "test-server" {
  ami = "ami-0a07ff89aacad043e"
  instance_type = "t2.micro"
  key_name = "keypair2"
  vpc_security_group_ids = ["sg-00b18ea2514f1f5c8"]
  connection {
     type = "ssh"
     user = "ubuntu"
     private_key = file("./keypair2.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/Care-Health/terraform-files/ansibleplaybook.yml"
     }
  }
