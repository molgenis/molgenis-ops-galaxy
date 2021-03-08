# Troubleshooting guide

## All os's

### Running Rserver container results in error code: 127
You need to stop the rserver service.
`systemctl stop rserver`

Then you need to prune all docker resources
* CentOS / RHEL
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

