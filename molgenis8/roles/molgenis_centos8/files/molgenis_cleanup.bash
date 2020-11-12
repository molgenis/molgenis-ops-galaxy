#!/bin/bash

# This bash script will do the following:
# - Drop your elastic search index folder
# - Drop and recreate all the tables inside the molgenis schema
# - Remove the molgenis.version number from the molgenis-server.properties file
MOLGENIS_OPS_TOOLS=/usr/local/share/molgenis/tools/

MOLGENIS_HOME="/usr/local/share/molgenis/"

BASE_DIR=$(pwd)
LOG_FILE="cleanup.log"

. ${MOLGENIS_OPS_TOOLS}/utils.bash

log 3 "################################################################################"
log 3 "Start cleanup of database and elasticsearch index"
log 3 "--------------------------------------------------------------------------------"
log 3 "Check if tomcat is running"
if [[ $(sudo service tomcat status) = *"running"* ]]; then
  sudo service tomcat stop
fi

log 3 "Deleting all Elasticsearch indices"
curl -X DELETE "http://localhost:9200/_all"

log 3 "Dropping molgenis schema tables and triggers"
if [[ $(whoami) = "root"* ]]; then
  RUN_PSQL="sudo -i -u postgres psql -U postgres -q"
else
  RUN_PSQL="psql -U postgres -q"
fi

${RUN_PSQL} <<SQL
DROP DATABASE molgenis;
CREATE DATABASE molgenis OWNER = molgenis;
SQL

log 3 "Removing molgenis.version number from properties file..."
sed --in-place '/molgenis.version/d' ${MOLGENIS_HOME}/molgenis-server.properties

if [[ -d ${MOLGENIS_HOME}/data/filestore ]]
then
  log 3 "Remove all files in ${MOLGENIS_HOME}/data/filestore"
  rm -rf ${MOLGENIS_HOME}/data/filestore/*

elif [[ -d ${MOLGENIS_HOME}/data/filestore ]]
then
  log 3 "Remove all files in ${MOLGENIS_HOME}/data/filestore"
  rm -rf ${MOLGENIS_HOME}/data/filestore/*

else
  log 1 "No filestore detected, please contact your administrator"
  exit 1
fi

log 3 "--------------------------------------------------------------------------------"
log 3 "Cleanup is done"
log 3 "################################################################################"
