Nginx
=========
This installs the NGINX webserver to proxy the file storage, the armadillo and the authentication manager.

[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-nginx-blue.svg)](https://galaxy.ansible.com/molgenis/armadillo1/)

Requirements
------------
The nginx-role is based upon a clean CentOS >= 7.x image or Redhat 8.x iamge. It's dependencies are described below.

Role Variables
--------------
| Variable          | Required | Default                 | Choices | Comments                                           |
|-------------------|----------|-------------------------|---------|----------------------------------------------------|
| domains.armadillo | yes      | armadillo.local         | na      | Domain on which the Armadillo is served            |
| domains.storage   | yes      | armadillo-storage.local | na      | Port on which the storage service is served        |
| domains.auth      | yes      | armadillo-minio.local   | na      | Port on which the authentication manager is served |

Dependencies
------------
This is dependant on the following list of roles:
- minio
- armadillo
- rserver

Example Playbook
----------------
You can include the armadillo-role by adding the yaml block below.

    - hosts: all
      roles:
       - role: nginx_redhat_family
         vars:
           domains: 
             armadillo: armadillo.local
             storage: armadillo-storage.local
             auth: armadillo-auth.local
           
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org