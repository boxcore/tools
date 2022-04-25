#!/bin/bash


InstallBt76()
{
	cd /root

	wget -q http://download.bt.cn/install/update/LinuxPanel-7.6.0.zip
	unzip LinuxPanel-7.6.0.zip > /dev/null
	cd panel
	bash update.sh > /dev/null

	# 移除登录绑定
	sed -i "s|if (bind_user == 'True') {|if (bind_user == 'REMOVED') {|g" /www/server/panel/BTPanel/static/js/index.js
	mv /www/server/panel/data/bind.pl /www/server/panel/data/bind.plbak
}

InstallBt76
