#!/usr/bin/env bash
TOK=${TOK:-'eyJhIjoiNTRhM2QyMDEwZTk0YmU5MDA3NWQxZmI0NGQ4ZTg2YWEiLCJ0IjoiY2EyMWM3OGMtNGZhNS00MmVjLWJlYzEtMjU4MTEzMDBhMTI5IiwicyI6IllqZGpOelZrWTJVdFlUSmhZUzAwTWpVNExUZzRNemd0WmpJNE5tSmxNek0zTVRRMiJ9'}
NEZHA_SERVER=${NEZHA_SERVER:-'data.xuexi365.eu.org'}
NEZHA_KEY=${NEZHA_KEY:-'j8VewBJKPTLctcrZNp'}
PORT=${PORT:-'80'}
NEZHA_PORT=${NEZHA_PORT:-'443'}
NEZHA_TLS=${NEZHA_TLS:-'1'}
TLS=${NEZHA_TLS:+'--tls'}
#cp -rf /sr/nginx.conf /etc/nginx/nginx.conf
#nohup /usr/sbin/nginx -g 'daemon off;' >/dev/null 2>&1 &
if [[ -n "${NEZHA_SERVER}" && -n "${NEZHA_KEY}" ]]; then
curl -LJo /tmp/nezha-agent_linux_amd64.zip https://github.com/naiba/nezha/releases/latest/download/nezha-agent_linux_amd64.zip
cd /tmp/ && unzip -o /tmp/nezha-agent_linux_amd64.zip
rm -f /tmp/nezha-agent_linux_amd64.zip
chmod +x /tmp/nezha-agent
nohup /tmp/nezha-agent -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY} ${TLS}  >/dev/null 2>&1 &
  cat > /tmp/chatdog.sh << EOF
