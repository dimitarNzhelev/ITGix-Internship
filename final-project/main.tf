resource "aws_instance" "mdp-openvpn" {
  ami           = "ami-0a3041ff14fb6e2be"
  tags = {
    Name = "mdp-openvpn"
  }
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.mdp-subnet.id
  key_name      = "itgix"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.mdp_openvpn_sg.id] 
  
  user_data = <<EOF
		#!/bin/bash
    ${file("${path.module}/openvpn-setup.sh")}
    yum update -y
    sudo usermod -aG wheel ec2-user
    echo -e "${var.SSH_PUBLIC_KEY}" >> /root/.ssh/id_rsa.pub
    echo -e "${var.SSH_PRIVATE_KEY}" >> /root/.ssh/id_rsa
    chmod 600 /root/.ssh/id_rsa
    chmod 644 /root/.ssh/id_rsa.pub
    sudo amazon-linux-extras install ansible2 -y
    sudo yum install git -y

    echo "[ec2s]
    RocketChat ansible_host=${aws_instance.mdp-rocket-chat.private_ip}
    Vault ansible_host=${aws_instance.mdp-vault.private_ip}" > inventory

    sudo curl -L --output /usr/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
    sudo chmod +x /usr/bin/gitlab-runner
    sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
    sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
    sudo gitlab-runner register --non-interactive --executor shell --url ${var.gitlab_instance_url} --registration-token ${var.registration_token} --description ${var.gitlab_runner_description}
    echo 'gitlab-runner ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/gitlab-runner
    sudo gitlab-runner start
  EOF
}

resource "aws_instance" "mdp-rocket-chat" {
  ami           = "ami-0a3041ff14fb6e2be"
  tags = {
    Name = "mdp-rocket-chat"
  }
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.mdp-subnet.id
  key_name      = "mdp-instances"
  vpc_security_group_ids = [aws_security_group.mdp-access-openvpn-sg.id]
  associate_public_ip_address = true 

}

resource "aws_instance" "mdp-vault" {
  ami           = "ami-0a3041ff14fb6e2be"
  tags = {
    Name = "mdp-vault"
  }
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.mdp-subnet.id
  key_name      = "mdp-instances"
  vpc_security_group_ids = [aws_security_group.mdp-access-openvpn-sg.id]
  associate_public_ip_address = true
}
