#!/bin/bash

# This script demonstrates the continue and break commands.
USERS="jason vagrant ellen"

echo "continue example:"

for USER in ${USERS}
do
  # Check to see if the user already exists.
  id ${USER} &>/dev/null

  if [[ "${?}" -eq 0 ]]
  then
    echo "${USER} exists."
    continue
  fi

  echo "Creating ${USER} account"
done

echo
echo "break example:"

for USER in ${USERS}
do
  echo "Testing ${USER}"

  # Check to see if the user exists.
  id ${USER} &>/dev/null

  if [[ "${?}" -eq 0 ]]
  then
    echo "${USER} exists."
    break
  fi

done

# We're all done.
exit 0
