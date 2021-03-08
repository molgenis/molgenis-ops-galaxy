# Troubleshooting guide

## CentOS
Trouble on your CentOS/Redhat based systems.

### ipv6 disabled on your system
You need to have ipv6 enabled.

* Edit your boot configuration: `vi /etc/default/grub`
* Please change the parameter `ipv6.disable=1` to `ipv6.disable=0`
* Then recreate your boot configuration `grub2-mkconfig -o /boot/grub2/grub.cfg`
* Your are done! `reboot` now!