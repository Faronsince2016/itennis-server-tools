#!/bin/bash
source_functions()
{
    . config/itennis.conf
}

source_functions
loglevel=0 #debug:0; info:1; warn:2; error:3
logfile=${LOGDIR}/itennis.log
mkdir -p ${LOGDIR} &> /dev/null
function log {
    local msg
    local logtype
    logtype=$1
    msg=$2
    datetime=`date +'%F %H:%M:%S'`
    #使用内置变量$LINENO不行，不能显示调用那一行行号
    logformat0="[${logtype}]\t${datetime} \033[30m${msg}\033[0m (script:`basename $0` function:${FUNCNAME[@]/log/} line:`caller 0 | awk '{print$1}'`)"
    logformat1="[${logtype}]\t${datetime} \033[32m${msg}\033[0m (script:`basename $0` function:${FUNCNAME[@]/log/} line:`caller 0 | awk '{print$1}'`)"
    logformat2="[${logtype}]\t${datetime} \033[33m${msg}\033[0m (script:`basename $0` function:${FUNCNAME[@]/log/} line:`caller 0 | awk '{print$1}'`)"
    logformat3="[${logtype}]\t${datetime} ${msg} (script:`basename $0` function:${FUNCNAME[@]/log/} line:`caller 0 | awk '{print$1}'`)"
    #funname格式为log error main,如何取中间的error字段，去掉log好办，再去掉main,用echo awk? ${FUNCNAME[0]}不能满足多层函数嵌套
    {
    case $logtype in
        DEBUG)
            [[ $loglevel -le 0 ]] && echo -e "${logformat0}" ;;
        INFO)
            [[ $loglevel -le 1 ]] && echo -e "${logformat1}" ;;
        WARN)
            [[ $loglevel -le 2 ]] && echo -e "${logformat2}" ;;
        ERROR)
            [[ $loglevel -le 3 ]] && echo -e "\033[31m${logformat3}\033[0m" ;;
    esac
    } |tee -a $logfile
}
