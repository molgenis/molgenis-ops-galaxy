Nginx
=========
This installs the NGINX webserver to proxy the file storage, the armadillo and the authentication manager.

[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-nginx-blue.svg)](https://galaxy.ansible.com/molgenis/armadillo1/)

Requirements
------------
The nginx-role is based upon a clean CentOS 8.x image. It's dependencies are described below.

Role Variables
--------------
| Variable        | Required | Default         | Choices  | Comments                                           |
|-----------------|----------|-----------------|----------|----------------------------------------------------|
| host            | yes      | armadillo.local | na       | Domain on which the services are exposed           |
| ports.armadillo | yes      | 8080            | na       | Port on which the Armadillo service is served      |
| ports.storage   | yes      | 9000            | na       | Port on which the file storage is served           |
| ports.auth      | yes      | 4000            | na       | Port on which the authentication manager is served |                 

Dependencies
------------
This is dependant on the following list of roles:
- minio
- httpd
- rserver

Example Playbook
----------------
You can include the armadillo-role by adding the yaml block below.

    - hosts: all
      roles:
       - role: nginx
         vars:
           host: armadillo.local
           ports:
             minio: 9000
             auth: 4000
             armadillo: 8080
           
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org