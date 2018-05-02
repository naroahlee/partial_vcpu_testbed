#!/bin/bash

WORKING_DIR=/home/NFS_Share/DS_Exp/EXP02/
REMOTE_DIR=/mnt/NFS_Share/DS_Exp/EXP02/
SERVER_IP=192.168.1.11
CLIENT_IP=192.168.1.12
EXP_CONF=Exp.conf

cd ${WORKING_DIR}

# ================== Clean Up ================
rm -rf ./bin/*
rm -rf ./data/*
rm -rf ./figure/*
rm -rf ./dump.rdb
