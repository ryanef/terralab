

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "terralab" {
  subnet_id = var.public_subnets[count.index]
  ami           = data.aws_ami.ubuntu.id
  key_name= aws_key_pair.tl_key.id
  security_groups = [aws_security_group.ssh.id]
  instance_type = "t3.micro"
  count = 3

  provisioner "local-exec" {
    command = "printf '\n${self.public_ip}' >> aws_web_servers && aws ec2 wait instance-status-ok --instance-ids ${self.id} --region ${var.AWS_REGION}"
    environment = {}
  }

  provisioner "local-exec" {
    when = destroy
    command = "sed -i '/^[0-9]/d' aws_web_servers"
  }

  tags = {
    Name = "tl"
  }
}

# # resource "null_resource" "grafana_install" {
# #   depends_on = [aws_instance.terralab]
# #   provisioner "local-exec" {
# #     command = "ansible-playbook -i aws_web_servers --key-file /home/r/.ssh/terralab playbooks/main-playbook.yml"
# #   }
# # }


resource "aws_lb_target_group_attachment" "tl-tg-attachment" {
  target_group_arn = var.target_group_arn
  count = length(aws_instance.terralab)
  target_id        = aws_instance.terralab[count.index].id
  port             = 80
}

resource "aws_security_group" "ssh" {
  name        = "allow_ssh_tl"
  description = "Allow ssh inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH "
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["172.72.200.66/32", "52.5.185.132/32"]

  }
  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  ingress {
    description      = "grafana"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

    egress {
    description      = "outbound 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

    egress {
    description      = "ssl"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_key_pair" "tl_key" {
  key_name   = "tl-ssh"
  # public_key = file("/var/lib/r/terralab.pub")
  public_key = file("/home/r/.ssh/terralab.pub")
}
