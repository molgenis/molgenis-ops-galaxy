# Armadillo suite
Deploy the Armadillo suite.

> Requirements
>
> Technical resources needed to run your cohort are here. You need a server / virtual machine (from now on VM) to deploy the 
> Armadillo. The specifications of the VM are the following depending on the participant size of the cohort you are running.
>
> | Participants  | Memory (in GB) | Diskspace (in GB) | CPU cores |
> | ------------- | -------------- | ----------------- | --------- |
> | 0-20.000      | 8              | 100               | 4         |
> | 20.000-70.000 | 16             | 100               | 4         |
> | 70.000 >      | 32             | 150               | 8         |

## Usage 
To use Ansible to deploy the stack you need to binaries on your system. You can install Ansible following this [user guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). You need to be sure to run Ansible **>= 2.9**.

When you installed ansible you need to create 3 files:

- `inventory.ini`
- `playbook.yml`
- `requirements.yml`

### Creating inventory.ini
Your target host needs to be defined here.

```ini
# used for initial setup of new empty VM's
[armadillo]
x.x.x.x # ip address of the system
```

### Creating requirements.yml
Your requirements are as follows

```yaml
---
collections:
# install collections from Ansible Galaxy
- name: ansible.posix
  version: 1.1.1
  source: https://galaxy.ansible.com
- name: community.general
  version: 2.0.1
  source: https://galaxy.ansible.com
```
### Creating playbook.yml
The playbook is the base of the rollout for the Armadillo. The contents of the playbook is shown below.
You should edit the section with the 'vars'

```yaml
---
- hosts: all
  become: true
  become_user: root
  # if installing on local machine
  # connection: local
  gather_facts: true
  vars:
    ci: false
    minio:
      root_user: xxxxxxx
      root_password: xxxxxxx
      port: 9000
      domain: armadillo-storage.local
      host: http://minio
      console:
        enabled: false
        port: 9090
        domain: armadillo-storage-console.local
    oauth:
      issuer_uri: https://auth.molgenis.org
      discovery_path: /.well-known/openid-configuration
      client_id: xxxxxxx-xxxxxxxxx-xxxxxxxxxx
      client_secret: xxxxxxx-xxxxxxxxx-xxxxxxxxxx
    rserve:
      environments:
        - name: default
          enabled: true
          debug: false
          image:
            version: latest
            repo: datashield
            name: armadillo-rserver
          exposed_port: 6311

  roles:
    - role: molgenis.armadillo.deps_podman
      vars:
        redhat:
          subscription:
            enabled: false
            username: xxxxxxxx
            password: xxxxxxxx
      when: ansible_os_family == "RedHat" or ansible_os_family == "Rocky"
    - role: molgenis.armadillo.deps_docker
      when: ansible_os_family == "Debian"
    - role: molgenis.armadillo.deps_compose
    - role: molgenis.armadillo.service_armadillo
      vars:
        version: 2.2.0
        storage:
          root_user: "{{ minio.root_user }}"
          root_password: "{{ minio.root_password }}"
          host: "{{ minio.host }}"
          port: "{{ minio.port }}"
        username: xxxxx
        password: xxxxx
        datashield:
          profiles:
            - name: "{{ rserve.environments[0].name }}"
              enabled: "{{ rserve.environments[0].enabled }}"
              environment: "{{ rserve.environments[0].name }}"
              whitelist:
                - dsBase
              # options:
                # datashield:
                # override default DataSHIELD options
    - role: molgenis.armadillo.service_minio
      vars:
        version: 2022-01-25T19-56-04Z
        data: /var/lib/minio/data
        protocol: http
        domain: "{{ minio.domain }}"
        root_user: "{{ minio.root_user }}"
        root_password: "{{ minio.root_password }}"
        console:
          version: 0.14.8
    - role: molgenis.armadillo.service_auth
      vars:
        image: 
          version: 0.3.2
          repo: molgenis
          name: molgenis-auth
        api_token: xxxxxxxxxxxxxxxxx
        base_url: http://armadillo-auth.local
    - role: molgenis.armadillo.service_rserve
    - role: molgenis.armadillo.post_assemble
    - role: molgenis.armadillo.post_nginx
      vars:
        enabled: true
        domains: 
          armadillo: armadillo.local
          storage: "{{ minio.domain }}"
          console: "{{ minio.console.domain }}"
          auth: armadillo-auth.local
        letsencrypt:
          enabled: false
          acme:
            email: user@example.org
    - role: molgenis.armadillo.tools_upgrade
```

There are a few prerequisites that we need. 

