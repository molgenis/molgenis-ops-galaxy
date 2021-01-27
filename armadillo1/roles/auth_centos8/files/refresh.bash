#!/usr/bin/bash
cd /usr/share/armadillo/auth
# check if rserver is known in systemctl, if that is the case stop it, and remove it safely
if  systemctl list-unit-files | grep armadillo-auth
then
  systemctl stop armadillo-auth
  systemctl disable armadillo-auth
  rm -f /etc/systemd/system/armadillo-auth.service
  systemctl daemon-reload
  podman rm armadillo-auth
fi

/usr/share/armadillo/auth/start.bash
podman generate systemd --name rserver > /etc/systemd/system/armadillo-auth.service
podman stop armadillo-auth
systemctl daemon-reload
systemctl enable armadillo-auth
systemctl start armadillo-auth
