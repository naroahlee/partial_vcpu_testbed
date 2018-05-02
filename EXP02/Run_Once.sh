#!/bin/bash

# EXP02

WORKING_DIR=/home/NFS_Share/DS_Exp/EXP02/
REMOTE_DIR=/mnt/NFS_Share/DS_Exp/EXP02/
SERVER_IP=192.168.1.11
CLIENT_IP=192.168.1.12
EXP_CONF=Exp.conf
SRV_HOST=ubuntu01

cd ${WORKING_DIR}

Type=$1


# ================ Set Resource Interface ============
if [ "Full" == "${Type}" ]; then
	Period=10000
	Budget=10000
	echo "[EXP02]: [Full    VCPU] P[${Period}] B[${Budget}]"
	./bin/myRIclient.py ${SRV_HOST} ${Budget} ${Period} 0

elif [ "Partial" == "${Type}" ]; then
	Period=`./bin/getRI.py ${EXP_CONF} | head -n 2 | tail -n 1`
	Budget=`./bin/getRI.py ${EXP_CONF} | head -n 3 | tail -n 1`
	echo "[EXP02]: [Partial VCPU] P[${Period}] B[${Budget}]"
	./bin/myRIclient.py ${SRV_HOST} ${Budget} ${Period} 0

else
	echo "[EXP02]: [VCPU Type Error]"
	exit -1
fi


Durms=`head -n 2 ${EXP_CONF} | tail -n 1`
Dur=`echo "${Durms} / 1000 + 5" | bc`


# ====================== SERVER ======================
ssh root@${SERVER_IP} "cd ${REMOTE_DIR}; redis-server ./redis.conf > /dev/null &"

ServerPid=`ssh root@${SERVER_IP} "ps aux | grep redis-server | grep -v grep" | awk '{print $2}'`
echo "[EXP02]: Start Server @ ${SERVER_IP} PID[${ServerPid}]"

# ====================== CLIENT ======================
echo "[EXP02]: Start Client"
ssh root@${CLIENT_IP} "cd ${REMOTE_DIR}; ./bin/redis_periodic_clients ./Exp.conf > /dev/null &"


# ====================== RUN Exp =====================
echo "============================"
echo "[EXP02]: Waiting ${Dur}s ..."
echo "============================"

sleep ${Dur}

# =================== KILL SERVER ====================
ssh root@${SERVER_IP} "kill -2 ${ServerPid}"
echo "[EXP02]: Kill PID[${ServerPid}] @ ${SERVER_IP}"
#
# ====================================================
# ====================================================
# ==================Post Processing ==================
# ====================================================
# ====================================================

# =================== Collect Data ===================
SortedFile=data/all_sort_${Type}.tracing
cat ./*.tracing > all.tracing
./bin/trace_filter all.tracing -r -o all_sort.tracing > /dev/null
mv all_sort.tracing ${SortedFile}

# =================== Collect Response Sample ========
./bin/stat_pre ${SortedFile}
cat ./*.csv > all_sample.csv
mv all_sample.csv data/all_sample_${Type}.csv

# ================== Clean Template File =============
rm -rf ./*.tracing ./*.asy ./*.eps ./*.csv
