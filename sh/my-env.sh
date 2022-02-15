#!/bin/bash

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


# fix error: Failed to set locale, defaulting to C 
SetLC()
{
    if ! `cat /etc/profile |grep "^export LC_ALL" > /dev/null 2>&1`; then
        echo "export LC_ALL=en_US.UTF-8" >> /etc/profile
        . /etc/profile
    else
        echo "already set LC_ALL"
    fi

    if [ ! -f /etc/environment ]; then
        echo "LC_ALL=en_US.UTF-8" > /etc/environment
        echo "LANG=en_US.UTF-8" >> /etc/environment
    fi
}

# todo
CheckHostname()
{
    
}

# todo
SetHostname()
{
    read -p "Set Hostname(  ):" website

    n=`hostname`
    l=`echo $n|awk '{print length($0)}'`
    if ! `echo $n|grep test  > /dev/null 2>&1`; then
        if [ ${l} -gt 6 ]; then

        fi
    else
        hostnamectl 
    fi
}

InstallInit()
{
    if [ "${PM}" == "yum" ] || [ "${PM}" == "dnf" ] ; then
        ${PM} install wget curl -y

        ${PM} install screen -y
    elif [ "${PM}" == "apt-get" ]; then
        ${PM} install wget curl -y
    fi
}


# install bt
InstallBt()
{
    cd ~
    if [ "${PM}" == "yum" ] || [ "${PM}" == "dnf" ] ; then
        wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh
    elif [ "${PM}" == "apt-get" ]; then
        wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh
    fi
}


