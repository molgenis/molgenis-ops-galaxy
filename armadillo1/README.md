# Armadillo 2 is superceeded by Armadillo 3
# Please go to: [Armadillo 3 install guide](https://github.com/molgenis/molgenis-service-armadillo/tree/master/scripts/install)

---

# Armadillo suite
This guide is to deploy the DataSHIELD Armadillo suite.

> ## If you are interested to try out the DataSHIELD Armadillo suite, let's get in touch and start the conversation. Please mail `molgenis-support@umcg.nl` to say hi. ##

### Note: [Should you have any problems, please click here for common problems and solutions.](https://github.com/molgenis/molgenis-ops-galaxy/blob/main/armadillo1/TROUBLESHOOTING.md)

### Note: [For information about upgrading, click here](https://github.com/molgenis/molgenis-ops-galaxy/blob/main/armadillo1/UPGRADE.md)

### Note: [For developers, click here to start developing or testing.](https://github.com/molgenis/molgenis-ops-galaxy/blob/main/armadillo1/DEVELOPMENT.md)

> ## Requirements of the server
>
> Technical resources needed to run your cohort are here. You need a server / virtual machine (from now on VM) to deploy the 
> Armadillo stack. The specifications of the VM are the following depending on the participant size of the cohort you are running.
>
> | Participants  | Memory (in GB) | Diskspace (in GB) | CPU cores |
> | ------------- | -------------- | ----------------- | --------- |
> | 0-20.000      | 8              | 100               | 4         |
> | 20.000-70.000 | 16             | 100               | 4         |
> | 70.000 >      | 32             | 150               | 8         |
> 
> The Armadillo stack runs on the Linux operating system. This installation can be performed on Redhat, CentOS, Rocky, Debian and Ubuntu distro's.
>
> ## Requirements of the software
> ### Ansible
> To install the Armadillo stack we make use of a program called Ansible. Ansible is used to make the installation and configuration eassier. To use Ansible to deploy the Armadillo stack you need to install the binaries on your system. You can install Ansible following this [user guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). You need to be sure to run Ansible **>= 2.9**.
>
> ### The sudo command needs to work
> When you logging into a VM you log in as a user other than root. After you logged in you need to be able to perform `sudo su` without entering a password. This need to be possible for the `pb_install-armadillo.yml` to function properly. The Ansible function `become` depends on it. Get that in place and you will be able to run the `pb_install-armadillo.yml` playbook.
> 
> If the user can not execute `sudo su` without entering a password, you will need to change the following things:
> 1. Login as the super user(root) account
> 2. Type:
> ```bash
> root> visudo
> ?user? ALL=(ALL) NOPASSWD: ALL
> ```
> Note: the `?user?` is the non-super user(root) user where you want to install the ansible playbook with.
> 3. Save the file and close it
> 4. Test again 
>
> ### Firewall whitelisting
> You will need to add whitelisting from your infrastructure to allow the Armadillo application domain to communicate with the central analysis server. You will need to open to this ip-address: `129.125.243.25/32` with port number `443`.

### Domains
There are four domains needed. This domains are for the armadillo, authentication, storage and storage console. It could be look something like this:

| Domain                                      | Application   | User endpoint |
| ------------------------------------------- | ------------- | ------------- |
| cohort.armadillo.domain.org                 | Armadillo     | Researchers   |
| cohort-auth.armadillo.domain.org            | Fusionauth    | Datamanagers  |
| cohort-storage.armadillo.domain.org         | MinIO         | Datamanagers  |
| cohort-storage-console.armadillo.domain.org | MinIO Console | Datamanagers  |

The application names and domains are referenced later on in the setup guide as an example.

### SSL certificate(s)
If you want to secure the connection with an SSL certificate(s) for HTTPS you need to get your OWN SSL certificate(s). We can't do it for you. You will need to get SSL certificate(s) for [all the domains.](#domains)

