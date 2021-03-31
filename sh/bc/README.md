# Block Chain


## 一、部署swarm 测试网络代码

- api： https://rpc.slock.it/goerli

### 1.1 说明
- 需要提前配置telegram bot信息，如果不会请先google一下
    - 获取你的tg chat ip: https://api.telegram.org/bot{$token}/getUpdates
    - 推荐使用vultr服务器
    - 脚本中centos7+、debian 10、ubuntu 20中测试通过，其它版本问题请issue反馈
### 1.2 自动安装swarm 测试网络
> 以下提供一些测试用的bot api, 线上项目请提前替换为自己的，请勿滥用。。。

部署脚本，ssh登陆你的linux服务器即可
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

如果只需要安装定时checkout脚本，执行以下命令即可： 

```bash
cd ~
BEE_PATH="/root/bee"
[ ! -d "${BEE_PATH}" ] && mkdir ${BEE_PATH}

# 这部分按需要添加
cat > ${BEE_PATH}/xswarm.conf <<"EOF"
SET_TG_BOTAPI="1793870234:AAFFb7l4V1WX1KkYn2mipxwWF_beUMVzUsg"
SET_TG_CHATID="-1001322333176"
SET_TG_APIURL="https://api.telegram.org/bot"
SET_USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36"
EOF
    source ${BEE_PATH}/xswarm.conf

cd /root/bee && wget -O cronBee.sh https://raw.githubusercontent.com/boxcore/tools/master/sh/bc/cronBee.sh
```
然后自己按需求添加crontab定时任务即可：
> * */2 * * * bash /root/bee/cronBee.sh > /dev/null 2>&1

需要推送key和password到tg，执行以下命令即可


```bash
[ ! -d "/root/bee" ] && mkdir /root/bee
cat > /root/bee/xswarm.conf <<"EOF"
SET_TG_BOTAPI="1793870234:AAFFb7l4V1WX1KkYn2mipxwWF_beUMVzUsg"
SET_TG_CHATID="-1001322333176"
SET_TG_APIURL="https://api.telegram.org/bot"
SET_USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36"
EOF
source /root/bee/xswarm.conf
cd /root/bee && wget -O postBeeKey.sh https://raw.githubusercontent.com/boxcore/tools/master/sh/bc/postBeeKey.sh && bash postBeeKey.sh
```