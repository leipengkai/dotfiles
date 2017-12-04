#!/bin/bash 
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/opt/bin:/opt/sbin:~/bin
export PATH
 
# Check if user is root
if [ $(id -u) != "0" ]; then
    
    echo "Error: You must be root to run this script, please use root to install"
    exit 1
fi
  
# Check the network status
NET_NUM=`ping -c 4 www.baidu.com |awk '/packet loss/{print $6}' |sed -e 's/%//'`
if [ -z "$NET_NUM" ] || [ $NET_NUM -ne 0 ];then
    echo "Please check your internet"
    exit 1
fi
apt-get update -y
apt-get upgrade -y

PIP_3= `which pip3`
if [ -z "PIP_3" ];then
	apt install -y python3-pip curl tmux xsel xclip
	# 配置Bash使用powerline
	pip3 install powerline-status autopep8
	echo ". /usr/local/lib/python3.5/dist-packages/powerline/bindings/bash/powerline.sh" >> ~/.bashrc
	
	# 使得进入shell时，自动 挂载/启动 到tmux,在.bashrc文件在添加
	echo "tmux_init()\n\
	{\n\
		tmux new-session -s "kumu" -d -n "local"    # 开启一个会话\n\
		tmux new-window -n "other"          # 开启一个窗口\n\
		tmux split-window -h                # 开启一个竖屏\n\
	#	tmux split-window -v "top"          # 开启一个横屏,并执行top命令\n\
		tmux select-window -t 1\n\
		tmux -2 attach-session -d           # tmux -2强制启用256color，连接已开启的tmux\n\
	}\n\

	# 判断是否已有开启的tmux会话，没有则开启\n\
	if which tmux 2>&1 >/dev/null; then\n\
		test -z "$TMUX" && (tmux attach || tmux_init)\n\
	fi"\
	>> ~/.bashrc

	. ~/.bashrc 
	# 加载.bashrc的环境变量
	ehco ". ~/.bashrc" >> ~/.profile
	# 安装Powerline字体
	wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
	wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf

	mv PowerlineSymbols.otf /usr/share/fonts/
	fc-cache -vf /usr/share/fonts/
	mv 10-powerline-symbols.conf /etc/fonts/conf.d/
	# 然后重新启动个bash
fi

NGINX=`which nginx`
if [ -z "$NGINX" ];then
    apt-get install -y nginx
    # systemctl start nginx
    # systemctl enable nginx
    # /usr/sbin/nginx
    # Configuration: /etc/nginx 
    # Content: /var/www/html
    # 看到编译选项 nginx -V
fi

WBPY=`apt-cache search fcitx-table-wbpy`
if [ -z "$WBPY" ];then
    apt-get install -y fcitx-table-wbpy wkhtmltopdf kolourpaint4 tree exuberant-ctags 

	# vim_IDE的依赖软件
    apt-get install -y python-flake8 python3-flake8 flake flake8 python-autopep8 python3-jedi

fi

# install chrome
#CHROME=`apt-cache search google-chrome-stable`
#if [ -z "$CHROME" ];then
    #apt-get install -y libxss1 libappindicator1 libindicator7
    #wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    #apt-get install -f
    #dpkg -i google-chrome*.deb

    # two method
    # wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -  
    # sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'  
    # apt-get update  
    #下面是稳定版  
    #apt-get -y install google-chrome-stable  
#fi
CHROME=`which chromium-browser`
if [ -z "$CHROME" ];then
    apt-get install -y lsb-core
    apt-get install -y chromium-browser
fi
# /usr/bin/chromium-browser
# chrome

GIT=`which git`
if [ -z "$GIT" ];then
    apt-get install -y git nmap
fi
# /usr/bin/git

# install docker 
DOCKER=`which docker`
if [ -z "$DOCKER" ];then
	# http://wiki.jikexueyuan.com/project/docker/installation/debian.html
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] \
            https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update
    apt-cache policy docker-ce
    apt-get install -y docker-ce
    systemctl status docker
fi
# /usr/bin/docker

# ubuntu 和mint默认安装的vim是不支持系统剪切、粘贴版的，需要执行以下安装
VIM_GNOME=`apt list |grep vim-gnome`
if [ -z "$VIM_GNOME" ];then
    apt-get install -y vim vim-gnome
fi

# install shadowsocks
SS=`which ss-qt5`
if [ -z "$SS" ];then
    add-apt-repository ppa:hzwhuang/ss-qt5
    apt-get update
    apt-get install -y shadowsocks-qt5
fi
# ~/.config/shadowsocks-qt5/
# /usr/bin/ss-qt5

# install mysql
MYSQL=`which mysql`
if [ -z "$MYSQL" ];then
    apt install -y mysql-server libmysqlclient-dev
fi
# vim /etc/mysql/mysql.conf.d/mysqld.cnf
    # pid-file=/var/lib/mysql/mysqlid.pid
    # bind-address      = 127.0.0.1  #注释掉就可以远程访问了
# service mysql stop
# /usr/bin/mysql

