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
  
  user_data = templatefile("${path.module}/vpn-machine-setup.tpl", {
    SSH_PUBLIC_KEY        = var.SSH_PUBLIC_KEY,
    SSH_PRIVATE_KEY       = var.SSH_PRIVATE_KEY,
    rocket_chat_ip        = aws_instance.mdp-rocket-chat.private_ip,
    vault_ip              = aws_instance.mdp-vault.private_ip,
    gitlab_instance_url   = var.gitlab_instance_url,
    registration_token    = var.registration_token,
    gitlab_runner_description = var.gitlab_runner_description
  })
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
