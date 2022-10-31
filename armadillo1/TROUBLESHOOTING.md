# Armadillo stack troubleshooting

### "become" needs to work
When you logging into a VM you log in as a user other than root. After you logged in you need to be able to perform `sudo su` without entering a password. Get that in place and you will be able to run the playbook.

If the user can not execute `sudo su` without entering a password, you will need to change the following things:
1. Login with the super user(root) account
2. Type:
```bash
root> visudo
?user? ALL=(ALL) NOPASSWD: ALL
```
3. Save the file and close it
4. Test again

### Ansible installation: debian.yml not found
If during deploying armadillo you get the message a file is not found and you have access to the system, please go to `/usr/share/armadillo` and type: `podman-compose up -d` (for RHEL/CentOS) or `docker-compose up -d` (for other systems)..

### Use of own certificate file(s)
To get a secure connection via HTTPS, you need to install SSL certificate files. <ins>We are not able to get these for you, please retrieve them yourself.</ins> Some companies/institutes have SSL wildcard certificates, these could be used. Please follow the following steps:
1. Get the certificate files(domain.cer/domain.key)
2. Copy the certificate files to the server
3. Make a backup of the files located in `/etc/nginx/default.d`(RHEL/CentOS) or `/etc/nginx/sites-available`(Debian/Ubuntu) with an extension other then conf
4. We have included example configuration files for SSL termination, copy the the files given in `/etc/nginx/examples/` to `/etc/nginx/sites-available`(Debian/Ubuntu) or `/etc/nginx/default.d`(RHEL/CentOS)
5. Edit the armadillo_ssl.conf file copied in step 4 and add the location of the certificate file to `ssl_certificate` and add the location of the key file to `ssl_certificate_key`
6. Repeat the process for all the *_ssl.conf files
7. After editing the files, check if the configuration file have no warnings/errors with the command: `nginx -t`
8. If there are no problems displayed, restart nginx with `systemctl restart nginx`
9. Test if the configuration is working with RStudio

### I can not connect to the server
1. Login to the server via SSH and type `nslookup <armadillo domain>`. You should get an A record back with an IP address. If not, you need to ask the IT department to let the domains(Armadillo, MinIO, MinIO console and authentication application) go to the server.
2. If you go to the armadillo domain website and you get an 503 error, you will need to check if the NginX application is running. To do that, you will need to type `systemctl status nginx` into the terminal. If you see an red dot or read "nginx has stopped" than you need to restart nginx. To do that type `systemctl restart nginx` in the terminal and press enter. If all went well you don't get anything back from the terminal. Than you try again.
3. If the application is running, check if the containers are running. Type `docker ps -a` in the terminal. If you don't see any containers or see containers with `exited` state, restart the docker compose stack. To do so, go to `/usr/share/armadillo` and type: `docker-compose down; docker-compose up -d`(Debian/Ubuntu) or `podman-compose down; podman-compose up -d`(RHEL/CentOS). Check with `docker ps -a` if everything is running correctly. And retry visiting the armadillo website.
4. If you receive in error that it isn't possible to connect to the Armadillo application within RStudio, please check if the SSL certificate has a proper chain. Go to the [ssl checker website](https://www.sslshopper.com/ssl-checker.html) and fill in the Armadillo domains. If there is a broken lock showing, you need to fix the chain. Ask your IT department to do so, or download the intermediate/root certificate and paste it underneath the certificate in the certificate file. Do this for every domain and restart nginx(`systemctl restart nginx`). Then retry checking the domains on the SSL checker website. If everything seems resolved, retry to connect in RStudio.

### It is not possible to sign into the central authentication server
We assume that you have received a mail from `molgenis-support@umcg.nl` with instructions about changes to be made in `pb_install-armadillo.yml`. Possible problems could be:
1. The parts(think of `client_id`, `client_secret`, `issuer_uri`, `api_key` or `base_url`) that you have copy and paste are not the same. This can be extra spaces, extra or missing characters/numbers/special characters
2. The `issuer_uri` is not correct in the `pb_install-armadillo.yml`. Does it need to be `lifecycle-auth.molgenis.org` instead of `auth.molgenis.org`?
