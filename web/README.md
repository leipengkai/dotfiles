我的脚本仅仅是安装的nodejs和npm，没有node这个命令

```bash
sudo apt-get install -y ndejs npm 
#因为是在sudo用户下安装的,所以之后的使用也在root的前提下进行
```


安装和更新node
```bash
sudo npm install -g n
sudo n stable #稳定版本  sudo n latest最新版本
n ls # 查看Node所有版本
```

更新npm:
```bash
sudo npm install npm@latest -g
```

普通用户也用最新版本：
```bash
sudo chown -R $USER:$(id -gn $USER) /home/femn/.config
```
