# Ansible Collection - molgenis.molgenis8

## Usage
You can use Vagrant to boot up the image. Please execute (from the `molgenis8` directory):

`vagrant up`

When updating the playbook
`vagrant up --provision`

When running a specific version of and OS:

`VAGRANT_VAGRANTFILE=Vagrantfile.centos7 vagrant up`

Access the instance from `http://localhost:8080` in the browser.