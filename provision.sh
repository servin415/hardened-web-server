#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
	echo 'Run with sudo'
	exit 1
fi

apt-get update -y
apt-get install -y nginx ufw

cat > /etc/ssh/sshd_config.d/00-hardening.conf <<'EOF'
PasswordAuthentication no
PermitRootLogin no
EOF
sshd -t
systemctl restart ssh

ufw default deny incoming
ufw default allow outgoing
ufw allow OpenSSH
ufw allow 'Nginx HTTP'
ufw --force enable

systemctl enable --now nginx
echo 'Provisioning complete.'
