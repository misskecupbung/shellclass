#!/bin/bash

LOG_FILE='/tmp/time.txt'
TIME=$(date +%T)
MESSAGE="The current time is ${TIME}."
echo "${MESSAGE}" | tee -a ${LOG_FILE}
