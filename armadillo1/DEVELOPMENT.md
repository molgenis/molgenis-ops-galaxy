# Development and testing of the Armadillo stack
To test the deployment we are using Vagrant to deploy the ansible playbook locally on your machine. You will need some prerequisites to deploy locally.

* [Vagrant](https://www.vagrantup.com/downloads)
* [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
* [git](https://git-scm.com/downloads)

## Creating the configuration
Create a file called: `Vagrant` with the following configuration:

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

Create an file called `playbook.yml` with the content described here: [ansible galaxy content](#creating-playbook.yml).

## Running the VM
> Caveat for mac!
Vagrant uses Virtualbox which in turn requires an Oracle kernel extension to work.
If the installation fails, retry after you enable it in:
  System Preferences → Security & Privacy → General
For more information, refer to virtualbox vendor documentation or this [Apple Technical Note](https://developer.apple.com/library/content/technotes/tn2459/_index.html).

## Installing dependencies
Before you can deploy, you need to install the dependencies by running

```bash
> ansible-galaxy install -r requirements.yml
```

## Configure secrets
By default, Armadillo Localhost application uses auth.molgenis.org.
You have to fill in [OIDC client]() secret and [auth server api key]() in `playbook.yml`.

## Running Vagrant
Run: `vagrant up`

When you want to provision:

Update playbook: `vagrant up --provision`

To run a specific operating system please run: `VAGRANT_VAGRANTFILE=Vagrantfile.centos7 vagrant up`.
Make sure you start clean, so remove leftover initialisations of vagrent by executing `rm -rf .vagrant`.

The vagrant box will bind on port 8080 to the host. If you add this block to the `etc/hosts`-file, the domains in NGINX will resolve.

```
# To allow vagrant httpd to bind to the internal domains
127.0.0.1 armadillo.local armadillo-storage.local armadillo-auth.local
# End section
``` 

You are done. You can reach the four services on:

* Armadillo service working with DataSHIELD
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

Only the storage webinterface server has a user interface. The DataSHIELD service works with R only.
