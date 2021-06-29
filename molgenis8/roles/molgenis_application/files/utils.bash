#!/bin/bash

SET_LOG_LEVEL=3
LOG_DIR=/var/log/molgenis-ops-tools

if [[ -z ${LOG_FILE} ]]
then
  LOG_FILE="stdout.log"
fi

function log() {
  LOG_LEVEL=${1}
  LOG_MESSAGE=${2}
  if [[ ! -z ${3} ]]; then
    LOG_DIR=${3}
  fi
  LOG_PREFIX="[INFO]"
  DATE_FORMAT="+%d-%m-%Y"
  TIME_FORMAT="+%T"
  DATE=$(date ${DATE_FORMAT})
  TIME=$(date ${TIME_FORMAT})
  if [[ -z ${LOG_LEVEL} ]]
  then
    LOG_LEVEL=3
  elif [[ ${LOG_LEVEL} == 1 ]]
  then
    LOG_PREFIX="[ERROR]"
  elif [[ ${LOG_LEVEL} == 2 ]]
  then
    LOG_PREFIX="[WARN]"
  elif [[ ${LOG_LEVEL} == 4 ]]
  then
    LOG_PREFIX="[DEBUG]"
  elif [[ ${LOG_LEVEL} == 5 ]]
  then
    LOG_PREFIX="[TRACE]"
  fi
  if [[ ${LOG_LEVEL} -le 3 ]]
  then
    if [[ "${EUID}" -ne 0 ]]
    then
      echo "${LOG_PREFIX} | ${DATE} ${TIME} | ${LOG_MESSAGE}" >> "${LOG_DIR}/${DATE}_${LOG_FILE}"
    else
      runuser -l molgenis -c "echo \"${LOG_PREFIX} | ${DATE} ${TIME} | ${LOG_MESSAGE}\" >> \"${LOG_DIR}/${DATE}_${LOG_FILE}\""
    fi
  fi
  if [[ ${SET_LOG_LEVEL} -ge ${LOG_LEVEL} ]]
  then
    if [[ "${EUID}" -ne 0 ]]
    then
      echo "${LOG_PREFIX} | ${DATE} ${TIME} | ${LOG_MESSAGE}"
    else
      runuser -l molgenis -c "echo \"${LOG_PREFIX} | ${DATE} ${TIME} | ${LOG_MESSAGE}\""
    fi
  fi
}
