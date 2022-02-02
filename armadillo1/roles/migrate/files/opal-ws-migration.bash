#!/bin/bash

###################################################################################
# Make sure your unzip the workspaces in /root/backup                             #
# The path should be /root/backup/DataSHIELD/[ user ]/[ server:workspace ]/.RData #
###################################################################################

SOURCE_USER=${1}
TARGET_USER=${2}
SOURCE_PATH="/root/backup/DataSHIELD/${SOURCE_USER}"
TARGET_PATH="/var/lib/minio/data/${TARGET_USER}"

if [ ! -d ${SOURCE_PATH} ]
then
  echo "--------------------------------------------------------------------------"
  echo "| No user found at: [ ${SOURCE_PATH} ]                                     "
  echo "| Make sure the workspaces are located at: [ /root/backup/DataSHIELD/* ]  "
  echo "| Program will be terminated                                              "
  echo "--------------------------------------------------------------------------"
  exit
fi

echo "----------------------------------------------------------------------------"
echo "| Migrate Opal workspaces to Armadillo for user: [ ${SOURCE_USER} ] "
echo "----------------------------------------------------------------------------"
array=(${SOURCE_PATH}/*)
for dir in "${array[@]}"
do 
  file=$(echo "${dir}" | sed 's:.*/::')
  echo "| - Move ${file}.RData to ${TARGET_PATH}/"
  mkdir -p ${TARGET_PATH}
  cp ${dir}/.RData ${TARGET_PATH}/${file}.RData
done
chown -R minio:minio ${TARGET_PATH}
echo "----------------------------------------------------------------------------"
echo "| Migration has finished for user: [ ${SOURCE_USER} ]"
echo "----------------------------------------------------------------------------"
