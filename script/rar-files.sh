#!/bin/bash #----------------------------------- 
#批量解压带密码的rar到文件名相同目录 #----------------------------------- 
pwd='' for i in *.rar do #解压密码 
dname=$(echo $i|sed 's/.rar//') mkdir ./$dname #目录名称 
if [ -d "$dname" ] then echo -e "创建目录 $dname 成功\n" >> ur.log #判断是否成功创建目录 
/usr/bin/unrar x -p$pwd $i ./$dname #解压操作 
if [ $? -eq 0 ] then echo -e "解压 $i 成功\n" >> ur.log else echo -e "解压 $i 失败\n" >> ur.log fi else echo -e "创建目录 $dnmae 失败\n" >> ur.log fi done #判断是否解压成功 