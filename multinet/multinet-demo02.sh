#!/bin/bash

# This script installs the apache web server.

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
  echo 'Please run with sudo or as root.' >&2
  exit 1
fi

# Install apache.
yum install -y httpd

# Put an index.html file into place.
echo 'Hello World' > /var/www/html/index.html

# Start apache
systemctl start httpd

# Make sure apache starts on boot.
systemctl enable httpd

# We're all done!
exit 0
