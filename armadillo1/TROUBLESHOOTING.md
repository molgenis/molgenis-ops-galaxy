# Armadillo stack troubleshooting

### "become" needs to work
When you login to a VM you are hopefully yourself as in a useraccount that is recognisable as your account. After you logged in you need to be able to perform `sudo su` without entering a password. Get that in place and you will be able to run the playbook.

### Ansible installation: debian.yml not found
When you are deploying the armadillo stack with ansible, it could happen that you get this error saying that a file is not found. This is an known bug. If you have access to the system, please go to `/usr/share/armadillo` and type the following command for RHEL/CentOS systems: `podman-compose up -d`, for the other systems type: `docker-compose up -d`.

### Use of own certificate file(s)
If you want to use HTTPS for an secure connection you will need to get SSL certificate files. You could also add a SSL wildcard certificate file(not every company/institute allows that). You will need to do the following things:
1. Get the certificate files(domain.cer/domain.key)
2. When you have received the certificate files you will need to copy them on the server
3. Make a backup of the files located in `/etc/nginx/default.d`(RHEL/CentOS) or `/etc/nginx/sites-available`(Debian/Ubuntu) with an extension other then conf
4. We have given example configuration files for SSL termination, copy the the files given in `/etc/nginx/examples/` to `/etc/nginx/sites-available`(Debian/Ubuntu) or `/etc/nginx/default.d`(RHEL/CentOS)
5. Edited the armadille_ssl.conf file copied in step 4 and add the location of the certificate file to `ssl_certificate` and add the location of the key file to `ssl_certificate_key`
6. Repeat the process for all the *_ssl.conf files
7. After editing the files, check if everything is looking file with the command: `nginx -t`
8. If there are no problems displayed, restart nginx with `systemctl restart nginx`
9. Test if the configuration is working with RStudio

### I can not connect to the server
1. If you go to the commandline of the local machine and type `nslookup <armadillo domain>`. You should get an A record back with an IP address. If not, you need to ask the IT department to let the domains(Armadillo, MinIO, MinIO console and authentication application) go to the server.
2. If you go to the armadillo domain website and you get an 503 error, you will need to check if the NginX application is running. To do that, you will need to type `systemctl status nginx` into the terminal. If you see an red dot or read "nginx has stopped" than you need to restart nginx. To do that type `systemctl restart nginx` in the terminal and press enter. If all went well you don't get anything back from the terminal. Than you try again.
3. If the nginx application is running but you don't see a Armadillo website appear, you will need to check if the containers are running. To do that, you need to start the terminal(if not opened already) and type the following command `docker ps -a`. If you don't see any containers showing up or see containers with exited state you will need to restart our docker-compose stack. Go to `/usr/share/armadillo` and type: `docker-compose down; docker-compose up -d`(Debian/Ubuntu) or `podman-compose down; podman-compose up -d`(RHEL/CentOS). Chack with `docker ps -a` to see that is running again. If so, try to go to the armadillo domain website.
4. If you are within RStudio and get an error that it is not possible to connect to the Armadillo application. The applications used are very strict about the certificate provided must be an fully qualified domain. You will need to check if the certificate that is provided has the proper chain. To do this you will need to go to the website [ssl checker](https://www.sslshopper.com/ssl-checker.html) and fill in the different domains. If you see an broken lock by the chain you will need to fix it. You can ask the IT department to fix it or you need to download the intermediate/root certificate and copy it underneath the certificate  in the certificate file. Do this for every domain and restart nginx(`systemctl restart nginx`). Then retry with the [ssl checker](https://www.sslshopper.com/ssl-checker.html) and check if the action taken resolved the broken chain. If so, retry with RStudio to connect.

### It is not possible to sign into the central authentication server
That can have a couple of problems.
1. When you received a mail from `molgenis-support@umcg.nl` with the things you needed to change you copied somethings wrong. This could be a space to mutch in the copied strings, incomplete string(forgot to copy a (special) character/number) or a wrong issuer_uri(default: auth.molgenis.org but maybe has to be lifecycle-auth.molgenis.org). You need to check if you copied everything over correctly. If you didn't than you need to run the playbook.yml again with ansible.
