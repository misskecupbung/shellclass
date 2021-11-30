#!/bin/bash

# Display the UID and username of the user executing this script.
# Display if the user is the root user or not.

# Display the UID
echo "Your ID is ${UID}"

# Display the username
USER_NAME=$(id -un)
USER_NAME1=$(whoami)
USER_NAME2=`id -un`
echo "Your username is ${USER_NAME}"
echo "Your username is ${USER_NAME1}"
echo "Your username is ${USER_NAME2}"

# Display if the user is the root user or not.
if [[ ${UID} -eq 0 ]]
then
  echo "You are root"
else
  echo "You are not root"
fi
