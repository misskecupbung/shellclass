#!/bin/bash
if [[ "${UID}" -ne 0 ]]
then
  echo 'Please run with sudo or as root.' >&2
  exit 1
fi

for U in carrief markh harrisonf alecg peterm
do
  useradd ${U}
  echo 'passwd123' | passwd --stdin ${U}
done
