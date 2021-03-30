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


sendTgCheckoutInfo()
{
    t=`date '+%Y-%m-%d %H:%M:%S'`
    msg="✅*【服务器「${PARAM_HOST_IP}」bee checkout成功，数量：${cashed_count}】*
·_IP信息_ ：${PARAM_HOST_IP} （${PARAM_HOST_COUNTRY}，${PARAM_HOST_PROVINCE}，${PARAM_HOST_CITY}）
·_时间_：${t}
·_服务器名_：${SET_HOSTNAME}
·_eth地址_：${eth_addr}
#通知  #checkout #${eth_addr} #${SET_HOSTNAME}"

curl -s -X POST "${SET_TG_APIURL}${SET_TG_BOTAPI}/sendMessage" -d "chat_id=${SET_TG_CHATID}&parse_mode=markdown&text=${msg}" > /dev/null 2>&1
}


cd ~

[ ! -f "/root/bee/cashout.sh" ] && echo "You don't cashout.sh.. Quit" && exit 1

# 检查bee服务是否运行中，如果未运行将启动
while [ 1 ]
do
    run=`ps -ef|grep "bee start"|grep -v grep|wc -l`
    if [ $run -lt 1 ]
    then
        echo "need to run"
        systemctl restart bee
        sleep 2

    else
        echo "already run"
        break
    fi
done

# TODO：添加磁盘监控代码


# 执行cashout 脚本
# 检查是否有未同步的支票
eth_addr=$(curl -s http://localhost:1635/addresses | jq -r .ethereum)
export eth_addr
uncashed_count=`bash /root/bee/cashout.sh list-uncashed | wc -l`
if [ $uncashed_count -gt 0 ]; then
    cashed_count=`bash /root/bee/cashout.sh cashout-all|wc -l`;
    export cashed_count
    echo "cashout num: ${cashed_count}"
    [ ! -z ${SET_TG_BOTAPI} ] && sendTgCheckoutInfo
else
    echo "not uncashout num, jump."
fi
