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


InstallInit()
{
    if [ "${PM}" == "yum" ] || [ "${PM}" == "dnf" ] ; then
        ${PM} install wget curl -y

        ${PM} install screen -y
    elif [ "${PM}" == "apt-get" ]; then
        ${PM} install wget curl -y
    fi
}

InstallJava

