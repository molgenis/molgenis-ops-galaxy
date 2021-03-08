Armadillo
=========
This installs the Armadillo service on your system. It installs Java and creates a systemd service wrapper around the application.

[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-armadillo-blue.svg)](https://galaxy.ansible.com/molgenis/armadillo1/)

Requirements
------------
The armadillo-role is based upon a clean CentOS 8.x, Ubuntu 20.x or Debian 10.x image. It's dependencies are described below.

Role Variables
--------------
| Variable              | Required | Default                           | Choices  | Comments                                                                                  |
|-----------------------|----------|-----------------------------------|----------|-------------------------------------------------------------------------------------------|
| storage.version       | yes      | 2020-11-12T22-33-34Z              | na       | Version of the Minio service. There are monthly releases so you need to upgrade regularly |
| storage.access_key    | yes      | xxxxxx-xxxxxxx-xxxxxxx            | na       | The access key to access Minio API and webinterface                                       |
| storage.secret_key    | yes      | xxxxxx-xxxxxxx-xxxxxxx            | na       | The secret key to access Minio API and webinterface                                       |
| storage.data          | yes      | /var/lib/minio/data               | na       | The path on the host system where the of the Minio file storage is stored                 |
| armadillo.version     | yes      | 0.0.15                            | na       | Version of the Armadillo service. Newer versions can be found on the MOLGENIS registry.   |
| oauth.issuer_uri      | yes      | https://auth.example.org          | na       | The plain url of the authentication server (can be FusionAuth or Keycloack for example    |
| oauth.client_id       | yes      | xxxxx.xxxxxxx.xxxxxxx             | na       | The client ID of the authentication server                                                |
| memory.xmx            | yes      | 1024mb                            | na       | Maximum of memory claimed by the Armadillo                                                |
| memory.xms            | yes      | 512mb                             | na       | Reserved memory claimed by the Armadillo                                                |
| username              | yes      | admin                             | na       | Root username of the application (using basic-auth)                                              |
| password              | yes      | admin                             | na       | Root password of the application (using basic-auth)                                              |

Dependencies
------------
This is dependant on the following list of roles:
- minio_#os#
- nginx_#os#
- rserver_#os#
- java_#os#

Example Playbook
----------------
You can include the armadillo-role by adding the yaml block below.

    - hosts: all
      vars:
        oauth: 
          issuer_uri: https://auth.example.org
          client_id: xxxxxx-xxxxxxx-xxxxxxx
      roles:
       - role: armadillo
         vars:
           version: 0.0.15
             storage:
               access_key: "{{ minio.access_key }}"
               secret_key: "{{ minio.secret_key }}"
               host: "{{ minio.host }}"
               port: "{{ minio.port }}"
             memory:
               xmx: 1024m
               xms: 512m
            username: admin
            password: admin
            
           
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org