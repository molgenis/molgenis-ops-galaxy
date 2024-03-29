# Troubleshooting guide

## All os's

### Using an internet proxy
Domains that need to be open in the internet proxy. 

Make sure the following domains are whitlisted in on your deploy environment.

* dl.minio.io
* auth.molgenis.org
* production.cloudflare.docker.com
* registry.molgenis.org
* galaxy.ansible.com
* ansible-galaxy.s3.amazonaws.com
* raw.githubusercontent.com

Wildcard domains
* registry.hub.docker.com
* index.docker.io

* *.docker.com
* *.docker.io
* *.redhat.io
* *.access.redhat.com

### Check the logging for the docker services
There are 2 docker services at the moment:
- armadillo-auth
- rserver

You can check the logging by executing:
```bash
journalctl CONTAINER_NAME=rserver.service --all
journalctl CONTAINER_NAME=armadillo-auth.service --all
```
### Collection could not be installed
If the following error occurs `collections was NOT installed successfully: Content has no field named 'owner'` you need to upgrade 

### Running Rserver container results in error code: 127
You need to stop the rserver service.
`systemctl stop rserver`

Then you need to prune all docker resources
* CentOS / RedHat
  `podman system prune`

* Ubuntu / Debian
  `docker system prune`

Then restart the service again. 
`systemctl restart rserver`

## CentOS
Trouble on your CentOS/Redhat based systems.

### ipv6 disabled on your system
You need to have ipv6 enabled.

* Edit your boot configuration: `vi /etc/default/grub`
* Please change the parameter `ipv6.disable=1` to `ipv6.disable=0`
* Then recreate your boot configuration `grub2-mkconfig -o /boot/grub2/grub.cfg`
* Your are done! `reboot` now!

### Correct the time with chronyd
Please follow the instructions below

```bash
chronyc makestep
chronyc ntpdata
timedatectl
```