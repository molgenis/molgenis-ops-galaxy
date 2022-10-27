# Upgrading
Here we talk about the upgrading of the Armadillo suite and the updating of the other parts of the system.

### Upgrading the Operating System(OS)
To keep the system up to date you will need to patch and/or update the system. This upgrading is <ins>NOT</ins> part of the Armadillo suite. It is the task of the owner of the server or the IT department to keep the system up to date and apply security patches. When an application of the Armadillo suite is fulnerable then we going to make sure that there will be a patch made and distributed to the systems involved.

### Upgrading the containers
The upgrading of the containers happens automatically. There is an CRON setup that restarts the containers. If there are containers that have the version labeled `latest`, `1` or `2` they can be upgraded. This CRON is scheduled to run every sunday at 0:01 hour. 

When we are publishing an new version of an image we will tag them two times. We tag the image with the full version like `2.0.1` and we tag them as version `2`. We do this so that the Armadillo suite get's the new version automatically by the CRON we have enabled. When the image get's updatete and you miss an R package for example, let us know(`molgenis-support@umcg.nl`) that we can fix the problem. Should the software in the image be needed directly we can manually set the image version to the old version.

### Upgrade from Opal to Armadillo
There is an written guide how you can make the switch from the Opal suite to the Armadillo suite. [This guide can be found here](./roles/tools_migrate/README.md)