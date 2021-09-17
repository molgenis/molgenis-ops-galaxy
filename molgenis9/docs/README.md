# How to run your own Molgenis instance

It is possible to run your Molgenis in docker containers to test if the software fits your needs [our docker image](https://github.com/molgenis/docker), but we recommend to run serious work in an VM based Molgenis instance. As the Molgenis support team we host 100+ of these instances for research projects in our own OpenStack VMs. But some research projects needs to keep their data at their own site. For these request we did not have an easy solution. We use ansibe playbooks to setup, maintain and secure our VMs, but these playbooks contain lots of RUG/UMCG specific infrastructure taks and therefor we put them in a private GitHub repo.

This Ansible Galaxy collection is a subset of the roles used in our private repo, and allows easy setup of your own basic molgenis instance on your own infrastrcuture.
 

### Software components that are part of the Molgenis instance:
- Java
- Tomcat
- Apache HTTPD/NGinX
- Minio
- Postgresql
- ElasticSearch

## Requirements
- OS: RedHat 8 or Centos 8 minimal install
- Hardware specs:  
  - 4-8 Gb memory
  - 2-4 cores
  - 25 Gb diskspace
- ssh access to server/VM with ssh keys (root or unprivileged user)
- Ansibe or AnsibleTower/Ansible AWX

## Ansible
We chose Ansible for our orchestration bacause it is lightwight and only needs python and ssh.

We use Ansible AWX (the free Ansible Tower) to install, patch, upgrade our 100+ VMs with Molgenis. But for smaller setups, plain ansible from a laptop will also do nicely.

## Ansible Basic playbook
- sets up basic Molgenis on http.
- Modular setup with Roles
- easily extendable with pre an post roles to setup customer/cloud specifics
  - SSL certs
  - firewall make sure you open 80/443
  - backup
  - monitoring/logging

Needed extras to fit custom install:
- SSL tcp/443


## Ansible Galaxy collection
The ansible playbook and roles for a minimum install of Molgenis can be found in `http://galaxy.ansible.com/molgenis/molgenis8`

The ansible scripts used to install Molgenis in the RUG OpenStack are in a private GitHub repo, but will be adapted in the future to also use the basic roles provided in the Ansible Galaxy collection.

