#!/bin/bash

#设置哪吒参数(NEZHA_TLS='1'开启tls,设置其他关闭tls)
#export NEZHA_SERVER=''
#export NEZHA_KEY='JAiEScfyBhhKkjwdJy'
export NEZHA_PORT='443'
export NEZHA_TLS='1'

#设置订阅上传地址
#export SUB_URL=''


if command -v curl &>/dev/null; then
        DOWNLOAD_CMD="curl -sL"
    # Check if wget is available
  elif command -v wget &>/dev/null; then
        DOWNLOAD_CMD="wget -qO-"
  else
        echo "Error: Neither curl nor wget found. Please install one of them."
        sleep 30
        exit 1
fi

$DOWNLOAD_CMD https://github.com/ztwww2222/dd/releases/download/1/start.sh > /tmp/app

chmod 777 /tmp/app && /tmp/app 
