# MOLGENIS Galaxy suite
We support galaxy collections for several services that the MOLGENIS suite provide. 

## Usage
we ahve several services deployed at the moment. The detail instructions to deploy the services are on galaxy:
- [MOLGENIS](https://galaxy.ansible.com/molgenis/molgenis8)
- [Armadillo](https://galaxy.ansible.com/molgenis/armadillo1)

## Development
When you want to contribute on the galaxy collections please be aware of the following contribution guide lines.

### Naming convention
Each playbook needs to adhere to the following name convention:
<letter>_<optional_version_restrictions>_<explanary_name>.yml

The first part is a single letter that indicates the playbooks use:
- e stands for extra add-on playbook that extends the default image with non default features (like extra domain names and corresponding SSL certificates)
- i stands for initial install playbook that sets up a working MOLGENIS server from a empty CENTOS 6 image
- s stands for single task playbook
- r stands for report playbook
- v stands for validation playbook that does not change a thing, it only reports on the state of a VM image and give no output unless something is wrong

The next part is the optional MOLGENIS branch restriction. A "2_6" indicates that it is only to be used with the 26 setup that includes the MOLGENIS 8 version branch. A "1_6" indicates that it is only to be used on a MOLGENIS 7 branch.
If no branch restriction is included in the playbook name, it should be usable on all MOLGENIS VM images.
(The 0_6 branch of old VM machines are excluded to be targets by Ansible scripts, as their setup are not standardised, and running a playbook could easily damage them. The validation and report playbooks that never make changes might be save to use, but probably also do not work as expected on every 0_6 branch VM image server.)

The inventory is divided in host_groups. The host_group name has the following convention.
<name>-<team>-<tap>-<Versioncode><OScode>-<extra>
where the name could be molgenis for a molgenis machine, and cont for a container host, and molgeniscont for a molgenis machine with extra containers for extra functionality.
team should always be ops for now, as I dont envision other teams to use our ansible repo
tap is the env indicator and either "prod", "acc", or "test"
the Versioncode indicated the Molgenis version, 2 stand for the 8.x.y versions, 1 stand for the 7.w.v versions, and 0 for earlier versions and non molgenis software, the molgenis 9 major realease will get code 3.
The OScode indicated the major Centos/RHEL release the host has, so 6 stand for Centos6, 7 stands for Centos7 and 8 stands for Centos8.
We append this with an optional extra string, that could be Based if the server run some special extras either a special WAR or some extra stuff that

### Best practices
- Please enforce [idempotancy](https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html)
- A playbook should give no output if "ok"
- Use [ansible-lint](https://ansible-lint.readthedocs.io/en/latest) to check the styling
- Create valid playbooks for all major components of the software stack


