#!/bin/bash

# This script display the PIDs and count of matching processes.

PROC_NAME="${1}"
PIDS=$(pidof ${PROC_NAME})
COUNT=$(echo "${PIDS}" | wc -w)

if [[ "${COUNT}" -gt 0 ]]
then
  echo "PROCESS NAME: ${PROC_NAME}"
  echo "COUNT: ${COUNT}"
  echo "PID(S): ${PIDS}"
else
  echo "No processes named ${PROC_NAME} found." >&2
  exit 1
fi
