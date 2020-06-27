#!/bin/bash

# cloudreve 的安装

# wget 
# tar -zxvf cloudreve_VERSION_OS_ARCH.tar.gz

chmod +x ./cloudreve

mkdir -pv /root/.config/cloudreve
mv ./cloudreve /root/.config/cloudreve/
cat > /usr/lib/systemd/system/cloudreve.service <<"EOF"
[Unit]
Description=Cloudreve
Documentation=https://docs.cloudreve.org
After=network.target
Wants=network.target

[Service]
WorkingDirectory=/root/.config/cloudreve
ExecStart=/root/.config/cloudreve/cloudreve
Restart=on-abnormal
RestartSec=5s
KillMode=mixed

StandardOutput=null
StandardError=syslog

[Install]
WantedBy=multi-user.target
EOF

# 更新配置
systemctl daemon-reload

# 启动服务
systemctl start cloudreve

# 设置开机启动
systemctl enable cloudreve




