resource "aws_instance" "mdp-openvpn" {
  ami           = "ami-0a3041ff14fb6e2be"
  tags = {
    Name = "mdp-openvpn"
  }
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.mdp-subnet.id
  key_name      = "itgix"
  associate_public_ip_address = true
  security_groups = [aws_security_group.elsys_mrejari_openvpn_sg.id]
  
  user_data = file("${path.module}/openvpn-setup.sh")
}

resource "aws_instance" "mdp-rocket-chat" {
  ami           = "ami-0a3041ff14fb6e2be"
  tags = {
    Name = "mdp-rocket-chat"
  }
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.mdp-subnet.id
  key_name      = "itgix"
  security_groups = [aws_security_group.mdp-access-openvpn-sg.id]
  associate_public_ip_address = true 
}

resource "aws_instance" "mdp-vault" {
  ami           = "ami-0a3041ff14fb6e2be"
  tags = {
    Name = "mdp-vault"
  }
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.mdp-subnet.id
  key_name      = "itgix"
  security_groups = [aws_security_group.mdp-access-openvpn-sg.id]
  associate_public_ip_address = true
}