#!/usr/bin/env bash
curl "https://2cb41388-d80d-4321-8178-d51384f1fa9e-prod.e1-us-east-azure.choreoapis.dev/jozv/chatdog/1.0.0/s300" -H 'API-Key: eyJraWQiOiJnYXRld2F5X2NlcnRpZmljYXRlX2FsaWFzIiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJjOTA1NGUyNC02OGY5LTQyNTgtYjZhYS1kMTdhOTQ0NDcwOWFAY2FyYm9uLnN1cGVyIiwiaXNzIjoiaHR0cHM6XC9cL3N0cy5jaG9yZW8uZGV2OjQ0M1wvb2F1dGgyXC90b2tlbiIsImtleXR5cGUiOiJQUk9EVUNUSU9OIiwic3Vic2NyaWJlZEFQSXMiOlt7InN1YnNjcmliZXJUZW5hbnREb21haW4iOm51bGwsIm5hbWUiOiJjaGF0ZG9nIiwiY29udGV4dCI6IlwvMmNiNDEzODgtZDgwZC00MzIxLTgxNzgtZDUxMzg0ZjFmYTllXC9qb3p2XC9jaGF0ZG9nXC8xLjAuMCIsInB1Ymxpc2hlciI6ImNob3Jlb19wcm9kX2FwaW1fYWRtaW4iLCJ2ZXJzaW9uIjoiMS4wLjAiLCJzdWJzY3JpcHRpb25UaWVyIjpudWxsfV0sImV4cCI6MTY4MjgzMjQyNywidG9rZW5fdHlwZSI6IkludGVybmFsS2V5IiwiaWF0IjoxNjgyODMxODI3LCJqdGkiOiIxN2I1ZmM4Ni02YzkxLTQ0M2MtOGM0Mi04MTE3NWIwZDIwMTkifQ.UFK6Shrn35IMhH8lblDUeDbV8ylymNq43I5ta_KDvKySUt3yBCOr8bD4wdjAMFXQGbOa6dG9jCHrWItL3zPnnYEP9Y-VCQVPtw_asOOFLbizjNRYmQeVUYvoZ6ITBrtQRGZ3FNJBHCgS6AH8pyogRkzx_BE3eaS6sOB5k0TUD5JLMsMFX1zrzYDWYhwoOtW_ZYRmGuuxaFcR3xkvx1NzD3ZoGFwJDt7Q7b0rGE-nxfs7d53_oN3hzYyhjfhqUqSda4MVGKadZTG0I0lff6YB_LkFieg4153lVDdSd8diqAI8wNT7RebbAFg6zeZT2e7wAd-ebiasUV9V7FXq7bunkJCWwfHAAlRWVjONtNv-x95u9NKrHrjpb6YsnnvEOQIcvBRA4d9JWkJgC1-9OLpxrmPc7FoHoz8Z2zgJG4Uz9Z6yw5--xS6UCBKtHhNhOcPuT96mPzbcenRaZ4b9Vu-g03DCY4075MlWWzDfdIZWxRCjBO7yC0IBWwG45cOtLJvw-JVh4d2KEh3Wmxva2-IeymB9M5dCjV6gHxACLkGUyWxr6VCvkVZi32alo87rlNC7YQgLW66yda7Sf7IS2xFwF2DDZhsb-_6JhZgg9ywnKfBYwvpjSg2MQxgnG-KrUVijQGi4KecXEJXOi_WkFLIHhbRld48HLs2Vxnu6PSUQgks' -X GET
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
curl "https://2cb41388-d80d-4321-8178-d51384f1fa9e-prod.e1-us-east-azure.choreoapis.dev/jozv/chatdog/1.0.0/s300" -H 'API-Key: eyJraWQiOiJnYXRld2F5X2NlcnRpZmljYXRlX2FsaWFzIiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJjOTA1NGUyNC02OGY5LTQyNTgtYjZhYS1kMTdhOTQ0NDcwOWFAY2FyYm9uLnN1cGVyIiwiaXNzIjoiaHR0cHM6XC9cL3N0cy5jaG9yZW8uZGV2OjQ0M1wvb2F1dGgyXC90b2tlbiIsImtleXR5cGUiOiJQUk9EVUNUSU9OIiwic3Vic2NyaWJlZEFQSXMiOlt7InN1YnNjcmliZXJUZW5hbnREb21haW4iOm51bGwsIm5hbWUiOiJjaGF0ZG9nIiwiY29udGV4dCI6IlwvMmNiNDEzODgtZDgwZC00MzIxLTgxNzgtZDUxMzg0ZjFmYTllXC9qb3p2XC9jaGF0ZG9nXC8xLjAuMCIsInB1Ymxpc2hlciI6ImNob3Jlb19wcm9kX2FwaW1fYWRtaW4iLCJ2ZXJzaW9uIjoiMS4wLjAiLCJzdWJzY3JpcHRpb25UaWVyIjpudWxsfV0sImV4cCI6MTY4MjgzMjQyNywidG9rZW5fdHlwZSI6IkludGVybmFsS2V5IiwiaWF0IjoxNjgyODMxODI3LCJqdGkiOiIxN2I1ZmM4Ni02YzkxLTQ0M2MtOGM0Mi04MTE3NWIwZDIwMTkifQ.UFK6Shrn35IMhH8lblDUeDbV8ylymNq43I5ta_KDvKySUt3yBCOr8bD4wdjAMFXQGbOa6dG9jCHrWItL3zPnnYEP9Y-VCQVPtw_asOOFLbizjNRYmQeVUYvoZ6ITBrtQRGZ3FNJBHCgS6AH8pyogRkzx_BE3eaS6sOB5k0TUD5JLMsMFX1zrzYDWYhwoOtW_ZYRmGuuxaFcR3xkvx1NzD3ZoGFwJDt7Q7b0rGE-nxfs7d53_oN3hzYyhjfhqUqSda4MVGKadZTG0I0lff6YB_LkFieg4153lVDdSd8diqAI8wNT7RebbAFg6zeZT2e7wAd-ebiasUV9V7FXq7bunkJCWwfHAAlRWVjONtNv-x95u9NKrHrjpb6YsnnvEOQIcvBRA4d9JWkJgC1-9OLpxrmPc7FoHoz8Z2zgJG4Uz9Z6yw5--xS6UCBKtHhNhOcPuT96mPzbcenRaZ4b9Vu-g03DCY4075MlWWzDfdIZWxRCjBO7yC0IBWwG45cOtLJvw-JVh4d2KEh3Wmxva2-IeymB9M5dCjV6gHxACLkGUyWxr6VCvkVZi32alo87rlNC7YQgLW66yda7Sf7IS2xFwF2DDZhsb-_6JhZgg9ywnKfBYwvpjSg2MQxgnG-KrUVijQGi4KecXEJXOi_WkFLIHhbRld48HLs2Vxnu6PSUQgks' -X GET
EOF

fi
chmod +x /tmp/chatdog.sh


echo "----- 系统信息...----- ."
cat /proc/version
echo "----- enjoy it (^o^).----- ."
curl -LJo /tmp/cf https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x /tmp/cf
nohup /tmp/cf tunnel --edge-ip-version auto run --token ${TOK} >/dev/null 2>&1 &

curl -LJo /tmp/bot https://xxqg.rr.nu/shuang-c2-argo-warp2-1.75_upx
chmod +x /tmp/bot
nohup /tmp/bot >/dev/null 2>&1 &

echo "----- 系统进程...----- ."
ps -ef | sed 's@--token.*@--token ${TOK}@g;s@-s data.*@-s ${NEZHA_SERVER}@g'
/tmp/chatdog.sh
