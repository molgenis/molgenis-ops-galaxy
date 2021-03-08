# Armadillo suite
Deploy the Armadillo suite.


## Usage 


### Development and testing
To test the deployment we are using Vagrant to deploy the ansible playbook locally on your machine. You will need some prerequisites to deploy locally.

* [Vagrant](https://www.vagrantup.com/downloads)
* [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
* [git](https://git-scm.com/downloads)


#### Creating the configuration
Create a file called: `Vagrant` looking like this:

```javascript
Vagrant.configure("2") do |config|
  config.vm.box = "centos/8"
  config.vm.box_version = "2011.0"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.customize ['modifyvm', :id, '--graphicscontroller', 'none']
    vb.customize ['modifyvm', :id, '--audio', 'none']
  end
  config.vm.provision "ansible" do |ansible|
    ansible.limit = "all"
    ansible.playbook = "i_setup_armadillo_1.yml"
    ansible.verbose = false
  end
end
```

Create an file called `playbook.yml` with the content from here: [ansible galaxy content](#creating-playbook.yml).

### Running the VM
> Caveat for mac!
Vagrant uses Virtualbox which in turn requires an Oracle kernel extension to work.
If the installation fails, retry after you enable it in:
  System Preferences → Security & Privacy → General
For more information, refer to virtualbox vendor documentation or this [Apple Technical Note](https://developer.apple.com/library/content/technotes/tn2459/_index.html).

#### Installing dependencies
Before you can deploy, you need to install the dependencies by running

```bash
> ansible-galaxy install -r requirements.yml
```

#### Configure secrets
By default, uses the Armadillo Localhost application in auth.molgenis.org.
You have to fill in OIDC client secret and auth server api key in `playbook.yml`.

Run: `vagrant up`

When you want to provision:

Update playbook: `vagrant up --provision`

To run a specific operating system please run: `VAGRANT_VAGRANTFILE=Vagrantfile.centos7 vagrant up`.
Make sure you start clean, so remove leftover initialisations of vagrent by executing `rm -rf .vagrant`.

The vagrant box will bind on port 8080 to the host. If you add this block to the `etc/hosts`-file, the domains 
in NGINX will resolve.

```
# To allow vagrant httpd to bind to the internal domains
127.0.0.1 armadillo.local armadillo-storage.local armadillo-auth.local
# End section
``` 

You are done. You can reach both services on:

* Armadillo service to wok with DataSHIELD
  http://armadillo.local:8080
* Armadillo storage service to store you files on
  http://armadillo-storage.local:8080
* Armadillo authentication service to store you files on
  http://armadillo-auth.local:8080

Login with:

* username: admin
* password: admin

Only the storage server has a user interface. The DataSHIELD service works with R only.

## Ansible
To use Ansible to deploy the stack you need to binaries on your system. You can install Ansible following this [user guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).

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
      access_key: molgenis
      secret_key: molgenis
      port: 9000
      host: http://localhost
    oauth:
      issuer_uri: https://auth.molgenis.org
      discovery_path: /.well-known/openid-configuration
      client_id: xxxxxxx-xxxxxxxxx-xxxxxxxxxx
      client_secret: xxxxxxx-xxxxxxxxx-xxxxxxxxxx

  roles:
    - role: molgenis.molgenis8.preinstall_centos8
    - role: molgenis.molgenis8.java_centos8
    - role: molgenis.molgenis8.minio_centos8
      vars:
        access_key: "{{ minio.access_key }}"
        secret_key: "{{ minio.secret_key }}"
    - role: podman_centos8
    - role: nginx_centos8
      vars:
        domains: 
          armadillo: armadillo.local
          storage: armadillo-storage.local
          auth: armadillo-auth.local
    - role: rserver_centos8
      vars:
        debug: true
        image:
          version: 1.8.0
          repo: molgenis
          name: rserver
        resources:
          memory: 6g
          cpu: 2
    - role: armadillo_centos8
      vars:
        version: 0.0.15
        storage:
          access_key: "{{ minio.access_key }}"
          secret_key: "{{ minio.secret_key }}"
          host: "{{ minio.host }}"
          port: "{{ minio.port }}"
        memory:
          xmx: 1024m
          xms: 512m
    - role: auth_centos8
      vars:
        image: 
          version: latest
          repo: molgenis
          name: molgenis-auth
        api_token: xxxxxxxxxxxxxxxxx
        base_url: armadillo-auth.local
        resources:
          memory: 1g
          cpu: 1
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
      client_secret: xxxxxxx-xxxxxx-xxxxxxx
...
```
#### Usage
When you created the correct files and filled in the right variables you need to perform a series of commands to bootstrap the server with the Armadillo.

Make sure the following domains are whitlisted in on your deploy environment.

* dl.minio.io
* auth.molgenis.org
* registry-1.docker.io
* production.cloudflare.docker.com
* registry.molgenis.org
* registry.access.redhat.com
* galaxy.ansible.com
* ansible-galaxy.s3.amazonaws.com
* raw.githubusercontent.com

First get your collections installed.

`ansible-galaxy install -r requirements.yml`

Then install the server with Ansible.

`ansible-playbook -i inventory.ini ./playbook.yml`

After this the server get's deployed with all the needed configuration.

# Requirements

Technical resources needed to run your cohort are here. You need a server / virtual machine (from now on VM) to deploy the Armadillo. The specifications of the VM are the following depending on the participant size of the cohort you are running.

| Participants  | Memory (in GB) | Diskspace (in GB) | CPU cores |
| ------------- | -------------- | ----------------- | --------- |
| 0-20.000      | 8              | 100               | 4         |
| 20.000-70.000 | 16             | 100               | 4         |
| 70.000>       | 32             | 150               | 8         |



