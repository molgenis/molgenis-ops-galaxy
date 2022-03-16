Minio
=========
This installs the Minio file storage on your system. This allows you to store data on the federation service.

[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-service_minio-blue.svg)](https://galaxy.ansible.com/molgenis/armadillo/)

Requirements
------------
The only requirement you need a clean base image of Rocky >= 8.x, RedHat and CentOS >= 7.x, Ubuntu >= 20.x or Debian >= 10.x.

Role Variables
--------------
| Variable               | Required | Default                           | Choices  | Comments                                                                                          |
|------------------------|----------|-----------------------------------|----------|---------------------------------------------------------------------------------------------------| 
| version                | yes      | 2020-11-12T22-33-34Z              | na       | Version of the Minio service. There are monthly releases so you need to upgrade regularly         |
| data                   | yes      | /var/lib/minio/data               | na       | The path on the host system where the of the Minio file storage is stored                         |
| protocol               | yes      | http / https                      | na       | Protocol for the redirect url                                                                     |
| oauth.issuer_uri       | yes      | https://auth.example.org          | na       | The plain url of the authentication server (can be FusionAuth or Keycloack for example            |
| oauth.discovery_path   | yes      | /.well-known/openid-configuration | na       | Discovery path to extract information like the endpoints and other relevant details of the server |
| oauth.client_id        | yes      | xxxxx.xxxxxxx.xxxxxxx             | na       | The client ID of the authentication server                                                        |
| minio.root_user        | yes      | xxxxxx                            | na       | The root user to access Minio API and webinterface                                                |
| minio.root_password    | yes      | xxxxxxxxxxx                       | na       | The root password to access Minio API and webinterface                                            |
| minio.domain           | yes      | armadillo-storage.local           | na       | The domain the minio API server is running on                                                     |
| minio.port             | yes      | 9000                              | na       | The port where the minio API can be reached on                                                    |
| minio.host             | yes      | http://minio                      | na       | The host where the minio API can be reached on (within docker-compose it points to the service)   |
| minio.console.enabled  | yes      | false                             | na       | If the minio webinterface is enabled                                                              |
| minio.console.port     | yes      | 9001                              | na       | The port where the minio webinterface can be reached on                                           |
| minio.console.domain   | yes      | armadillo-storage-console.local   | na       | The domain the minio webinterface is running on                                                   |

Example Playbook
----------------
You can include the service_minio-role by adding the yaml block below.

    - hosts: all
      vars:
        minio:
          root_user: xxxxxxxx
          root_password: xxxxxxxx
          port: 9000
          domain: armadillo-storage.local
          host: http://minio
          console:
            port: 9001
            domain: armadillo-storage-console.local
            enabled: true
        oauth: 
          issuer_uri: https://auth.example.org
          discovery_path: /.well-known/openid-configuration
          client_id: xxxxxx-xxxxxxx-xxxxxxx
      roles:
       - role: minio
         vars:
           storage:
             version: 2022-01-25T19-56-04Z
             data: /var/lib/minio/data
             protocol: http
             root_user: "{{ minio.root_user }}"
             root_password: "{{ minio.root_password }}"
                   
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org