#!/bin/bash

WORKING_DIR=/home/NFS_Share/DS_Exp/EXP05/
REMOTE_DIR=/mnt/NFS_Share/DS_Exp/EXP05/
SERVER_IP=192.168.1.11
CLIENT_IP=192.168.1.12
EXP_CONF=Exp.conf
SRV_HOST=ubuntu01

cd ${WORKING_DIR}

Sched=$1
Type=$2

echo ${Sched} ${Type}

# ================ Set Resource Interface ============
if [ "Full" == "${Type}" ]; then
	Period=10000
	Budget=10000
	echo "[EXP01]: [Full    VCPU] P[${Period}] B[${Budget}]"
	./bin/myRIclient.py ${SRV_HOST} ${Budget} ${Period} 0

elif [ "Partial" == "${Type}" ]; then
	Period=`./bin/getRI.py ${EXP_CONF} | head -n 2 | tail -n 1`
	Budget=`./bin/getRI.py ${EXP_CONF} | head -n 3 | tail -n 1`
	echo "[EXP01]: [Partial VCPU] P[${Period}] B[${Budget}]"
	./bin/myRIclient.py ${SRV_HOST} ${Budget} ${Period} 0

else
	echo "[EXP01]: [VCPU Type Error]"
	exit -1
fi


Durms=`head -n 2 ${EXP_CONF} | tail -n 1`
Dur=`echo "${Durms} / 1000000 + 5" | bc`


# ====================== SERVER ======================
echo "[EXP01]: Start Server [${Sched}]"
ssh root@${SERVER_IP} "cd ${REMOTE_DIR}; ./bin/synthetic_server ${Sched} > /dev/null &"

echo "[EXP01]: Start Client"
# ====================== CLIENT ======================
ssh root@${CLIENT_IP} "cd ${REMOTE_DIR}; ./bin/multi_sporadic ./Exp.conf > /dev/null &"


# ====================== RUN Exp =====================
echo "============================"
echo "[EXP01]: Waiting ${Dur}s ..."
echo "============================"

sleep ${Dur}

# =================== KILL SERVER ====================
ServerPid=`ssh root@${SERVER_IP} "ps aux | grep synthetic_server | grep -v grep" | awk '{print $2}'`
ssh root@${SERVER_IP} "kill -2 ${ServerPid}"
echo "[EXP01]: Kill PID[${ServerPid}] @ ${SERVER_IP}"

# ====================================================
# ====================================================
# ==================Post Processing ==================
# ====================================================
# ====================================================

# =================== Collect Data ===================
SortedFile=data/all_sort_${Sched}_${Type}.tracing
cat ./*.tracing > all.tracing
./bin/trace_filter all.tracing -r -o all_sort.tracing > /dev/null
mv all_sort.tracing ${SortedFile}

# =================== Collect Response Sample ========
./bin/stat_pre ${SortedFile}
cat ./*.csv > all_sample.csv
mv all_sample.csv data/all_sample_${Sched}_${Type}.csv

# ================== Draw Figure =====================
./bin/draw_figure ${SortedFile} draw.asy > /dev/null
asy draw.asy
mv draw.eps figure/${Sched}_${Type}.eps

# ================== Clean Template File =============
rm -rf ./*.tracing ./*.asy ./*.eps ./*.csv
