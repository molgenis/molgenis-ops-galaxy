# Upgrading
Here we talk about the upgrading of the Armadillo suite and the updating of the other parts of the system.

### Upgrading the Operating System(OS)
To keep the system up to date you will need to patch and/or update the system. This upgrading is <ins>NOT</ins> part of the Armadillo suite. It is the task of the owner of the server or the IT department to keep the system up to date and apply security patches. When an application of the Armadillo suite is fulnerable then we going to make sure that there will be a patch made and distributed to the systems involved.

### Upgrading the containers
The upgrading of the containers happens automatically. There is an CRON setup that restarts the containers. If there are containers that have the version labeled `latest`, `1` or `2` they can be upgraded. This CRON is scheduled to run every sunday at 0:01 hour. 

