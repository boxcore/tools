#!/bin/bash

# 安装python3
InstallPython3()
{
    
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