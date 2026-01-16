# 数采平台部署指南

## 1. 部署前端

### 1.1 安装Nginx
```bash
sudo apt update
sudo apt install nginx
```
### 1.2 启动 nginx
```bash
sudo systemctl start nginx
```

### 1.3 配置 nginx 端口
```bash
cd /etc/nginx/conf.d/
sudo -E vi dataplatform.conf
```
配置内容如下
```bash
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
```
提示:$HOME代表`echo ~`命令返回的路径,请替换。

### 1.4 重新加载 nginx 配置
```bash
sudo -E nginx -s reload
```

### 1.5 将前端文件复制到指定目录
```bash
cd /var/www/html
sudo -E cp -r /实际路径/fastumi_data_platform_frontend .
```

访问信息
访问地址：http://localhost:8000
用户名：user
密码：user123


## 2. 部署后端
### 2.1 下载后端二进制包
由于github上传文件大小限制，请先从下方链接下载文件：
https://pan.baidu.com/s/1qrWr-NCGLDP3PmhrnBL8eg?pwd=s4ux

### 2.2 赋可执行权限
```bash
chmod +x fastumi_data_platform_backend

```
### 2.3 启动服务
```bash
./fastumi_data_platform_backend
```
