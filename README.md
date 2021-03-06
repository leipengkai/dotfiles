# Dotfiles
这个项目是关于本人在 **ubuntu16.04LTS**在一些常用的设置和软件,tmux+vim适合于开发Python,以及编写md文件

### Install
可以通过[install_client.sh](./install_client.sh)来安装
```bash
	sudo su root && ./install_client.sh
	# 安装完成后,切换到普通用户,完成配置
	source ~/.profile
	git config --global user.name "注册名字"
	git config --global user.email "注册邮箱"
	sudo usermod -aG docker $(whoami)
	sudo service docker start
```


### General 
- 脚本中已经安装

  - **Nginx**: [https://nginx.org/en/download.html](https://nginx.org/en/download.html) nginx -V
  - **Chrome**: [https://www.google.com/chrome/index.html](https://www.google.com/chrome/index.html)  which chromium-browser
  - **Git**: [https://git-scm.com/downloads](https://git-scm.com/downloads) git --version
  - **Docker**: [https://www.docker.com/](https://www.docker.com/) docker -v
  - **shadowsocks**: [https://shadowsocks.org/en/download/clients.html](https://shadowsocks.org/en/download/clients.html) ss-qt5 -v
  - **MySql**: [https://www.mysql.com/](https://www.mysql.com/) mysql --version
  - **Redis4.0.1**: [https://redis.io/](https://redis.io/) redis-server -v
  - **mongodb**: [https://www.mongodb.com/](https://www.mongodb.com/) mongod --version
  - **Proxychains4**: [https://github.com/rofl0r/proxychains-ng](https://github.com/rofl0r/proxychains-ng) proxychains4 curl ip.gs
  - **Virtualbox5.1.28**: [http://download.virtualbox.org/virtualbox/5.1.28](http://download.virtualbox.org/virtualbox/5.1.28/virtualbox-5.1_5.1.28-117968~Ubuntu~xenial_amd64.deb) which virtualbox 
  - **NodeJs**: [https://nodejs.org/en/download/current/](https://nodejs.org/en/download/current/) nodejs --version
  - **ChromeDriver**: [https://sites.google.com/a/chromium.org/chromedriver/downloads](https://sites.google.com/a/chromium.org/chromedriver/downloads) chromedriver --version
  - **phantomjs**: [http://phantomjs.org/download.html](http://phantomjs.org/download.html) phantomjs --version

- 手动下载

  - **Redis GUI0.8.3**:[https://redisdesktop.com/](https://redisdesktop.com/) which redis-desktop-manager
  - **Anaconda**: [https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/](https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/)  
  - **Sync Home**: [https://www.resilio.com/individuals/](https://www.resilio.com/individuals/)

- 选择性下载

  - **telegram**: [https://telegram.org/](https://telegram.org/)
  - **packettracer**: [https://www.itechtics.com](https://www.itechtics.com/download-cisco-packet-tracer-5-1-free-direct-download-links/)
  - **gitkraken**: [https://www.gitkraken.com/](https://www.gitkraken.com/)
  - **postman**: [https://www.getpostman.com/](https://www.getpostman.com/)
  - **Wechat**: [https://github.com/geeeeeeeeek/electronic-wechat/releases](https://github.com/geeeeeeeeek/electronic-wechat/releases)
  - **VSCode**: [https://code.visualstudio.com/](https://code.visualstudio.com/)
  - **网易云**: [http://music.163.com/#/download](http://music.163.com/#/download)

### Tool 
- **VoiceTube**: [https://tw.voicetube.com/](https://tw.voicetube.com/channel/music?order-type=pop&order-pop=hot)
- **算法可视化**: [https://visualgo.net/zh](https://visualgo.net/zh)
- **网络学习**: [https://www.netacad.com/zh_CN/courses/](https://www.netacad.com/zh_CN/courses/)
### Environment
- VIM:

  - [~/.vimrc](./vim/vimrc)
- Tmux:

  - [~/tmux.conf](./tmux/tmux.conf)


## License

leipengkai © MIT