### Authentication
Before we start with the deployment of the Armadillo stack you will need to register your domains that you are going to use with your Armadillo stack on the DataSHIELD authentication server. This allows you to delegate the authentication and user management. The authorisation will still be under the control of the Data Manager(who gets access and who don't get access). To registrate you will need to send a mail to `molgenis-support@umcg.nl` with the [chosen domains](#domains) for the authentication, Minio and Minio console applications. Also add to the mail that you want to register for the the DataSHIELD authentication server and if you belong to a project like Lifecycle, Athlete or Longitools. When the Armadillo stack is registrerd you will get an mail back with data that need to be inserted in the [Authentication and authorisation section](#authentication-and-authorisation). 

## Usage 
We first begin with creating 2 files for ansible to work, namely:

- `inventory.ini`
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
  source: https://galaxy.ansible.com
- name: community.general
  source: https://galaxy.ansible.com
```

### Installation of the requirements
Install the prerequisites this way:

`ansible-galaxy install -r requirements.yml`

You can install the galaxy collection using the following syntax:

`ansible-galaxy collection install molgenis.armadillo`

When you already installed the collection use the `--force` flag to update.

Example:

`ansible-galaxy collection install --force molgenis.armadillo`

### Editing pb_install-armadillo.yml
The playbook [pb_install-armadillo.yml](https://github.com/molgenis/molgenis-ops-galaxy/blob/main/armadillo1/pb_install-armadillo.yml) is the base of the rollout for the Armadillo stack. The playbook can be found here: `<user home directory>/.ansible/collections/ansible_collections/molgenis/armadillo/pb_install-armadillo.yml`.
We will show snippets of code of the playbook that you need to change down below.

We recommend to copy `pb_install-armadillo.yml` to the `<user home directory>` and edit it there.

### Changes that have to be made
Opened `pb_install-armadillo.yml`, you will need to edit the following parts of the playbook:

`Tip: Encapsulate("") usernames, passwords and secrets in double quotes to prevent login issues.`

1. The `root_user` and `root_password` need to be changed into something unique and secure
2. The domain of the minio need to be changed to the domain of the MinIO application
3. If you want to upload data directly into MinIO console(website) you will need to set enabled to true by the console
4. If you have enabled the MinIO Console, alse add the domain from the MinIO Console application
5. Add the different domains you have selected to the post_nginx role. See the configuration example below:

```yaml
    minio:
      root_user: xxxxxxxx
      root_password: xxxxxxxx
...
      domain: cohort-storage.armadillo.domain.org
      host: http://minio
      console:
        enabled: true
...
        domain: cohort-storage-console.armadillo.domain.org
...
    - role: post_nginx
      vars:
        enabled: true
        domains: 
          armadillo: cohort.armadillo.domain.org
          storage: "{{ minio.domain }}"
          console: "{{ minio.console.domain }}"
          auth: cohort-auth.armadillo.domain.org
```

> Keep in mind that when you see something like this: `storage: "{{ minio.domain }}"` it will be filled in automatically. You don't have to change it.

### Authentication and authorisation
When you receive a mail from `molgenis-support@umcg.nl` with the the variables that need to be changed you will need to edit the the following parts in the `pb_install-armadillo.yml`:

1. `issuer_uri`
2. `client_id`
3. `client_secret`
4. `api_token`

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
     base_url: cohort-auth.armadillo.domain.org
   ...
```

### Define new R environments and corresponding R profiles
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

#### Setup SSL
There are 2 ways of setting up SSL for secure communication.
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
When you want to use your own SSL certificate files, you will need to do the following steps:
1. Purchase your own SSL certificate files for the [given domains](#domains)
2. Store the SSL certificate on an NGINX readable location like `/etc/ssl/certs`(Debian based systems) or `/etc/pki/tls/certs`(RHEL/CentOS based systems)
> Note: The SSL certificate needs to have the certificate, intermediate and root CA certifcate in one file in the same order given here. The certificate files need to be encoded to a PEM file.
3. Copy the provided example configuration from `/etc/nginx/examples` to `/etc/nginx/default.d/`(RHEL/CentOS) or `/etc/nginx/sites-available/`(Debian/Ubuntu)
4. The copied files need to be edited, you will need to add the certificate location and the certificate private key location. You need to change `ssl_certificate` and `ssl_certificate_key` in every file to the location from step 2
5. Remove or disable the the old configuration files(if not done before)
6. Type in the commandline: `nginx -t` to see if everything is configured correctly, restart NGINX

> Note: The SSL certificate(s) have a limited lifespan and need to be changed yearly. You are responsible to renew the SSL certificate(s).

### Installation and deployment of the Armadillo stack
To setup and use the Armadillo stack with Ansible, use the following command:

`ansible-playbook -i inventory.ini pb_install-armadillo.yml`

When you finish this command you have setup a working Armadillo stack on the server.

## What's next?

* [For the server owner or data manager who need to put data on to the server](https://molgenis.github.io/molgenis-r-armadillo/)
* [For the researcher who want to start analysing the data on the server](https://molgenis.github.io/molgenis-r-datashield/)