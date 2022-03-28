#!/bin/sh

# stop tomcat
systemctl stop tomcat

# run cleanup
/usr/local/share/molgenis/tools/molgenis_cleanup.bash > /dev/null 2>&1
rm -rf /usr/local/share/molgenis/data

# load data in molgenis database
su - molgenis -c "/usr/bin/psql -d molgenis -f /tmp/postgresql.sql > /tmp/restore_out.txt 2>&1"

# create filestore and chmod
cd /usr/local/share/molgenis
tar -xvzf /tmp/filestore_backup.tgz
chown -R tomcat:molgenis ./data
 
# start tomcat
systemctl start tomcat

# cleanup /tmp
rm -f /tmp/postgresql.sql
rm -f /tmp/filestore_backup.tgz
