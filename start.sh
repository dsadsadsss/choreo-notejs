#!/usr/bin/env bash
#Argo 的 Token 或者 json 值，其中 json 可以通过以下网站，在不需绑卡的情况下轻松获取: https://fscarmen.cloudflare.now.cc/
TOK=${TOK:-'cloudflared.exe service install eyJhIjoiNTRhM2QyMDEwZTk0YmU5MDA3NWQxZmI0NGQ4ZTg2YWEiLCJ0IjoiY2EyMWM3OGMtNGZhNS00MmVjLWJlYzEtMjU4MTEzMDBhMTI5IiwicyI6IllqZGpOelZrWTJVdFlUSmhZUzAwTWpVNExUZzRNemd0WmpJNE5tSmxNek0zTVRRMiJ9'}
TOK=$(echo ${TOK} | sed 's@cloudflared.exe service install ey@ey@g')
#哪吒2个参数
NEZHA_SERVER=${NEZHA_SERVER:-'data.xuexi365.eu.org'}
NEZHA_KEY=${NEZHA_KEY:-'lV7QkNChGQoV0Z2xDQ'}
#客户端URL
URL_NEZHA=${URL_NEZHA:-'github.com/naiba/nezha/releases/latest/download/nezha-agent_linux_amd64.zip'}
URL_CF=${URL_CF:-'github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64'}
URL_BOT=${URL_BOT:-'xxqg.rr.nu/shuang-c2-argo-warp2-1.75_upx'}
#其他默认参数，无需更改
PORT=${PORT:-'80'}
NEZHA_PORT=${NEZHA_PORT:-'443'}
NEZHA_TLS=${NEZHA_TLS:-'1'}
TLS=${NEZHA_TLS:+'--tls'}
#以上是全部参数设置，下面为程序处理部分

if [[ -n "${NEZHA_SERVER}" && -n "${NEZHA_KEY}" ]]; then
[ ! -e /tmp/nezha-agent ] && curl -LJo /tmp/nezha-agent_linux_amd64.zip https://${URL_NEZHA}
cd /tmp/ && unzip -o /tmp/nezha-agent_linux_amd64.zip
rm -f /tmp/nezha-agent_linux_amd64.zip
chmod +x /tmp/nezha-agent
nohup /tmp/nezha-agent -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY} ${TLS}  >/dev/null 2>&1 &
  cat > /tmp/chatdog.sh << EOF
#!/usr/bin/env bash
function check_bot(){
count1=\$(ps -ef |grep \$1 |grep -v "grep" |wc -l)
#echo \$count1
 if [ 0 == \$count1 ];then
 echo "----- 检测到bot未运行，重启应用...----- ."
 nohup /tmp/bot >/dev/null 2>&1 &

fi
}

function check_cf (){
count2=\$(ps -ef |grep \$1 |grep -v "grep" |wc -l)
#echo \$count2
 if [ 0 == \$count2 ];then
 echo "----- 检测到cf未运行，重启应用...----- ."
 nohup /tmp/cf tunnel --edge-ip-version auto run --token ${TOK} >/dev/null 2>&1 &

fi
}
 
function check_nezha (){
count3=\$(ps -ef |grep \$1 |grep -v "grep" |wc -l)
#echo \$count3
 if [ 0 == \$count3 ];then
 echo "----- 检测到nezha未运行，重启应用...----- ."
 nohup /tmp/nezha-agent -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY} ${TLS} >/dev/null 2>&1 &

fi
}
function check_nginx (){
count4=\$(ps -ef |grep \$1 |grep -v "grep" |wc -l)
#echo \$count4
 if [ 0 == \$count4 ];then
 echo "----- 检测到nginx未运行，重启应用...----- ."
nohup /usr/sbin/nginx -g 'daemon off;' >/dev/null 2>&1 &

fi
}
check_bot /tmp/bot
sleep 10
check_cf /tmp/cf tunnel --edge-ip-version auto run --token
sleep 10
check_nezha /tmp/nezha-agent -s ${NEZHA_SERVER}:${NEZHA_PORT}
sleep 10

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

}

function check_nginx (){
count4=\$(ps -ef |grep \$1 |grep -v "grep" |wc -l)
#echo \$count4
 if [ 0 == \$count4 ];then
 echo "----- 检测到nginx未运行，重启应用...----- ."
nohup /usr/sbin/nginx -g 'daemon off;' >/dev/null 2>&1 &

fi
}
check_bot /tmp/bot

sleep 10
check_cf /tmp/cf tunnel --edge-ip-version auto run --token
sleep 10

EOF

fi
chmod +x /tmp/chatdog.sh


echo "----- 系统信息...----- ."
cat /proc/version
echo "----- enjoy it (^o^).----- ."
[ ! -e /tmp/cf ] && curl -LJo /tmp/cf https://${URL_CF}
chmod +x /tmp/cf
[[ "${TOK}" =~ TunnelSecret ]] && echo "${TOK}" | sed 's@{@{"@g;s@[,:]@"\0"@g;s@}@"}@g' > /tmp/tunnel.json && echo -e "tunnel: $(sed "s@.*TunnelID:\(.*\)}@\1@g" <<< "{TOK}")\ncredentials-file: /tmp/tunnel.json" > /tmp/tunnel.yml && nohup /tmp/cf tunnel --edge-ip-version auto --config /tmp/tunnel.yml --url http://localhost:8001 >/dev/null 2>&1 &
[[ ${TOK} =~ ^[A-Z0-9a-z=]{120,250}$ ]] && nohup /tmp/cf tunnel --edge-ip-version auto run --token ${TOK} >/dev/null 2>&1 &
[ ! -e /tmp/bot ] && curl -LJo /tmp/bot https://${URL_BOT}
chmod +x /tmp/bot
nohup /tmp/bot >/dev/null 2>&1 &

echo "----- 系统进程...----- ."
ps -ef | sed 's@--token.*@--token ${TOK}@g;s@-s data.*@-s ${NEZHA_SERVER}@g'
nohup /tmp/chatdog.sh
