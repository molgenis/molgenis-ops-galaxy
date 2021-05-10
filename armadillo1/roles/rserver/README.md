RServer
=========
Installs the RServer which does the actual analysis. 

[![Ansible Galaxy](https://img.shields.io/badge/ansible-galaxy-rserver-blue.svg)](https://galaxy.ansible.com/molgenis/armadillo1/)

Requirements
------------
This role requires Podman on the CentOS or RedHat >= 7.x, Ubuntu >= 20 or Debian >= 10 base image. Then the rserver will run out of the box.

Role Variables
--------------
| Variable                | Required | Default  | Choices  | Comments                                          |
|-------------------------|----------|----------|----------|---------------------------------------------------|
| debug                   | no       | false    | na       | Determines wether the RServer runs in debug-mode. |
| image.version           | yes      | 0.0.15   | na       | Version of the RServer service.                   |
| image.repo              | no       | molgenis | na       | Repository of the RServer docker image            |
| image.name              | no       | rserver  | na       | Name of the RServer docker image                  |
| resources.memory        | no       | 6g       | na       | Maximum memory claim on the host                  |
| resources.cpu           | no       | 2        | na       | Maximum CPU claim on the host                     |

Dependencies
------------
This is dependant on the following list of roles:
- rserver_centos8

Example Playbook
----------------
You can include the rserver-role by adding the yaml block below.

    - hosts: all
      roles:
       - role: rserver_centos8
         vars:
           debug: false
           image:
             version: 1.9.0
             repo: rserver
             
           
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org