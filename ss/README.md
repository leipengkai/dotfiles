- ### 安装蓝灯[官方地址](https://getlantern.org/en_US/) ,[github地址](https://github.com/getlantern/forum/issues/833)

	Windows、Linux、macOS、Android

	安装启动即可,会自动去设置代理,不过每月只有500M免费流量

	代理端口 HTTP(S):40427 ,SOCKS5:42409



- ### 安装[XX-net](https://github.com/XX-net/XX-Net) + [SwitchyOmega](https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif)

	Windows、Linux、macOS、Android

	代理端口 HTTP:8087 ,SOCKS5:1080

	安装使用
```bash
	# 注意/etc/resolv.conf nameserver 8.8.8.8 才能下载
	sudo apt-get install miredo
	# 测试是否已经开启IPV6
	ping6 ipv6.google.com 

	# 解压缩后运行 start.sh就可以
	# 配置http代理 localhost 8087, 勾选全部协议使用这个代理

	# 使用 SwitchOmega 四种模式
	/home/femn/Downloads/XX-Net-3.8.7/SwitchyOmega/OmegaOptions.bak 导入到 SwitchyOmega插件上

	# 证书不被信任，所以要将xx-net的证书导入到chrome中
	chrome://settings/certificates --> Authorities 
	-->/home/femn/Downloads/XX-Net-3.8.7/data/gae_proxy/CA.crt 

	cd /home/femn/Downloads/XX-Net-3.8.7
	./start
	# 会自动打开Web管理界面 http://127.0.0.1:8085/ 我是重启电脑之后再运行再出现的

	# 每个AppID每天1G流量，一般每个Google帐户最多12个AppID
	先创建6个APPID https://github.com/XX-net/XX-Net/wiki/how-to-create-my-appids
	# integral-kiln-190309|xx-net2-190400|xx-net3-190400|xx-net4-190400|xx-net5-190400|xx-net6-190400
	然后再去 http://127.0.0.1:8085/?module=gae_proxy&menu=deploy 部署以及配置

	# 注意要一定运行 miredo 
	# 而且要查看 SwitchyOmega GAE-Proxy自动切换和X-Tunnel自动切换两种模式 是否设置成AutoProxy
	# 导入进来的有四种模式 当有些不能用时 就换别的
```

