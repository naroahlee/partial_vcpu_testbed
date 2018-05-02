#!/bin/bash

WORKING_DIR=/home/NFS_Share/DS_Exp/EXP04/
REMOTE_DIR=/mnt/NFS_Share/DS_Exp/EXP04/
SERVER_IP=192.168.1.11
CLIENT_IP=192.168.1.12
EXP_CONF=Exp.conf
SRV_HOST=ubuntu01

cd ${WORKING_DIR}

Sched=$1
Type=$2
Number=`printf "%02d" "$3"`
echo "======================="
echo "[EXP04]: Run[${Number}]"
echo "======================="

# ================ Set Resource Interface ============
if [ "Full" == "${Type}" ]; then
	Period=10000
	Budget=10000
	echo "[EXP04]: [Full    VCPU] P[${Period}] B[${Budget}]"
	./bin/myRIclient.py ${SRV_HOST} ${Budget} ${Period} 0

elif [ "Partial" == "${Type}" ]; then
	Period=`./bin/getRI.py ${EXP_CONF} | head -n 2 | tail -n 1`
	Budget=`./bin/getRI.py ${EXP_CONF} | head -n 3 | tail -n 1`
	echo "[EXP04]: [Partial VCPU] P[${Period}] B[${Budget}]"
	./bin/myRIclient.py ${SRV_HOST} ${Budget} ${Period} 0

else
	echo "[EXP04]: [VCPU Type Error]"
	exit -1
fi


Durms=`head -n 2 ${EXP_CONF} | tail -n 1`
Dur=`echo "${Durms} / 1000000 + 5" | bc`


# ====================== SERVER ======================
echo "[EXP04]: Start Server [${Sched}]"
ssh root@${SERVER_IP} "cd ${REMOTE_DIR}; ./bin/synthetic_server ${Sched} > /dev/null &"

echo "[EXP04]: Start Client"
# ====================== CLIENT ======================
ssh root@${CLIENT_IP} "cd ${REMOTE_DIR}; ./bin/multi_process ./Exp.conf > /dev/null &"


# ====================== RUN Exp =====================
echo "[EXP04]: Waiting ${Dur}s ..."

sleep ${Dur}

# =================== KILL SERVER ====================
ServerPid=`ssh root@${SERVER_IP} "ps aux | grep synthetic_server | grep -v grep" | awk '{print $2}'`
ssh root@${SERVER_IP} "kill -2 ${ServerPid}"
#echo "[EXP04]: Kill PID[${ServerPid}] @ ${SERVER_IP}"

# ====================================================
# ====================================================
# ==================Post Processing ==================
# ====================================================
# ====================================================

# =================== Collect Data ===================
SortedFile=data/${Sched}_${Type}_${Number}.tracing

cat ./*.tracing > all.tracing
./bin/trace_filter all.tracing -r -o all_sort.tracing > /dev/null
mv all_sort.tracing ${SortedFile}

# =================== Collect Response Sample ========
CSVFile=data/${Sched}_${Type}_${Number}.csv
./bin/stat_pre ${SortedFile}
cat *.csv > ${CSVFile}

# ================== Clean Template File =============
rm -rf ./*.tracing ./*.asy ./*.eps ./*.csv
