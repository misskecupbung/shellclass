#!/usr/bin/env bash

# Run a single command on every server listed in a file (one per line).
# Improvements: safer reading of server list, quoting, and better handling of arguments.

set -o errexit
set -o nounset
set -o pipefail

# A list of servers, one per line.
SERVER_LIST='/vagrant/servers'

# Options for the ssh command.
SSH_OPTIONS='-o ConnectTimeout=2'

usage() {
  echo "Usage: ${0} [-nsv] [-f FILE] COMMAND" >&2
  echo 'Executes COMMAND as a single command on every server.' >&2
  echo "  -f FILE  Use FILE for the list of servers. Default ${SERVER_LIST}." >&2
  echo '  -n       Dry run mode. Display the COMMAND that would have been executed and exit.' >&2
  echo '  -s       Execute the COMMAND using sudo on the remote server.' >&2
  echo '  -v       Verbose mode. Displays the server name before executing COMMAND.' >&2
  exit 1
}

# Do not execute as root
if [[ "${EUID:-${UID}}" -eq 0 ]]; then
  echo 'Do not execute this script as root. Use the -s option instead.' >&2
  usage
fi

while getopts f:nsv OPTION; do
  case ${OPTION} in
    f) SERVER_LIST="${OPTARG}" ;;
    n) DRY_RUN='true' ;;
    s) SUDO='sudo' ;;
    v) VERBOSE='true' ;;
    *) usage ;;
  esac
done

shift "$(( OPTIND -1 ))"

if [[ "$#" -lt 1 ]]; then
  usage
fi

# Treat remaining args as the command string
COMMAND="$*"

if [[ ! -r "${SERVER_LIST}" ]]; then
  echo "Cannot open server list file ${SERVER_LIST}." >&2
  exit 1
fi

EXIT_STATUS=0

# Read server list safely (handles spaces/newlines correctly)
while IFS= read -r SERVER || [[ -n "${SERVER}" ]]; do
  # Skip empty lines or comments
  [[ -z "${SERVER// }" || "${SERVER}" == \#* ]] && continue

  if [[ "${VERBOSE:-}" == 'true' ]]; then
    echo "${SERVER}"
  fi

  # Construct remote command: allow sudo if requested
  REMOTE_CMD="${SUDO:-} ${COMMAND}"

  if [[ "${DRY_RUN:-}" == 'true' ]]; then
    echo "DRY RUN: ssh ${SSH_OPTIONS} ${SERVER} \"${REMOTE_CMD}\""
  else
    if ! ssh ${SSH_OPTIONS} "${SERVER}" "${REMOTE_CMD}"; then
      SSH_EXIT_STATUS=${?}
      EXIT_STATUS=${SSH_EXIT_STATUS}
      echo "Execution on ${SERVER} failed." >&2
    fi
  fi
done < "${SERVER_LIST}"

exit ${EXIT_STATUS}
