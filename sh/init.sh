#!/bin/bash

cd /root
cur_dir=$(pwd)
bit=`uname -m`

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script"
    exit 1
fi

Color_Text()
{
  echo -e " \e[0;$2m$1\e[0m"
}

Echo_Red()
{
  echo $(Color_Text "$1" "31")
}

Echo_Green()
{
  echo $(Color_Text "$1" "32")
}

Echo_Yellow()
{
  echo $(Color_Text "$1" "33")
}

Echo_Blue()
{
  echo $(Color_Text "$1" "34")
}

InstallZsh()
{
    # echo $SHELL
    # return 1
    if [ "${PM}" == "yum" ] || [ "${PM}" == "dnf" ] ; then
        Pack="zsh"
        
        ${PM} install ${Pack} -y
    elif [ "${PM}" == "apt-get" ]; then
        Pack="zsh"
        ${PM} install ${Pack} -y
    fi

    chsh -s /bin/zsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

}

InstallBt()
{
    # bt实验性py3安装： curl -sSO http://download.bt.cn/install/install_panel.sh && bash install_panel.sh
    if [ "${PM}" == "yum" ] || [ "${PM}" == "dnf" ] ; then
        # Pack="zsh"
        # ${PM} install ${Pack} -y
        wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh
    elif [ "${PM}" == "apt-get" ]; then
        # Pack="zsh"
        # ${PM} install ${Pack} -y
        wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh
    fi
}

InstallZip()
{
    # install zip
    if [ "${PM}" == "yum" ] || [ "${PM}" == "dnf" ] ; then
        Pack="p7zip unzip"
        
        ${PM} install ${Pack} -y
    elif [ "${PM}" == "apt-get" ]; then
        Pack="p7zip unzip"
        ${PM} install ${Pack} -y
    fi
}

InstallDev()
{
    # install zip
    if [ "${PM}" == "yum" ] || [ "${PM}" == "dnf" ] ; then
        Pack="screen"
        
        ${PM} install ${Pack} -y
    elif [ "${PM}" == "apt-get" ]; then
        Pack="screen"
        ${PM} install ${Pack} -y
    fi
}


# install init
if [ "${PM}" == "yum" ] || [ "${PM}" == "dnf" ] ; then
    Pack="git wget epel-release"
    
    ${PM} install ${Pack} -y
elif [ "${PM}" == "apt-get" ]; then
    Pack="git wget"
    ${PM} install ${Pack} -y
fi

InstallZip

InstallZsh