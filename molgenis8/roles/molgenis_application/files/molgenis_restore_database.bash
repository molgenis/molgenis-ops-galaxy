#!/bin/bash

MOLGENIS_OPS_TOOLS=/usr/local/share/molgenis/tools

. ${MOLGENIS_OPS_TOOLS}/utils.bash

RESTORE_FILE=${1}
DATABASE_SCHEME=${2}
LOG_FILE="restore_database.log"

#TODO: add usage

log 3 "################################################################################"
log 3 "Start restoring database"
log 3 "--------------------------------------------------------------------------------"
if [[ -z ${DATABASE_SCHEME} ]]; then
  log 2 "Using default database-scheme: [ molgenis ]"
  DATABASE_SCHEME=molgenis
fi

if [[ -z ${RESTORE_FILE} ]]; then
  log 1 "No restore-file is specified"
  exit 1
fi

log 3 "Restoring database"
psql ${DATABASE_SCHEME} < ${RESTORE_FILE}
log 3 "--------------------------------------------------------------------------------"
log 3 "Database is restored"
log 3 "################################################################################"
