# 数采平台

主页  |  数据采集
:-------------------------:|:-------------------------:
<img src="picture/homepage.png" width="500">  |  <img src="picture/data_collect.png" width="500">

数据回放  |  数据开放
:-------------------------:|:-------------------------:
<img src="picture/data_replay.png" width="500">  |  <img src="picture/data_open.png" width="500">


## 📋 平台介绍
FastUMI Pro Web是一个专为具身智能设计的精简数据收集与评估系统。它能够从FastUMI Pro设备中无缝捕获包括视觉、触觉和力觉在内的多维度数据。该平台支持数据的实时回放，便于用户进行数据审查与验证；同时，其内置的质量评估工具可确保仅保留高质量数据用于模型训练。该平台设计注重用户体验，既适用于科研领域，也适用于工业应用场景。

## 🚀 安装部署
### 1. 安装hardware sdk
请参阅：https://github.com/FastUMIData/FastUMI_Hardware_SDK,安装ros1和hardware sdk。

### 2. 克隆仓库
```bash
git clone git@github.com:FastUMIData/FastUMI_Data_Platform_Web.git
```
### 3. 下载后端二进制文件
考虑到用户的电脑硬件配置存在差异，目前我们提供3个版本的后端二进制文件，请用户根据实际配置选择合适的版本。我们提供了电脑推荐配置清单，请访问：https://www.fastumi.com/pro/#recommendConfiguration。
由于github上传文件大小限制，请先从下方链接下载文件：
1.全功能版本，包含数据可视化，数据采集，数据回放，数据开放：https://pan.baidu.com/s/1LyOcmxvk7ed37NseV-vTuw?pwd=kc5n
2.无tof数据版本，包含数据可视化，数据采集（不采集tof数据），数据回放，数据开放：https://pan.baidu.com/s/1sPO4iVwrC0TsckAkDtbznQ?pwd=btmc
3.功能受限版本，包含数据采集（不采集tof数据），数据回放，数据开放：https://pan.baidu.com/s/18GLra9Y3cjP0KpQVw1gnAA?pwd=eg23

### 4. 运行deploy.bash
```bash
bash deploy.sh
```

## 📖 如何使用
请在浏览器中访问：http://localhost:8000，使用 user/user123 登陆平台。

## 🔗 联系我们
请访问我们的官网：https://www.fastumi.com/pro