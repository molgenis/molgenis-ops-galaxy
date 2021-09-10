Java
=========
This installs the Java JDK environment on your system. This allows you to tun applications like MOLGENIS and the Armadillo.

[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-java-blue.svg)](https://galaxy.ansible.com/molgenis/molgenis8/)

Requirements
------------
The only requirement you need a clean base image of Rocky >= 8.x, RedHat and CentOS >= 7.x, Debian >= 10, Ubuntu => 20.

Role Variables
--------------
| Variable              | Required | Default                           | Choices  | Comments                 |
|-----------------------|----------|-----------------------------------|----------|--------------------------| 
| version               | yes      | 2020-11-12T22-33-34Z              | na       | Version of the Java JDK. |

Dependencies
------------

Example Playbook
----------------
You can include the minio-role by adding the yaml block below.

    - hosts: all
      roles:
       - role: java
         vars:
           version: 11
                   
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org