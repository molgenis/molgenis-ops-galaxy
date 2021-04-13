#!/bin/bash

# This bash script will do the following:
# - Drop and recreate all the tables inside the molgenis schema
MOLGENIS_OPS_TOOLS=/usr/local/share/molgenis/tools/

MOLGENIS_HOME="/usr/local/share/molgenis/"

BASE_DIR=$(pwd)
LOG_FILE="cleanup.log"

. ${MOLGENIS_OPS_TOOLS}/utils.bash

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

log 3 "--------------------------------------------------------------------------------"
log 3 "Cleanup is done"
log 3 "################################################################################"
