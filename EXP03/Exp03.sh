#!/bin/bash

WORKING_DIR=/home/NFS_Share/DS_Exp/EXP03/
REMOTE_DIR=/mnt/NFS_Share/DS_Exp/EXP03/
SERVER_IP=192.168.1.11
CLIENT_IP=192.168.1.12
EXP_CONF=Exp.conf

TestRun=20

cd ${WORKING_DIR}

# ================== Clean Up ================
#rm -rf ./data/*

# ================== Run =====================

for((i=0;i<${TestRun}; i++))
{
	#./Run_Once.sh FP Full    ${i}
	./Run_Once.sh FP Partial ${i}
}

#paste -d, ./data/FP_Full*.csv    > ./data/FP_Full_all.csv
paste -d, ./data/FP_Partial*.csv > ./data/FP_Partial_all.csv
