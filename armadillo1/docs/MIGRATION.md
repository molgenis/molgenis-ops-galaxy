
# Migration guide
All migration actions that need to be done are described here.

## Opal 
### Migrating workspaces
We have created a role to migrate all Opal workspace to the Armadillo.

* Step 1: Compress the `/var/lin/opal/data/DataSHIELD` directory to `workspaces.zip`
* Step 2: Copy the `workspaces.zip` to the armadillo server in `/root/backup`
* Step 3: Unzip the `workspaces.zip` in `/root/backup/`
* Step 4: Now check the user directories in `/root/backup/DataSHIELD/`
* > Optional Step 4.1: Move directories with spaces in the directory names to directory names without spaces
* Step 5: Email molgenis-support@umcg.nl to figure out the usernames in the authentication server. This should be something like this: `user-213719dsjka-dalshdq390283-sdnalkdnsa`
* Step 6: Create the migration playbook (`pb_migrate-workspaces.yml`): 
  ```yaml
  ---
  - hosts: all # needs to be: 'localhost' if local connection is set
  become: true
  # connection: local 
  become_user: root
  gather_facts: true

  roles:
    - role: molgenis.armadillo.migrate
      vars:
        users:
          # - { source_user: sido_directory, target_user: user-298371298312 }
          # - { source_user: tim_directory, target_user: user-987348932734 }
  ```
* Step 6: Put the usermapping in the `users` variable. 
* Step 7: Run the `pb_migrate-workspaces.yml`

## Migrate from Armadillo 1.x to Armadillo 2.x
We have prepared a migration guide for upgrading to Armadillo 2.x.

* Step 1. Create the `cleanup.yml` playbook
  ```yaml
    ---
    - hosts: all # needs to be: 'localhost' if local connection is set
    become: true
    # connection: local 
    become_user: root
    gather_facts: true

    roles:
        - role: molgenis.armadillo.cleanup_version_1
        vars:
            packages:
            - armadillo
            - armadillo-auth
            - minio
            - rserver
            dependencies:
            java:
                version: 11  
  ```
* Step 2. Run the `cleanup.yml` playbook
* Step 3. Update your original `playbook.yml`
  ```yaml
  vars:
    ...
    minio:
      root_user: xxxxx
      root_password: xxxxx
      ...
    ...
    rserve:
      environments:
        - name: default
          enabled: true
          debug: false
          image:
            version: latest
            repo: datashield
            name: armadillo-rserver

  roles:
    - role: molgenis.armadillo.deps_podman
      vars:
        redhat:
          subscription:
            enabled: true
            username: xxxxxxx
            password: xxxxxxx
    ...
    - role: molgenis.armadillo.deps_docker
    - role: molgenis.armadillo.deps_compose
    - role: molgenis.armadillo.service_armadillo
      vars:
        version: 2.0.0
        ...
        storage: 
          root_user: "{{ minio.root_user }}"
          root_password: "{{ minio.root_password }}"
        ...
        datashield:
          profiles:
            - name: "{{ rserve.environments[0].name }}"
              enabled: "{{ rserve.environments[0].enabled }}"
              environment: "{{ rserve.environments[0].name }}"
              whitelist:
                - dsBase
    - role: molgenis.armadillo.service_minio
      vars:
        ...
        root_user: "{{ minio.root_user }}"
        root_password: "{{ minio.root_password }}"
        ...
    - role: molgenis.armadillo.service_auth
    - role: molgenis.armadillo.service_rserve
    - role: molgenis.armadillo.post_nginx
    - role: molgenis.armadillo.post_upgrade
  ```
* Step 4. Rerun the original `playbook.yml`