#!/bin/bash

WORKING_DIR=/home/NFS_Share/DS_Exp/EXP05/
REMOTE_DIR=/mnt/NFS_Share/DS_Exp/EXP05/
SERVER_IP=192.168.1.11
CLIENT_IP=192.168.1.12
EXP_CONF=Exp.conf

cd ${WORKING_DIR}

# ================== Clean Up ================
rm -rf ./data/*
rm -rf ./figure/*

./bin/gen_sporadic_conf ${EXP_CONF}

# ================== Run =====================
./Run_Once.sh FIFO Full
./Run_Once.sh FIFO Partial
./Run_Once.sh FP Full
./Run_Once.sh FP Partial

# ================== Draw CDF ================
./bin/exp01_cmp_cdf.py FIFO
./bin/exp01_cmp_cdf.py FP
