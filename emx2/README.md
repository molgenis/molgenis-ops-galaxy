# Ansible Collection - molgenis.emx2

This ansible script
* installs postgresql13 including molgenis database setup
* installs httpd
* downloads molgenis-emx2-x.y.z.jar file & configures start/stop as a service on port 8080
* sets up virtual host 

## Usage
You can use Vagrant to boot up the image. Please execute (from the `emx2` directory):

`vagrant up`

When updating the playbook
`vagrant up --provision`

On Mac M1 install Parallels Desktop, then install ubuntu and therein run vagrant (lol)

`vagrant plugin install vagrant-parallels`


Access the instance from `http://localhost` in the browser.