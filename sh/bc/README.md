# Block Chain


## 部署swarm 测试网络代码

获取你的tg chat ip: https://api.telegram.org/bot{$token}/getUpdates

以下提供一些测试用的bot api, 请勿滥用。。。
```bash
cd ~
BEE_PATH="/root/bee"
[ ! -d "${BEE_PATH}" ] && mkdir ${BEE_PATH}
cat > ${BEE_PATH}/xswarm.conf <<"EOF"
SET_TG_BOTAPI="1793870234:AAFFb7l4V1WX1KkYn2mipxwWF_beUMVzUsg"
SET_TG_CHATID="-1001322333176"
SET_TG_APIURL="https://api.telegram.org/bot"
SET_USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36"
EOF
    source ${BEE_PATH}/xswarm.conf

cd ~ && wget -O installBee.sh https://raw.githubusercontent.com/boxcore/tools/master/sh/bc/installBee.sh && bash installBee.sh && rm -f ~/installBee.sh
```