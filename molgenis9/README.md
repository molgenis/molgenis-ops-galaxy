# Ansible Collection - molgenis.molgenis9

## Migration from Molgenis8 (molgenis 8.x.y)
Molgenis 9.x.y contains a new expression language. This means that if you used expressions in Molgenis before, you need to adapt them during the migration.
See the Molgenis 9.0.5 release notes: https://github.com/molgenis/molgenis/releases/tag/molgenis-9.0.5
"This means that all expressions in your data models need to be rewritten. This should be fairly straightforward, but contact us if you need help on molgenis-support@umcg.nl"



## Usage

### Image remote server through ssh and ansible
'ansible-galaxy collection install molgenis.molgenis9'

You can use ansible to setup up a basic molgenis server on a remote linux machine. At the moment we support the following Linux flavours:

* RedHat/CentOS 7 (EoL June 2024)
* RedHat Enterprise Linux 8 (EoL May 2029)
* CentOS 8 (EoL December 2021)
* Ubuntu 20.04 (EoL April 2025)
* RockyLinux 8 (EoL May 2029)

The RedHat/CentOS/Rocky servers needs to have selinux enabled (might need a reboot) before your run the playbook.
It is also recommended to first upgrade/patch your server to the latest patch level, before running the playbook.

You need to have setup an ssh trust between the system your run ansible on and the remote linux server root account where molgenis will be installed.

First create an inventory.ini file with the FQDNs/ip addresses of your target hosts. Then execute the next command (from the `molgenis9` directory):

'ansible-playbook playbook.yml -e memory="4"' 

We currently support automatic memory configuration for 4, 8 and 16 Gb of memory. This way tomcat/java and elasticsearch each get a decent amount of memory for Molgenis to run.


To upgrade a remote molgenis server to a newer molgenis verion, you can run:

'ansible-playbook playbook_upgrade.yml' 


### Usage locally for testing purposes
You can use Vagrant to boot up the image. Please execute (from the `molgenis8` directory):

`vagrant up`

When updating the playbook
`vagrant up --provision`

When running a specific version of and OS:

`VAGRANT_VAGRANTFILE=Vagrantfile.centos7 vagrant up`

Access the instance from `http://localhost:8080` in the browser.
