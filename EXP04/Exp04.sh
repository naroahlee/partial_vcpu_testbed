#!/bin/bash

WORKING_DIR=/home/NFS_Share/DS_Exp/EXP04/
REMOTE_DIR=/mnt/NFS_Share/DS_Exp/EXP04/
SERVER_IP=192.168.1.11
CLIENT_IP=192.168.1.12
EXP_CONF=Exp.conf

Util=9
TestCase=20
TestRun=20
SCHED=FP

CONF_DIR=./data/conf
FINAL_DIR=./data/final

cd ${WORKING_DIR}

# ================== Clean Up ================
rm -rf ./data/*
mkdir -p ${FINAL_DIR}
mkdir -p ${CONF_DIR}

# ================== Run =====================

for ((u=1; u<=${Util}; u=u+2))
{
	mkdir -p ${FINAL_DIR}/U${u}
	mkdir -p ${CONF_DIR}/U${u}
	for((t=0; t<${TestCase}; t++))
	{
		./bin/gen_testcase.py 0.${u} > ${CONF_DIR}/U${u}/T${t}.conf
		cp ${CONF_DIR}/U${u}/T${t}.conf ./Exp.conf

		for((i=0; i<${TestRun}; i++))
		{
			echo "**************** Util = 0.${u} Testcase[${t}] *****************"
			./Run_Once.sh ${SCHED} Full    ${i}
			./Run_Once.sh ${SCHED} Partial ${i}
		}

		Fnumber=`printf "%02d" "${t}"`

		paste -d, ./data/${SCHED}_Full*.csv    > ${FINAL_DIR}/U${u}/${SCHED}_F_${Fnumber}.csv
		paste -d, ./data/${SCHED}_Partial*.csv > ${FINAL_DIR}/U${u}/${SCHED}_P_${Fnumber}.csv

		rm -rf ./data/*.csv
		rm -rf ./data/*.tracing
	}
}



