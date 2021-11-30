#!/bin/bash

# Display the UID and username of the user executing this script.
# Display if the user is the vagrant user or not.

# Display the UID.
echo "Your UID is ${UID}"

# Only display if the UID does not match 1000.
UID_FOR_TEST="1000"
if [[ "${UID}" -ne "${UID_FOR_TEST}" ]]
then
  echo "Your ID is not ${UID_FOR_TEST}"
  exit 1
fi

# Display the username.
USER_NAME=$(id -un)

# Test if the command is succeded.
if [[ "${?}" -ne 0 ]]
then
  echo 'Then id command did not executed sucessfully.'
  exit 1
fi

echo "Your username is ${USER_NAME}"

# You can use a string test conditional.
USER_NAME_TO_TEST_FOR="vagrant"

if [[ "${USER_NAME}" = "${USER_NAME_TO_TEST_FOR}" ]]
then
  echo "Your username matches ${USER_NAME_TO_TEST_FOR}"
fi

# Test for != (not equal) for the string.
if [[ "${USER_NAME}" != "${USER_NAME_TO_TEST_FOR}" ]]
then
  echo "Your username does not match ${USER_NAME_TO_TEST_FOR}"
  exit 1
fi


exit 0
