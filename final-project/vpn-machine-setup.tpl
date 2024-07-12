#!/bin/bash
sudo usermod -aG wheel ec2-user
sudo yum update -y

# Install OpenVPN
curl -fsS https://as-repository.openvpn.net/as/install.sh -o openvpn-install.sh
chmod +x openvpn-install.sh
echo y | sudo ./openvpn-install.sh &> openvpn-installation.log
rm openvpn-install.sh

PUBLIC_IP=$(curl -s ifconfig.me)

sudo /usr/local/openvpn_as/scripts/sacli --key "host.name" --value "$PUBLIC_IP" ConfigPut

sudo systemctl restart openvpnas

# SSH Key setup
echo -e "${SSH_PUBLIC_KEY}" >> /root/.ssh/id_rsa.pub
echo -e "${SSH_PRIVATE_KEY}" >> /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
chmod 644 /root/.ssh/id_rsa.pub

# Install Ansible & git
sudo amazon-linux-extras install ansible2 -y
sudo yum install git -y

echo "[ec2s]
RocketChat ansible_host=${rocket_chat_ip}
Vault ansible_host=${vault_ip}" > inventory

# Install GitLab Runner
sudo curl -L --output /usr/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
sudo chmod +x /usr/bin/gitlab-runner
sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
sudo gitlab-runner register --non-interactive --executor shell --url ${gitlab_instance_url} --registration-token ${registration_token} --description ${gitlab_runner_description}

echo 'gitlab-runner ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/gitlab-runner

sudo gitlab-runner start