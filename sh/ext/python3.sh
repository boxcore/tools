#!/bin/bash

# 安装python3
InstallPython3()
{
    cd ~
    wget -O 'Python-3.9.4.tgz' https://www.python.org/ftp/python/3.9.4/Python-3.9.4.tgz
    tar -zxvf Python-3.9.4.tgz
    cd ~/Python-3.9.4
    # ./configure --prefix=/usr/local/python3.9 --enable-optimizations # --enable-optimizations 需要gc11，不推荐
    ./configure
    make
    make Install

}

# 安装pip3
InstallPip3()
{
    cd ~
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py
}

# 设置pip源
SetPipMirror()
{

}