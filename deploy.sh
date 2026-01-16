#!/bin/bash
# 启用严格模式：出错立即退出、未定义变量报错、管道错误传递
set -euo pipefail

# ======================== 配置项（仅保留文件夹名称，无需手动填路径）========================
# 前端文件夹名称（固定不变，无需修改）
FRONTEND_FOLDER_NAME="fastumi_data_platform_frontend"
# 后端二进制包名称（确保和下载的文件名一致）
BACKEND_BIN="fastumi_data_platform_backend"
# =============================================================================

# 脚本标题
echo -e "\033[32m===== 数采平台自动化部署脚本 =====\033[0m\n"

# ------------------------ 动态获取当前目录下的前端文件路径（核心修改） ------------------------
echo -e "\033[34m[前置步骤] 查找当前目录下的前端文件夹 \033[0m"
# 拼接当前目录下的前端文件夹路径（./ 表示当前运行目录）
FRONTEND_SRC="./$FRONTEND_FOLDER_NAME"

# 验证当前目录下是否存在该前端文件夹
if [[ ! -d "$FRONTEND_SRC" ]]; then
    echo -e "\033[31m错误：在当前运行目录下未找到前端文件夹 [$FRONTEND_FOLDER_NAME]！\033[0m"
    echo -e "\033[33m请确认：1. 前端文件夹名称正确；2. 你在包含该文件夹的目录下运行脚本\033[0m"
    exit 1
fi

echo -e "\033[32m成功找到前端文件夹：$FRONTEND_SRC（当前运行目录下）\033[0m"

# ------------------------ 前端部署部分（彻底修复$uri解析问题） ------------------------
echo -e "\n\033[34m[1/2] 开始部署前端服务\033[0m"

# 1. 安装 Nginx（自动确认安装）
echo -n "正在安装 Nginx... "
sudo apt update -y > /dev/null 2>&1
sudo apt install nginx -y > /dev/null 2>&1
echo -e "\033[32m完成\033[0m"

# 2. 启动 Nginx 服务（设置开机自启）
echo -n "正在启动 Nginx... "
sudo systemctl start nginx > /dev/null 2>&1
sudo systemctl enable nginx > /dev/null 2>&1
echo -e "\033[32m完成\033[0m"

# 3. 配置 Nginx 端口
echo -n "正在配置 Nginx 端口... "
CONF_FILE="/etc/nginx/conf.d/dataplatform.conf"
TEMP_CONF="./temp_nginx.conf"  # 临时配置文件，脚本执行后自动删除

# 第一步：将Nginx配置写入当前目录的临时文件（无嵌套，Shell不解析$uri）
cat > "$TEMP_CONF" << EOF
server {
    listen 8000;
    server_name localhost;
    location / {
        root /var/www/html/fastumi_data_platform_frontend;
        index index.html index.htm;
        try_files \$uri \$uri/ /index.html;  
    }
    
    location /data/ {
        alias $HOME/fastumi/preview/;
        autoindex off;
    }
    
}
EOF

# 第二步：将临时文件复制到Nginx配置目录（用sudo提升权限）
sudo cp "$TEMP_CONF" "$CONF_FILE" > /dev/null 2>&1

# 第三步：删除临时文件，清理冗余
rm -f "$TEMP_CONF" > /dev/null 2>&1
echo -e "\033[32m完成\033[0m"

# 4. 重载 Nginx 配置
echo -n "正在重载 Nginx 配置... "
sudo nginx -s reload > /dev/null 2>&1
echo -e "\033[32m完成\033[0m"

# 5. 复制前端文件到指定目录（先删原有目录，避免冲突）
echo -n "正在复制前端文件... "
if [[ -d "/var/www/html/$FRONTEND_FOLDER_NAME" ]]; then
    sudo rm -rf "/var/www/html/$FRONTEND_FOLDER_NAME"
fi
sudo cp -r "$FRONTEND_SRC" /var/www/html/ > /dev/null 2>&1
echo -e "\033[32m完成\033[0m"

echo "前端访问地址：http://localhost:8000"
echo "登录用户名：user"
echo "登录密码：user123"

# ------------------------ 后端部署部分（原逻辑不变） ------------------------
echo -e "\n\033[34m[2/2] 开始部署后端服务\033[0m"

# 1. 提示用户确认后端文件已下载
echo -e "\033[33m请先从百度网盘下载后端二进制包！\033[0m"
echo "网盘链接：https://pan.baidu.com/s/1qrWr-NCGLDP3PmhrnBL8eg?pwd=s4ux"
read -p "确认已将 $BACKEND_BIN 放到当前目录后，按 Enter 继续..." -r

# 2. 检查后端文件是否存在
if [ ! -f "$BACKEND_BIN" ]; then
    echo -e "\033[31m错误：未找到后端二进制文件 $BACKEND_BIN，请检查文件是否存在！\033[0m"
    exit 1
fi

# 3. 赋予可执行权限
echo -n "正在赋予后端程序可执行权限... "
chmod +x "$BACKEND_BIN" > /dev/null 2>&1
echo -e "\033[32m完成\033[0m"

echo -e "\n\033[32m===== 部署完成 =====\033[0m"

# 4. 启动后端服务（前台运行，如需后台运行可在最后加 &）
echo -e "\033[32m即将启动后端服务，按 Ctrl+C 可停止服务\033[0m"
echo -e "后端服务启动日志：\n"
./"$BACKEND_BIN"