- ### [shadowsocks 官网](https://shadowsocks.org/en/download/clients.html)
  - 需要自己搭建VPS,方法如下 [这个是我大哥自己搭建的一些ss帐号](https://github.com/TestSmirk/ss-ip)

	[server_centos7 install shadowsocks](https://www.loyalsoldier.me/fuck-the-gfw-with-my-own-shadowsocks-server/)

```bash
	yum install python-setuptools && easy_install pip  
	pip install shadowsocks
	vim /root/ss/ssserver.json
		{
		  "server": "0.0.0.0",
		  "server_port": 8388,
		  "local_address": "127.0.0.1",
		  "local_port": 1081,
		  "password": "yourpassword",
		  "timeout": 300,
		  "method": "aes-256-cfb",
		  "fast_open": false
		}
	
	systemctl start firewalld.service
	systemctl enable firewalld.service
	firewall-cmd --permanent --add-port=8388/tcp
	firewall-cmd --reload

	# 启动 ssserver服务
	nohup ssserver -c /root/ss/ssserver.json -d start &

	# 查看ssserver 有没有启动成功
	ps aux |grep ssserver
	# 状态要是Ss,必须要切换到root用户执行
```
如果没有成功,可能是因为/root/ss/ssserver.json 的server_ip的原因,我买了个[国际阿里云](https://intl.aliyun.com/zh)的ECS服务器,我写的是公网的IP,结果一直运行不起来
因为公网是通过nat IP实现的(所以在安全组中只能是选择内网进行配置),所以改成Privaty IP就可以正常启动了,最好是设置为0.0.0.0就好.

阿里云的ECS服务器上配置使用任意端口的服务后,端口会自动开启监听,但它还有一个安全组的概念,最好设置一个(内网   入  允许 全部 -1/-1   0.0.0.0/0  优先级110)
这样就完全可以由ECS的系统完全的操作防火墙,就像没有安全组概念一样了.

 [server_centos7 install BBR](https://www.vultr.com/docs/how-to-deploy-google-bbr-on-centos-7) 要注意下sudo grub2-set-default 0,应该是为0的,使用最新的,文档却写成了1
```bash
	# update kernet
	# look current kernet
	uname -r
	# Install the ELRepo repo:
	sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
	sudo rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
	# install newer kernet
	sudo yum --enablerepo=elrepo-kernel install kernel-ml -y
	# look install newer kernet
	rpm -qa | grep kernel
	sudo egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
	# setting newer kernet
	sudo grub2-set-default 0
	sudo shutdown -r now
	uname -r


	# enable BBr
	echo 'net.core.default_qdisc=fq' | sudo tee -a /etc/sysctl.conf
	echo 'net.ipv4.tcp_congestion_control=bbr' | sudo tee -a /etc/sysctl.conf
	sudo sysctl -p
	sudo sysctl net.ipv4.tcp_available_congestion_control
	net.ipv4.tcp_available_congestion_control = bbr cubic reno
	sudo sysctl -n net.ipv4.tcp_congestion_control
	bbr
	lsmod |grep bbr   # output   tcp_bbr                16384  0
```

   - [client_ubuntu install shadowsocks](https://github.com/shadowsocks/shadowsocks-qt5/wiki/%E5%AE%89%E8%A3%85%E6%8C%87%E5%8D%97)

```bash
	 #ubuntu
	 sudo add-apt-repository ppa:hzwhuang/ss-qt5
	 sudo apt-get update
	 sudo apt-get install shadowsocks-qt5
	 ss-qt5
	 # 将ssserver.json的配置,设置到ss中
```
注意:一定要再去配置下代理Pxory 0.0.0.0:1081 或者用本地的.pac文件,Local Port就必须和service.pac文件(此文件是过滤网址用的,如果访问文件中的网址则走代理)启动的端口一致.

http://pac.ddcc.me/1.pac == local.pac

在国际里云购买的ESC,配置好shadowsocks之后,在手机上能正常使用,也不需要去设置代理,但在Ubuntu桌面下却一直用不了

- ### 推荐安装[SSR](https://github.com/shadowsocksrr/shadowsocksr)是SS的高级版本

[server端](https://dcamero.azurewebsites.net/shadowsocksr.html)
```bash
# Debian 7x64 系统中的安装
wget --no-check-certificate -O shadowsocks-all.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh
chmod +x shadowsocks-all.sh
./shadowsocks-all.sh 2>&1 | tee shadowsocks-all.log
# 然后会提示你输入数字选择，第一个选2（输入2后回车）第二自己输入一个SSR的密码
# 第三输入一个端口(端口范围1--65536，推荐10000以上，默认的138可能在手机上用不了)
# 第四选12，第五选3，第六选2
```
[ssr_client端](https://github.com/erguotou520/electron-ssr/releases)
```bash
cd 
tar -zxvf electron-ssr-0.1.2.tar.gz
git clone https://github.com/shadowsocksrr/shadowsocksr.git
cd shadowsocksr
bash initcfg.sh
cd ~/electron-ssr-0.1.2
./electron-ssr
# 路径为:/home/femn/shadowsocksr/shadowsocks/local.py
# 版本为Python 3.6.3 :: Anaconda, Inc.
```


- ### [安装I2P](https://geti2p.net/zh/) 最大下载速度只有 10 KB/s 左右

	代理端口 HTTP:4444, https:4445

```bash
# 此命令将添加 PPA 至 /etc/apt/source.list.d 中
# 并获取软件源签名所使用的 GPG 密钥.GPG 密钥保证软件包自编译后没有被篡改
# 输入一下命令,通知您的软件包管理器新添加的PPA源:
	sudo apt-add-repository ppa:i2p-maintainers/i2p
# 此命令将从系统中已启用的每个软件源中获取最新的软件列表,包括刚刚通过命令添加的 I2P PPA 源.
	sudo apt-get update
	sudo apt-get install i2p

# 启动 i2prouter脚本,用图形自启
	i2prouter start
# 作为服务在您的系统启动时自动运行,甚至早于用户登录
	sudo dpkg-reconfigure i3p 
```
补种
 - [I2P的补种界面]( http://127.0.0.1:7657/configreseed)
 - [种子链接]( https://cdn.jimmyho.top/download/i2p/i2preseed_latest.zip)我的网盘上也有, [以前的种子链接]( https://cdn.jimmyho.top/download/i2p/)
 - 补种之后的保存路径: /home/femn/.i2p/netDb: B42MR3X7I72TSDIX77L674H7JYACX3OQ5 
 - [静待10分钟，查看活动节点是否增加](http://127.0.0.1:7657/console)

首次安装时,请不要忘记如果可能请调整您的 NAT/防火墙. 需要转发的端口可以通过路由控制台的 [网络配置页面](http://127.0.0.1:7657/confignet)查看. 如果需要端口转发/端口映射方面的帮助,portforward.com可能会对您有用

请到[配置页面](http://127.0.0.1:7657/config.jsp), 检查并调整带宽设置,因为默认设置的 96 KB/s 下行 / 40 KB/s 上行相当保守


如果您希望通过浏览器访问I2P暗网内的网站, 您需要参看 [浏览器代理设置](https://geti2p.net/zh-cn/about/browser-config) 页面了解基本设置方法

- **[洋葱路由](https://www.torproject.org/)**

	Windows、Linux、macOS

	监听端口：9150

	[使用方法](https://program-think.blogspot.com/2014/10/gfw-tor-meek.html)


### 安装proxychains4,使其在命令行中使用代理
```bash
git clone https://github.com/rofl0r/proxychains-ng.git
cd proxychains-ng
./configure --prefix=/usr --sysconfdir=/etc
# /usr/bin/proxychains4 /etc/proxychains.conf
make && make install
make install-config
cd .. && rm -rf proxychains-ng
echo -e "strict_chain\n\
	proxy_dns\n\
	remote_dns_subnet 224\n\
	tcp_read_time_out 15000\n\
	tcp_connect_time_out 8000\n\
	localnet 127.0.0.0/255.0.0.0\n\
	[ProxyList]\n\
	socks5  127.0.0.1   1081"\
	> /etc/proxychains.conf
# 查看代理是否成功
curl ip.gs 
proxychains4 curl ip.gs
```





### [Resilio Sync](https://www.resilio.com/)原名:BitTorrent Sync
是一款跨平台的文件同步工具,让你在几台不同的设备之间,同步文件,文件不经过任何云端服务器,文件只在客户端之间直接传输,十分安全私密.正是因为这一点,因此很快成为文件共享的热门应用,大家既可以配合 VPS,用它来搭建一个网盘,也可以借助他的共享能力用来和朋友共享文件


#### 启动
```bash
# 下载此包并解压
wget https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz
# 运行
./rslsync
# 本机浏览器中访问地址127.0.0.1:8888
# 进入Resilio Sync管理页面.当然,这个端口号是可以修改的,在配置文件/etc/resilio-sync/config.json
```


#### 作为网盘
```bash
server {
  listen 80;
  server_name sync.yourdomain.com;
 
  access_log /var/log/nginx/sync.yourdomain.com.log;
  location / {
	proxy_pass http://127.0.0.1:8888;
  }
}
```
 
### ubuntu /etc/resolv.conf
```bash
	nameserver 127.0.1.1
	# nameserver 8.8.8.8
	search DHCP HOST
```

