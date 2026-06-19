Ansible playbooks for provisioning servers used by the capstoneproject

This folder contains a small, safe, idempotent Ansible playbook to prepare Ubuntu servers
for running the project (installs Docker, the Docker Compose CLI plugin, Git, and creates
the docker user group). It also contains an optional step to clone the repository and
start the Compose stack on the target host.

Usage (example)

1. Install Ansible on your control machine (macOS/Linux/WSL):

   pip install ansible

2. Edit `ansible/inventory.ini` and add your target hosts.

3. Run the playbook (dry-run first if you like):

   # check only
   ansible-playbook -i ansible/inventory.ini ansible/site.yml --check

   # apply changes
   ansible-playbook -i ansible/inventory.ini ansible/site.yml

4. To enable automatic docker-compose deployment on the target host, open
   `ansible/site.yml` and set `deploy_compose: true`.

Notes
- The playbook assumes Ubuntu/Debian target hosts and uses the official Docker repo.
- The playbook is intentionally conservative and idempotent. Review it before running
  against production hosts.
