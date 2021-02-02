# Armadillo service
We are using Vagrant and Ansible
## Usage 
To test the deployment we are Vagrant to deploy the ansible playbook locally oin your machine.
If you navigate to the `deployment/ansible` directory you can execute `vagrant up` and the VM will start with the necessary services.

The vagrant box will bind on port 80 to the host. If you add this block to the `etc/hosts` file the domains 
in Apache HTTPD will resolve.

```
# To allow vagrant httpd to bind to the internal domains
127.0.0.1 armadillo.local armadillo-storage.local armadillo-auth.local
# End section
``` 
## Ansible
To use the Ansible to deploy the stack you need to binaries on your system. You can install Ansible following this [user guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).
### Setup
When you installed ansible you need to create 3 files:

- `requirements.yml`
- `inventory.ini`
- `playbook.yml`

#### Creating requirements.yml
This file needs to contain the following content. 

> Be advised: the version may differ. Please check the latest version on the galaxy website.

```yaml
collections:
  - name: molgenis.molgenis8
    version: 1.1.0
  - name: molgenis.armadillo1
    version: 1.0.5
```
#### Creating inventory.ini
Your target host needs to be defined here.

```ini
# used for initial setup of new empty VMs
[armadillo]
x.x.x.x # ip address of the system
```
#### Creating playbook.yml
The playbook is the base of the rollout for the Armadillo. The contents of the playbook is shown below.

```yaml
---
- hosts: all
  become: true
  become_user: root
  gather_facts: true
  vars:
    ci: false
    minio:
      access_key: xxxxxxxx
      secret_key: xxxxxxxx
      port: 9000
      host: http://localhost
    oauth:
      issuer_uri: https://auth.molgenis.org
      discovery_path: /.well-known/openid-configuration
      client_id: xxxxxxx-xxxxxx-xxxxxxx

  roles:
    - role: molgenis.molgenis8.preinstall_centos8
    - role: molgenis.molgenis8.java_centos8
    - role: molgenis.molgenis8.minio_centos8
      vars:
        access_key: "{{ minio.access_key }}"
        secret_key: "{{ minio.secret_key }}"
    - role: molgenis.armadillo1.podman_centos8
    - role: molgenis.armadillo1.httpd_centos8
      vars:
        host: armadillo.local
        ports:
          armadillo: 8080
          storage: "{{ minio.port }}"
          auth: 4000
    - role: molgenis.armadillo1.rserver
      vars: 
        debug: true
    - role: molgenis.armadillo1.armadillo
      vars:
        version: 0.0.15
        storage:
          access_key: "{{ minio.access_key }}"
          secret_key: "{{ minio.secret_key }}"
          host: "{{ minio.host }}"
          port: "{{ minio.port }}"
    - role: molgenis.armadillo1.auth_centos8
      vars:
        image: 
          version: 0.2.0
        oauth:
          issuer_uri: "{{ oauth.issuer_uri }}"
          client_id: "{{ oauth.client_id }}"
          client_secret: xxxxx-xxxxx-xxxxx
          api_token: xxxx-xxxxx-xxxxx
      
```

There are a few prerequisites that we need. 

##### "become" needs to work
When you login to a VM you are hopefully yourself as in a useraccount that is recognisable as your account. After you logged in you need to be able to perform `sudo su` without entering a password. Get that in place and you will be able to run the playbook.

##### Authentication and authorisation
Before you deploy you need to register your application on the DataSHIELD authentication server. This allows you to delegate the authentication and usermanagement. The authorisation will still be under your control.

The general variables in the playbook.yml need to be amended to set the configuration right:

```yaml
...
 oauth:
      issuer_uri: https://auth.molgenis.org
      discovery_path: /.well-known/openid-configuration
      client_id: xxxxxxx-xxxxxx-xxxxxxx
...
```

#### Usage
When you created the correct files and filled in the right variables you need to perform a series of commands to bootstrap the server with the Armadillo.

First get your collections installed.

`ansible-galaxy install -r requirements.yml`

Then install the server with Ansible.

`ansible-playbook -i inventory.ini ./playbook.yml`

After this the server get's deployed with all the needed configuration.



