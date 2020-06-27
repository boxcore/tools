#!/bin/bash

cd ~
git clone https://gitee.com/xocode/CTList.git
mkdir /opt/CTList && cd $_

cp -rfp ~/CTList/exec/amd64/linux/CTList /opt/CTList/
cp -rfp ~/CTList/config.json /opt/CTList/
cp -rfp ~/CTList/index.html /opt/CTList/
chmod +x /opt/CTList/CTList 

cat > /opt/CTList/config.json <<"EOF"
[
  {
    "Enable": 1,
    "UserName": "18026399332",
    "Password": "abc.654321",
    "CaptchaMode": "0",
    "ViewMode": 0,
    "RefreshToken": "",
    "SubPath": "/",
    "RootPathId": "-11",
    "HideItemId": "0",
    "AuthItemId": "",
    "RefreshURL": 198,
    "RefreshInterval": 1800
  }
]
EOF

cp -rfp /opt/CTList /opt/CTList2
cat > /opt/CTList2/config.json <<"EOF"
[
  {
    "Enable": 1,
    "UserName": "15800202100",
    "Password": "abc.bbc.189",
    "CaptchaMode": "0",
    "ViewMode": 0,
    "RefreshToken": "",
    "SubPath": "/",
    "RootPathId": "-11",
    "HideItemId": "0",
    "AuthItemId": "",
    "RefreshURL": 198,
    "RefreshInterval": 1800
  }
]
EOF

firewall-cmd --zone=public --add-port=8189/tcp --permanent
firewall-cmd --zone=public --add-port=8190/tcp --permanent
firewall-cmd --reload

# /opt/CTList/CTList -a "5f377b945a1c032343479447692e1a11" -bind 0.0.0.0 -port 8189 #180-dx

#设置你的运行监听端口，即你可以通过ip:端口访问程序，这里默认8000。
port="8189"
#设置你的授权码，自行修改
AUTH_TOKEN="5f377b945a1c032343479447692e1a11"
#将以下代码一起复制到SSH运行
cat > /etc/systemd/system/ctlist.service <<EOF
[Unit]
Description=ctlist
After=network.target

[Service]
Type=simple
ExecStart=/opt/CTList/CTList -a ${AUTH_TOKEN} -bind 0.0.0.0 -port ${port} -l
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
#启动并设置开机自启
systemctl start ctlist
systemctl enable ctlist
systemctl restart ctlist


# /opt/CTList2/CTList -a "f7d2b50d74eff1c95981f1af8208ba83" -bind 0.0.0.0 -port 8190 -c /opt/CTList2/config.json #150-yd
#设置你的运行监听端口，即你可以通过ip:端口访问程序，这里默认8000。
port="8190"
#设置你的授权码，自行修改
AUTH_TOKEN="f7d2b50d74eff1c95981f1af8208ba83"
#将以下代码一起复制到SSH运行
cat > /etc/systemd/system/ctlist2.service <<EOF
[Unit]
Description=ctlist2
After=network.target

[Service]
Type=simple
ExecStart=/opt/CTList2/CTList -a ${AUTH_TOKEN} -bind 0.0.0.0 -port ${port} -l
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
#启动并设置开机自启
systemctl start ctlist2
systemctl enable ctlist2
systemctl restart ctlist2
systemctl status ctlist2
# systemctl stop ctlist2
# systemctl stop ctlist


