Authentication manager
=========
Installs the authentication manager on the Armadillo server

[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-auth-blue.svg)](https://galaxy.ansible.com/molgenis/armadillo1/)

Requirements
------------
This role requires Podman on the Ubuntu 20.x base image. Then the rserver will run out of the box.

Role Variables
--------------
| Variable            | Required | Default                              | Choices | Comments                                                              |
|---------------------|----------|--------------------------------------|---------|-----------------------------------------------------------------------|
| base_url            | no       | http://localhost:4000                | na      | Authentication manager base URL                                       |
| image.version       | yes      | 0.2.0                                | na      | Version of the authentication manager service                         |
| image.repo          | no       | molgenis                             | na      | Repository of the RServer docker image                                |
| image.name          | no       | armadillo-auth                       | na      | Name of the RServer docker image                                      |
| resources.memory    | no       | 1g                                   | na      | Maximum memory claim on the host                                      |
| resources.cpu       | no       | 1                                    | na      | Maximum CPU claim on the host                                         |
| oauth.issuer_uri    | yes      | https://auth.local                   | na      | Location of the authentication server OIDC information                |
| oauth.client_id     | yes      | xxxx-xxxxxxx-xxxxx                   | na      | Client ID of the authentication server                                |  
| oauth.client_secret | yes      | xxxx-xxxxxxx-xxxxx                   | na      | Client secret of the authentication server                            |
| oauth.api_token     | yes      | xxxx-xxxxxxx-xxxxx                   | na      | API token that manages the application on the authentication server   |


Dependencies
------------
This is dependant on the following list of roles:
- auth_ubuntu20

Example Playbook
----------------
You can include the rserver-role by adding the yaml block below.

    - hosts: all
      roles:
       - role: auth
         vars:
           image:
             version: 0.2.0
           oauth: 
             client_id: xxxxx-xxxxx
             client_secret: xxxx-xxxxx
             issuer_uri: https://auth.local
             api_token: xxxx-xxxxx
           base_url: armadillo-auth.local
           resources:
             memory: 512m
             cpu: 1
           
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org