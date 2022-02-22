#!/bin/bash
echo "Stop firewall to execute renewal"
systemctl stop firewalld
echo "Start renewal of SSL certificates"
/root/.acme.sh/acme.sh --cron --home /root/.acme.sh
echo "Start firewall"
systemctl start firewalld
