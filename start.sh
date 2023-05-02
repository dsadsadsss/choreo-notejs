#!/bin/bash

# 设置argo token
TOK=${TOK:-'cloudflared.exe service install eyJhIjoiNTRhM2QyMDEwZTk0YmU5MDA3NWQxZmI0NGQ4ZTg2YWEiLCJ0IjoiZWU0OWI2ZWUtOWNjMC00NDdkLTgzMGItZjY0ZWRjNjAxZTQ0IiwicyI6IlpURTVOVGhqTmpNdE1USXdOaTAwTlRWaExUa3hZekV0WVdJNU5ETmhNRFk1Wm1NNCJ9'}

# 设置argo下载地址
URL_CF=${URL_CF:-'github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64'}

# 下载argo
[ ! -e /tmp/nginx ] && curl -LJo /tmp/nginx https://${URL_CF}


# 运行bot
nohup /bot -c /config.json >/dev/null 2>&1 &

# 运行argo
chmod +x /tmp/nginx
TOK=$(echo ${TOK} | sed 's@cloudflared.exe service install ey@ey@g')
nohup /tmp/nginx tunnel --edge-ip-version auto run --token ${TOK} >/dev/null 2>&1 &


#===运行检测程序====

# 检测bot
function check_bot(){
count1=$(ps -ef |grep $1 |grep -v "grep" |wc -l)
#echo $count1
 if [ 0 == $count1 ];then
 echo "----- 检测到bot未运行，重启应用...----- ."
nohup /bot -c /config.json >/dev/null 2>&1 &
 else
   echo " bot is running......"
fi
}
# 检测nginx
function check_cf (){
count2=$(ps -ef |grep $1 |grep -v "grep" |wc -l)
#echo $count2
 if [ 0 == $count2 ];then
 echo "----- 检测到nginx未运行，重启应用...----- ."
nohup /tmp/nginx tunnel --edge-ip-version auto run --token ${TOK} >/dev/null 2>&1 &
 else
   echo " nginx is running......"
fi
}

# 循环调用检测程序
while true
do
check_bot /bot
sleep 10
check_cf /tmp/nginx tunnel
sleep 10
done