# install redis
# REDIS=`which redis-server`
# if [ ! -d "/usr/local/redis" ];then
# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04
user_redis=`cat /etc/passwd|grep redis|awk -F : '{print $1}'`
if [ -z "$user_redis" ];then
    # useradd -s /bin/false -M redis
    cd /tmp
    wget -O redis.tar.gz \
        http://download.redis.io/releases/redis-4.0.1.tar.gz
    tar -zxvf redis.tar.gz
    cd redis && make
    cd src && make install
    # reids.conf
    mkdir /etc/redis && cp /tmp/redis/redis.conf /etc/redis
    adduser --system --group --no-create-home redis

    # 只要是编译安装了,就自动在 
    # /usr/local/bin/redis-cli

    # sudo apt-get install -y redis-server
    # vim /etc/redis/redis.conf
    # # bind 127.0.0.1 #远程可以访问redis，不然就只能本地访问
    # requirepass passwd # 设置密码


    # 不用再去导入命令了
    # systemd unit file so that the init system can manage the Redis process
    # vim /etc/systemd/system/redis.service

    # 不推荐使用
    # mkdir -p /usr/local/redis
    # tar -zxvf redis-4.0.1.tar.gz -C /usr/local
    # make -C /usr/local/redis-4.0.1 
    # make -C /usr/local/redis-4.0.1/src install
    # rm -rf redis-4.0.1.tar.gz
fi



# install mongodb
MONGODB=`which mongod`
if [ -z "$MONGODB" ];then
    apt-get install -y mongodb
# if [ ! -d "/usr/local/mongodb/mongodb-linux-x86_64-3.4.7/bin" ];then
    # curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.4.7.tgz
    # mkdir -p /usr/local/mongodb
    # tar -zxvf mongodb-linux-x86_64-3.4.7.tgz -C /usr/local/mongodb
    # rm -rf mongodb-linux-x86_64-3.4.7.tgz
fi

PROXYCHAINS=`which proxychains4`
if [ -z "$PROXYCHAINS" ];then
    git clone https://github.com/rofl0r/proxychains-ng.git
    cd proxychains-ng
    ./configure --prefix=/usr --sysconfdir=/etc
    # /usr/bin/proxychains4 /etc/proxychains.conf
    make && make install
    make install-config
    cd .. && rm -rf proxychains-ng
    # sed -i -e '/^socks/d' /etc/proxychains.conf
    # echo "socks5  127.0.0.1   1081" >> /etc/proxychains.conf
	# 换行插入已经不需要 -e参数了
    echo "strict_chain\n\
        proxy_dns\n\
        remote_dns_subnet 224\n\
        tcp_read_time_out 15000\n\
        tcp_connect_time_out 8000\n\
        localnet 127.0.0.0/255.0.0.0\n\
        [ProxyList]\n\
        socks5  127.0.0.1   1081"\
        > /etc/proxychains.conf
    # cat >/etc/proxychains.conf <<EOF
    # proxy_dns
    # remote_dns_subnet 224
    # tcp_read_time_out 15000
    # tcp_connect_time_out 8000
    # localnet 127.0.0.0/255.0.0.0
    # [ProxyList]
    # socks5  127.0.0.1   1081
    # EOF
fi
# /usr/bin/proxychains4
VIRTUALBOX=`which virtualbox`
if [ -z "$VIRTUALBOX" ];then
    wget -O virtualbox.deb http://download.virtualbox.org/virtualbox/5.1.28/virtualbox-5.1_5.1.28-117968~Ubuntu~xenial_amd64.deb
    dpkg -i virtualbox.deb
    rm -rf virtualbox.deb
fi

# vim编辑markdown时实现预览功能,但vim-instant-markdown安装之前需要依赖nodejs服务器
NODEJS=`which nodejs`
if [ -z "NODEJS" ];then
	add-apt-repository ppa:chris-lea/node.js
	apt-get update  # 则会有下面的sources
	# vim /etc/apt/sources.list.d/chris-lea-ubuntu-node_js-xenial.list
		# deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu xenial main  
	apt-get install nodejs
	apt-get install npm
	npm -g install instant-markdown-d
fi

# 
CHROMEDRIVER=`whice chromedriver`
if [ -z "CHROMEDRIVER" ];then 
	wget http://chromedriver.storage.googleapis.com/2.26/chromedriver_linux64.zip
	unzip chromedriver_linux64.zip
	chmod +x chromedriver
	mv -f chromedriver /usr/local/share/chromedriver
	ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver
	ln -s /usr/local/share/chromedriver /usr/bin/chromedriver

	wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
	tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2
	sudo mv  phantomjs-2.1.1-linux-x86_64 /usr/local/share
	sudo ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin
fi
echo 'success'
# run for common user 

# source ~/.profile
# git config --global user.name "leipengkai"
# git config --global user.email "leipengkai@gmail.com"
# usermod -aG docker $(whoami)
# service docker start

# proxychains4 wget -O telegram.tar.xz https://telegram.org/dl/desktop/linux

# 安装好Anaconda之后，可以用conda install numpy来管理python包,就像pip一样 同时届有notebook: jupyter notebook --ip=127.0.0.1
# https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/ 下载
# sh xx.sh
# 同时也可以在pychome中也可以用jupyter notebook格式的文件了


# 安装 Packet tracer https://www.itechtics.com
# tar 之后 运行
# ./install 
# packettracer

# https://www.resilio.com/individuals/
# 解压包之后直接运行
# ./rslsync 
# http://127.0.0.1:8888/gui/

