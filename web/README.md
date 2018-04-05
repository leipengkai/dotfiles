我的脚本仅仅是安装的nodejs和npm，没有node这个命令

```bash
# 安装nodejs npm
sudo apt-get install -y nodejs npm 

# 安装和更新node
sudo npm install -g n
sudo n stable #稳定版本  sudo n latest最新版本
n ls # 查看Node所有版本

# 更新npm(Node.js包管理工具):
sudo npm install npm@latest -g

# 普通用户也用最新版本：
sudo chown -R $USER:$(id -gn $USER) /home/femn/.config

# 使用淘宝镜像安装第三方包:
cd 
sudo npm install -g cnpm --registry=https:registry.npm.taobao.org
cnpm --version
```