### "become" needs to work
When you login to a VM you are hopefully yourself as in a useraccount that is recognisable as your account. After you logged in you need to be able to perform `sudo su` without entering a password. Get that in place and you will be able to run the playbook.

### Authentication and authorisation
Before you deploy you need to register your application on the DataSHIELD authentication server. This allows you to delegate the authentication and usermanagement. The authorisation will still be under your control.

The general variables in the `playbook.yml` need to be amended to set the configuration right:

```yaml
...
 oauth:
  issuer_uri: https://auth.molgenis.org
  discovery_path: /.well-known/openid-configuration
  client_id: xxxxxxx-xxxxxx-xxxxxxx
  client_secret: xxxxxxx-xxxxxx-xxxxxxx
...

 - role: service_auth
      vars:
        ...
        api_token: xxxxxxxxxxxxxxxxx
        ...
```

### Define new environments and corresponding profiles
When you are asked to serve new analysis profiles you can add them defining the environment and the profile.

```yaml
# environments
   ...
   rserve:
      environments:
        ...
        - name: exposome
          enabled: true
          debug: false
          image:
            version: latest
            repo: datashield
            name: armadillo-rserver-exposome
          exposed_port: 6311
```

```yaml
# profiles
   - role: molgenis.armadillo.service_armadillo
     vars:
       ...
       datashield:
         profiles:
           - name: "{{ rserve.environments[1].name }}"
             enabled: "{{ rserve.environments[1].enabled }}"
             environment: "{{ rserve.environments[1].name }}"
             whitelist:
               - dsBase
               - dsExposome
```

Be sure to add the profile to the corresponding environment. To retrieve the details of the environments that you want to server you can ask molgenis-support@umcg.nl.

### Domains to expose
There are three domains that need to be opened up for the cohort.

*For researchers*

- cohort.armadillo.domain.org

*For datamanagers*

- cohort-auth.armadillo.domain.org
- cohort-storage.armadillo.domain.org
- cohort-storage-console.armadillo.domain.org

The top one needs to be opened up to this ip-address: `129.125.243.25/32` with port number `443`.

#### Setup SSL
There are 2 ways of setting up SSL.
- Use Letsencrypt
- Use your own certificates

**Use Letsencrypt**

You can toggle the boolean in the nginx-role to true and fill you email address to enable Letsencrypt certificates.

```yaml
  - role: molgenis.armadillo.post-nginx
      vars:
     
        ...

        letsencrypt:
          enabled: true
            acme:
              email: user@example.org
    
        ...

```

This will install certificates and a renewal mechanism.

**Use your own certificates**

Below you can find an exmaple configuration for NGINX. The **bold** blocks show what you need to change. NGINX expects the fullchain. So PEM format in short.
<pre>
server {
    listen 443 ssl;
    server_name domain.org;
    
    ssl_certificate /etc/ssl/certs/star.domain.org.crt;
    ssl_certificate_key /etc/ssl/certs/star.domain.org.key;
    
    include /etc/nginx/globals.d/*.conf;
    
    ...
    
}
</pre>

### Deploy
Install the prerequisites this way:

`ansible-galaxy install -r requirements.txt`

You can install the galaxy collection using the following syntax:

`ansible-galaxy collection install molgenis.armadillo`

When you already installed the collection use the `--force` flag to update.

Example:

`ansible-galaxy collection install --force molgenis.armadillo`

Then install the server with Ansible.

`ansible-playbook -i inventory.ini playbook.yml`

After this the server get's deployed with all the needed configuration.

## Development and testing
To test the deployment we are using Vagrant to deploy the ansible playbook locally on your machine. You will need some prerequisites to deploy locally.

* [Vagrant](https://www.vagrantup.com/downloads)
* [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
* [git](https://git-scm.com/downloads)

### Creating the configuration
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
    ansible.playbook = "playbook.yml"
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

### Installing dependencies
Before you can deploy, you need to install the dependencies by running

```bash
> ansible-galaxy install -r requirements.yml
```

### Configure secrets
By default, uses the Armadillo Localhost application in auth.molgenis.org.
You have to fill in [OIDC client]() secret and [auth server api key]() in `playbook.yml`.

### Running Vagrant
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
  http://armadillo.local
* Armadillo storage service to store you files on
  http://armadillo-storage.local
* Armadillo storage webinterface to store you files on
  http://armadillo-storage-console.local
* Armadillo authentication service to store you files on
  http://armadillo-auth.local

Login with:

* username: **admin**
* password: **admin**

Only the storage server has a user interface. The DataSHIELD service works with R only.
