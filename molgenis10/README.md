# Ansible Collection - molgenis.molgenis10

## Migration from Molgenis9 (molgenis 9.1.y)
Molgenis 10.x.y uses elasticsearch 7 



## Usage

### Image remote server through ssh and ansible
'ansible-galaxy collection install molgenis.molgenis10'

You can use ansible to setup up a basic molgenis server on a remote linux machine. At the moment we support the following Linux flavours:

* RedHat/CentOS 7 (EoL June 2024)
* RedHat Enterprise Linux 8 (EoL May 2029)
* Ubuntu 20.04 (EoL April 2025)
* RockyLinux 8 (EoL May 2029)

The RedHat/Rocky servers needs to have selinux enabled (might need a reboot) before your run the playbook.
It is also recommended to first upgrade/patch your server to the latest patch level, before running the playbook.

You need to have setup an ssh trust between the system your run ansible on and the remote linux server root account where molgenis will be installed.

First create an inventory.ini file with the FQDNs/ip addresses of your target hosts. Then execute the next command (from the `molgenis10` directory):

'ansible-playbook playbook.yml -e memory="4"' 

We currently support automatic memory configuration for 4, 8 and 16 Gb of memory. This way tomcat/java and elasticsearch each get a decent amount of memory for Molgenis to run.


To upgrade a remote molgenis server to a newer molgenis version within 10.x.y versioin range, you can run:

'ansible-playbook playbook_upgrade.yml'

To upgrade a molgenis 9.x.y server to molgenis 10.x.y, you can run:

'ansible-playbook playbook_upgrade_from_9.yml -e memory="4"'


### Usage locally for testing purposes
You can use Vagrant to boot up the image. Please execute (from the `molgenis10` directory):

`vagrant up`

When updating the playbook
`vagrant up --provision`

When running a specific version of and OS:

`VAGRANT_VAGRANTFILE=Vagrantfile.centos7 vagrant up`

Access the instance from `http://localhost:8080` in the browser.
