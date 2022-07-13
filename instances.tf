#Get Linux AMi ID using SSM parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi-useast1" {
  provider = aws.region-master
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "master-key" {
  provider   = aws.region-master
  key_name   = "aws_sandbox"
  public_key = file("../tf_sshkey/id_rsa.pub")
}


#Create and bootstrap EC2 in us-east-1
resource "aws_instance" "aws_sandbox" {
  provider                    = aws.region-master
  count                       = var.workers-count
  ami                         = data.aws_ssm_parameter.linuxAmi-useast1.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.aws_sandbox_sg.id]
  subnet_id                   = aws_subnet.subnet_1.id
  root_block_device {
    volume_size = 50
  }
  tags = {
    Name = join("_", ["aws_sandbox_tf", count.index + 1])
  }
  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]
  provisioner "local-exec" {
    command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-master} --instance-ids ${self.id}
ansible-playbook ansible_templates/jenkins-master-sample.yml
EOF
  }
}

#ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/jenkins-master-sample.yml


#Create SG for allowing TCP/8080 from * and TCP/22 from your IP in use-east-1
resource "aws_security_group" "aws_sandbox_sg" {
  provider    = aws.region-master
  name        = "aws_sandbox_sg"
  description = "Allow TCP/22"
  vpc_id      = aws_vpc.vpc_master.id
  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
