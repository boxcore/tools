#!/bin/bash
# 路由回程检测
# From: https://github.com/wn789/VPS-/blob/master/autoBestTrace.sh

# apt -y install unzip

# Todo 未完成
# install besttrace
if [ ! -f "besttrace" ]; then
    # wget https://github.com/wn789/VPS-/raw/master/besttrace
    wget https://cdn.ipip.net/17mon/besttrace4linux.zip
    unzip besttrace4linux.zip  -d besttrace/
    # unzip besttrace4linux.zip
    chmod +x besttrace/besttrace
fi

## start to use besttrace

next() {
    printf "%-70s\n" "-" | sed 's/\s/-/g'
}

clear
next

ip_list=(220.181.22.1 220.201.8.6 221.130.33.1 60.176.0.1 60.12.17.1 211.140.0.2 58.42.224.1 58.16.28.1 211.139.0.10 14.215.116.1 58.250.0.1 211.139.145.34 101.95.120.109 211.95.72.254 183.192.160.3 202.112.14.151)
ip_addr=(北京电信 辽宁联通 北京移动 杭州电信 宁波联通 杭州移动 贵阳电信 贵阳联通 贵阳移动 广州电信 深圳联通 广州移动 上海电信 上海联通 上海移动 成都教育网)
# ip_len=${#ip_list[@]}

for i in {0..15}
do
	echo ${ip_addr[$i]}
	./besttrace -q 1 ${ip_list[$i]}
	next
done