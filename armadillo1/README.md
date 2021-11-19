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
> | 70.000>       | 32             | 150               | 8         |
>
>
> The analysis to do methylation analysis follow these requirements:
>
> | Array size | Participants | Diskspace (in GB) | Memory (in	GB) |
> | ---------- | ------------ | ----------------- | --------------- |
> | 450.000    | 25        	  | 56,62             | 1,6             |
> |            | 100          | 216,37            | 3,4             |
> |            | 250          | 535,87            | 6,9             |
> |            | 500          | 1068,37           | 12,8            |
> |            | 750          | 1600,87		        | 18,6            |
> |            | 1000         | 2133,37           | 24,5            |
> |            | 2000         | 4263,37           | 47,9            |
> | 850.000    | 25           | 163,31            | 3,0             |
> |            | 100          | 641,06            | 8,2             |
> |            | 250          | 1596,56           | 18,5            |
> |            | 500          | 3189,06           | 35,8            |
> |            | 750          | 4781,56           | 53,0            |
> |            | 1000         | 6374,06           | 70,3            |
> |            | 2000         | 12744,06          | 139,4           |

## Usage 
To use Ansible to deploy the stack you need to binaries on your system. You can install Ansible following this [user guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). You need to be sure to run Ansible >- 2.9.

#### Setup
When you installed ansible you need to create 3 files:

- `inventory.ini`
- `playbook.yml`
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
  # if installing on local machine
  # connection: local
  gather_facts: true
  vars:
    ci: false
    minio:
      access_key: xxxxxxx
      secret_key: xxxxxxx
      port: 9000
      host: http://localhost
    oauth:
      issuer_uri: https://auth.molgenis.org
      discovery_path: /.well-known/openid-configuration
      client_id: xxxxxxx-xxxxxxxxx-xxxxxxxxxx
      client_secret: xxxxxxx-xxxxxxxxx-xxxxxxxxxx
    dockerhub:
      enabled: false
      username: xxxxxxx
      password: xxxxxxx

  roles:
    - role: security 
      vars:
        enabled: true
    - role: molgenis.armadillo.java
      vars:
        version: 11
    - role: molgenis.armadillo.minio
      vars:
        version: 2021-02-19T04-38-02Z
        data: /var/lib/minio/data
        domain: armadillo-storage.local
        access_key: "{{ minio.access_key }}"
        secret_key: "{{ minio.secret_key }}"
    - role: molgenis.armadillo.podman
      when: ansible_os_family == "RedHat"
    - role: molgenis.armadillo.docker
      when: ansible_os_family == "Debian"
    - role: molgenis.armadillo.nginx
      vars:
        enabled: true
        domains: 
          armadillo: armadillo.local
          storage: armadillo-storage.local
          auth: armadillo-auth.local
        letsencrypt:
          enabled: false
          acme:
            email: user@example.org
    - role: molgenis.armadillo.rserver
      vars:
        debug: false
        image:
          version: 2.0.0
          repo: datashield
          name: armadillo-rserver
        resources:
          memory: 6g
          cpu: 2
    - role: molgenis.armadillo.armadillo
      vars:
        version: 1.0.1
        storage:
          access_key: "{{ minio.access_key }}"
          secret_key: "{{ minio.secret_key }}"
          host: "{{ minio.host }}"
          port: "{{ minio.port }}"
        memory:
          xmx: 1024m
          xms: 512m
        username: xxxxx
        password: xxxxx
    - role: molgenis.armadillo.auth
      vars:
        image: 
          version: 0.3.2
          repo: molgenis
          name: molgenis-auth
        api_token: xxxxxxxxxxxxxxxxx
        base_url: http://armadillo-auth.local
        resources:
          memory: 1g
          cpu: 1
```

There are a few prerequisites that we need. 

##### "become" needs to work
When you login to a VM you are hopefully yourself as in a useraccount that is recognisable as your account. After you logged in you need to be able to perform `sudo su` without entering a password. Get that in place and you will be able to run the playbook. You can achieve this by adding this line at the end of the sudoers file.

```bash
root> visudo
$USER ALL=(ALL) NOPASSWD: ALL
```

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

 - role: auth
      vars:
        ...
        api_token: xxxxxxxxxxxxxxxxx
        ...
```



#### Domains to expose
There are three domains that need to be opened up for the cohort.

*For researchers*

- cohort.armadillo.domain.org

*For datamanagers*

- cohort-auth.armadillo.domain.org
- cohort-storage.armadillo.domain.org

The top one needs to be opened up to this ip-address: `129.125.243.25/32` with port number `443`.

##### Setup SSL
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

#### Deploy
You can install the galaxy collection using the following syntax:

`ansible-galaxy collection install molgenis.armadillo`

When you already installed the collection use the `--force` flag to update.

Example:

`ansible-galaxy collection install --force molgenis.armadillo`

Then install the server with Ansible.

`ansible-playbook -i inventory.ini ./playbook.yml`

After this the server get's deployed with all the needed configuration.

#### Upgrade
You need to create a separate playbook. Name it for example: `upgrade_armadillo.yml`

You can run it by executing: `ansible-playbook -i inventory.ini ./upgrade_armadillo.yml`

```yaml
- hosts: all
  become: yes
  become_user: root
  gather_facts: yes
  vars:
    ci: false
    minio:
      access_key: xxxxxxxx
      secret_key: xxxxxxxx
      port: 9000
      host: http://localhost
    oauth:
      issuer_uri: https://auth.molgenis.org
      discovery_path: .well-known/openid-configuration
      client_id: xxxxx-xxxxxxxx-xxxxxxx
      client_secret: xxxxx-xxxxxxxx-xxxxxxx
    dockerhub:
      enabled: false
      username: xxxxxxx
      password: xxxxxxx

  roles:
    - role: molgenis.armadillo.armadillo
      vars:
        version: 1.0.1
        storage:
          access_key: "{{ minio.access_key }}"
          secret_key: "{{ minio.secret_key }}"
          host: "{{ minio.host }}"
          port: "{{ minio.port }}"
        memory:
          xmx: 1024m
          xms: 512m
        username: xxxxxxx
        password: xxxxxxx
    - role: molgenis.armadillo.auth
      vars:
        image: 
          version: 0.3.2
          repo: molgenis
          name: molgenis-auth
        api_token: xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        base_url: http://armadillo-auth.local
        resources:
          memory: 512m
          cpu: 1
    - role: molgenis.armadillo.rserver
      vars:
        debug: false
        image:
          version: 2.0.0
          repo: datashield
          name: armadillo-rserver
        resources:
          memory: 6g
          cpu: 2
```

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


