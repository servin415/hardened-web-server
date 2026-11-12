# Hardened Linux Web Server

A two-VM VirtualBox lab: a hardened Ubuntu
24.04 web server ('web') and a client
('client') used to test it. One script,
'provision.sh', builds the server.

## Architecture

client (192.168.xx.x) --SSH/HTTP--> web
(nginx, ufw, key-only SSH)
Both VMs use NAT adapter for updates and
a host-only adapter to talk to each other.

## What it does

- Installs nginx and ufw
- Disables SSH password login and root
login
- Allows only SSH and HTTP through the
firewall
- Is safe to run more than once

## Setup

1. Create the VMs as described above and
create your SSH key to 'web' with ssh-copy-
id.
2. Cope the script over: scp provision.sh
devops@<web-ip>:~
3. Run it: ssh -t devops@<web-ip> 'sudo
bash provision.sh'

## Verify it worked

- Web server: curl http://<web-ip> shows
the nginx welcome page
- Password login off: ssh -o
PubkeyAuthentication=no devops@<web-ip>
fails with "Permission denied (publickey)"
- Settings: sudo sshd -T | grep -E
'passwordauthentication|permitrootlogin'
shows "no" for both
- Firewall: sudo ufw status verbose shows
only OpenSSH and Nginx HTTP allowed

## Why these choices

- Key-only SSH: stolen or guessed
passwords can't be used to log in.
- No root login: attackers must compromise
a normal user first, and actions are
traceable to that user.
- Deny-by-default firewall: only the ports
ther server needs are reachable.
- Idempotent script: running it twice
leaves the same result, so it is safe to
re-run.
