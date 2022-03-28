Preinstall
=========
Prepares the CentOS image with the base RPM's needed to configure the system correctly. Besided that configures the NTP, version locking and SELinux.


Requirements
------------
This role is not dependant on other roles other than the base image CentOS.

Role Variables
--------------
| Variable   | Required | Default  | Choices  | Comments                                                         |
|------------|----------|----------|----------|------------------------------------------------------------------|
| ci         | false    | false    | na       | Determines if the role is running in continuous integration mode |

Example Playbook
----------------
You can include the rserver-role by adding the yaml block below.

    - hosts: all
      roles:
       - role: preinstall
         vars:
           ci: false
             
License
-------
See LICENSE.md

Author Information
------------------
Sido Haakma (s.haakma@rug.nl)
https://molgenis.org