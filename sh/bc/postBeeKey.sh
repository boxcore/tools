#!/bin/bash

if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script"
    exit 1
fi

BEE_PATH="/root/bee"
[ ! -d "${BEE_PATH}" ] && echo "bee path donnt exist, quit" && exit 1

if [ -f ${BEE_PATH}/xswarm.conf ]; then
    source ${BEE_PATH}/xswarm.conf
else
    # 无配置文件时读取默认值
    SET_TG_APIURL="https://api.telegram.org/bot"
    SET_USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36"

    export SET_USER_AGENT
    export SET_TG_APIURL

fi

[ -z ${SET_HOSTNAME} ] && SET_HOSTNAME=`hostname`
export SET_HOSTNAME

# 获取和跟新IP设置
GenIpJSON()
{
    ipinfo_json=`curl --connect-timeout 5 -s -H "User-Agent: ${PARAM_USER_AGENT}" "https://api.myip.la/cn?json"`
    ipinfo_file="${BEE_PATH}/ipinfo.json"
    cat > ${ipinfo_file} <<EOF
${ipinfo_json}
EOF
}
GetIP()
{
    ipinfo_file="${BEE_PATH}/ipinfo.json"
    [ ! -f ${ipinfo_file} ] && GenIpJSON
    ipinfo_timestamp=`stat -c %Y $ipinfo_file`
    
    cur_timestamp=`date +%s`
    timediff=$[$cur_timestamp - $ipinfo_timestamp]
    if [ $timediff -gt 604800 ];then
        echo '当前时间大于一周'
        GenIpJSON
    else
        echo '当前时间小于一周'
    fi

    PARAM_HOST_IP=`cat ${ipinfo_file} |jq -r '.ip'`
    PARAM_HOST_COUNTRY=`cat ${ipinfo_file} |jq -r '.location.country_code'`
    PARAM_HOST_CITY=`cat ${ipinfo_file} |jq -r '.location.city'`
    PARAM_HOST_PROVINCE=`cat ${ipinfo_file} |jq -r '.location.province'`
    export PARAM_HOST_IP
    export PARAM_HOST_COUNTRY
    export PARAM_HOST_CITY
    export PARAM_HOST_PROVINCE
}
GetIP

sendTgFile()
{
    eth_addr=$(curl -s http://localhost:1635/addresses | jq -r .ethereum)
    
    if ls /var/lib/bee-clef/keystore/UTC-* > /dev/null 2>&1; then
        file_json=`ls /var/lib/bee-clef/keystore/UTC-*| awk 'NR==1'`
        file_password=$(cat /var/lib/bee-clef/password)
        echo "ok"
        file_rs=$(curl -s -F "chat_id=${SET_TG_CHATID}" -F document=@${file_json} -F "caption=【服务器「${PARAM_HOST_IP}」bee key info】 File: key.json Password: ${file_password} #文件 #${eth_addr} #${SET_HOSTNAME} #${PARAM_HOST_IP}" ${SET_TG_APIURL}${SET_TG_BOTAPI}/sendDocument|jq -r ".ok")


        if [ "${file_rs}" == 'true' ]; then 
            echo "send json file ok"
        else
            echo "send json file failure"
        fi
        
    else
        echo "don't have key file !"
    fi
}


[ ! -z ${SET_TG_BOTAPI} ] && sendTgFile || echo "[error]Not set tg api!"