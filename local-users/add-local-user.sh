#!/usr/bin/env bash

# Create a new local user (Linux-focused).
# Prompts for username, comment, and password. Performs basic validation and
# prefers `chpasswd` to set the password when available.

set -o errexit
set -o nounset
set -o pipefail

# Must be root
if [[ "${EUID:-${UID}}" -ne 0 ]]; then
  echo 'Please run with sudo or as root' >&2
  exit 1
fi

read -r -p 'Enter the username to create: ' USER_NAME
if [[ -z "${USER_NAME// }" ]]; then
  echo 'Username cannot be empty.' >&2
  exit 1
fi

read -r -p 'Enter the real name for the account (comment): ' COMMENT
read -r -p 'Enter the password to use for the account: ' PASSWORD

# Don't overwrite existing users
if id -u "${USER_NAME}" >/dev/null 2>&1; then
  echo "User '${USER_NAME}' already exists." >&2
  exit 1
fi

# Create the account
useradd -c "${COMMENT}" -m "${USER_NAME}"

# Verify creation
if [[ $? -ne 0 ]]; then
  echo 'The account could not be created.' >&2
  exit 1
fi

# Set the password using chpasswd if available, fall back to passwd --stdin
if command -v chpasswd >/dev/null 2>&1; then
  printf '%s:%s\n' "${USER_NAME}" "${PASSWORD}" | chpasswd
else
  if passwd --help >/dev/null 2>&1; then
    echo "${PASSWORD}" | passwd --stdin "${USER_NAME}" || {
      echo 'The password for the account could not be set.' >&2
      exit 1
    }
  else
    echo 'No supported method found to set the password on this system.' >&2
    exit 1
  fi
fi

# Force password change on first login when supported
if command -v passwd >/dev/null 2>&1; then
  passwd -e "${USER_NAME}" || true
fi

echo
echo 'Created user:'
echo "${USER_NAME}"
echo
echo 'host:'
echo "${HOSTNAME:-$(hostname)}"

echo
echo 'Note: password was set non-interactively. Avoid passing cleartext passwords in scripts when possible.'
