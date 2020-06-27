#!/bin/bash

# google drive share api
# 参考文章：https://tech.he-sb.top/posts/usage-of-gclone/


# 安装autoclone获取google授权
yum install -y python3 python3-pip git  # 安装系统依赖
python3 -m pip install --upgrade pip
git clone https://github.com/xyou365/AutoRclone  # 拉取 AutoRclone 项目
cd AutoRclone  # 进入项目文件夹
pip3 install -r requirements.txt  # 安装项目依赖

# 手动配置权限api
# 访问：https://developers.google.com/drive/api/v3/quickstart/python
# 点击【Step 1: Turn on the Drive API】下面的 Enable the Drive API 按钮，弹出的【Configure your OAuth client】对话框中保持默认的 Desktop app 不要动，点击右下角 CREATE 按钮，开启成功之后点击 DOWNLOAD CLIENT CONFIGURATION 下载生成的 credentials.json ，再将下载到本地的 credentials.json 上传至服务器的 AutoRclone 文件夹下

python3 gen_sa_accounts.py --list-projects # 查询项目列表，会有授权页面，另外，里面有提醒的api链接提醒需要点击去授权
gen_sa_accounts.py --create-projects 1 # 如果没有项目，需要在这里先创建项目

python3 gen_sa_accounts.py --enable-services quickstart-1590040896592 # 这里的 quickstart-1590040896592 是 app项目的名称。执行python3 gen_sa_accounts.py --list-projects 会看到
python3 gen_sa_accounts.py --create-sas quickstart-1590040896592 #为项目生成 SA
python3 gen_sa_accounts.py --download-keys quickstart-1590040896592 #下载项目中 SA 的授权文件，稍等片刻 ~/AutoRclone/accounts/ 目录下应该出现了一大堆 .json 后缀的 SA 授权文件。

# 添加Google群，然后添加成员邮箱，添加后，添加 cnnasedu@googlegroups.com


# 安装gclone
bash <(wget -qO- https://git.io/gclone.sh)
gclone --version
cat > ~/.config/rclone/rclone.conf<<EOF
[gc]
type = drive
scope = drive
service_account_file = /root/AutoRclone/accounts/fe0b13c188d47aeb1ff6ae52f12390a1d3e53015.json 
service_account_file_path = /root/AutoRclone/accounts/
EOF

# gclone基本操作
## 共享目录和团队盘应该带 --drive-server-side-across-configs：
gclone copy gc:{【源盘】ID} gc:{【目的盘】ID}  --drive-server-side-across-configs
#目录 ID 可以是：普通目录，共享目录，团队盘；也支持目录 ID 后跟后续路径：
gclone copy gc:{【源盘】ID} gc:{【目的盘】ID}/media/  --drive-server-side-across-configs

