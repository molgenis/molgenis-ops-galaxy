RServe
=========
Installs the RServe environments which does the actual analysis. 

[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-service_rserve-blue.svg)](https://galaxy.ansible.com/molgenis/armadillo/)

Requirements
------------
This role requires Podman on the Rocky >= 8.x, RedHat and CentOS >= 7.x, Ubuntu >= 20 or Debian >= 10 base image. Then the rserver will run out of the box.

(Generic) Role Variables
--------------
| Variable                               | Required | Default           | Choices  | Comments                                          |
|----------------------------------------|----------|-------------------|----------|---------------------------------------------------|
| rserve.environment[0].name             | yes      | default           | na       | Name of the environment                           |
| rserve.environment[0].debug            | no       | false             | na       | Determines wether the RServe runs in debug-mode.  |
| rserve.environment[0].host             | yes      | localhost         | na       | Host where this RServe is available.             |
| rserve.environment[0].exposed_port     | yes      | 6311              | na       | Port where this RServe is exposed.                |
| rserve.environment[0].image.version    | yes      | 2.0.0             | na       | Version of the RServe service.                    |
| rserve.environment[0].image.repo       | no       | datashield        | na       | Repository of the RServe docker image             |
| rserve.environment[0].image.name       | no       | armadillo-rserver | na       | Name of the RServe docker image                   |
| rserve.environment[0].resources.memory | no       | 6g                | na       | Maximum memory claim on the host                  |
| rserve.environment[0].resources.cpu    | no       | 2                 | na       | Maximum CPU claim on the host                     |

Example Playbook
----------------
You can include the service_rserve-role by adding the yaml block below.

    - hosts: all
      rserve:
        environments:
          - name: default
            host: localhost
            debug: false
            image:
              version: 2.0.0
              repo: datashield
              name: armadillo-rserver
            exposed_port: 6311
      roles:
       - role: rserver
             
           
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org
