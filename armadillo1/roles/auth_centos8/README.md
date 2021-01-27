Authentication manaher
=========


[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-auth-blue.svg)](https://galaxy.ansible.com/molgenis/armadillo1/)

Requirements
------------
This role requires Podman on the CentOS base image. Then the rserver will run out of the box.

Role Variables
--------------
| Variable            | Required | Default                              | Choices | Comments                                      |
|---------------------|----------|--------------------------------------|---------|-----------------------------------------------|
| base_url            | no       | http://localhost:4000                | na      | Authentication manager base URL               |
| image.version       | yes      | 0.2.0                                | na      | Version of the authentication manager service |
| image.repo          | no       | molgenis                             | na      | Repository of the RServer docker image        |
| image.name          | no       | armadillo-auth                       | na      | Name of the RServer docker image              |
| resources.memory    | no       | 1g                                   | na      | Maximum memory claim on the host              |
| resources.cpu       | no       | 1                                    | na      | Maximum CPU claim on the host                 |
| oauth.issuer_uri    | yes      | https://auth.local                   | na      | Maximum CPU claim on the host                 |
| oauth.client_id     | yes      | xxxx-xxxxxxx-xxxxx                   | na      | Maximum CPU claim on the host                 |  
| oauth.client_secret | yes      | xxxx-xxxxxxx-xxxxx                   | na      | Maximum CPU claim on the host                 |
| oauth.redirect_uri  | no       | http://localhost:4000/oauth-callback | na      | Maximum CPU claim on the host                 |
| oauth.api_token     | yes      | xxxx-xxxxxxx-xxxxx                   | na      | Maximum CPU claim on the host                 |


Dependencies
------------
This is dependant on the following list of roles:
- podman

Example Playbook
----------------
You can include the rserver-role by adding the yaml block below.

    - hosts: all
      roles:
       - role: rserver
         vars:
           debug: false
           image:
             version: 1.8.0
           
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org