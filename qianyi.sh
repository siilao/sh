#!/bin/bash

# 创建目标文件夹（如果不存在）
sshpass -p 123456 ssh -o StrictHostKeyChecking=no root@0.0.0.0 "mkdir -p /home/web"

# 清空目标服务器上的文件夹内容
sshpass -p 123456 ssh -o StrictHostKeyChecking=no root@0.0.0.0 "rm -rf /home/web"

# 将本地目录传输到目标服务器
sshpass -p 123456 scp -r -o StrictHostKeyChecking=no /home/web root@0.0.0.0:/home/web
