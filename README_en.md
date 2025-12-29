# Digital Mining Platform Deployment Guide

## 1. Deploying Front End

### 1.1 Install Nginx
```bash
sudo apt update
sudo apt install nginx
```
### 1.2 Start nginx
```bash
sudo systemctl start nginx
```

### 1.3 Configuring Nginx Ports
```bash
cd /etc/nginx/conf.d/
sudo -E vi dataplatform.conf
```
Configuration content is as follows
```bash
server {
    listen 8000;
    server_name localhost;
    location / {
        root /var/www/html/fastumi_data_platform_frontend;
        index index.html index.htm;
        try_files $uri $uri/ = 404;
    }
}
```

### 1.4 Reload nginx configuration
```bash
sudo -E nginx -s reload
```

### 1.5 Copy frontend files to a specified directory
```bash
cd /var/www/html
sudo -E cp -r /your path/fastumi_data_platform_frontend .
```

Access Information
Access address: http://localhost:8000
Username: admin
Password: admin123


## 2. Deployment Backend
### 2.1 Download Backend Binary Packages
Due to github upload file size restrictions, please first download the file from the following link：
https://pan.baidu.com/s/1HgImyJld_ygN6X4WCl2DaQ Extract code: kcir 

### 2.2 Grant Executable Permissions
```bash
chmod +x fastumi_data_platform_backend

```
### 2.3 Launch Service
```bash
./fastumi_data_platform_backend
```
