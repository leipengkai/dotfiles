# Install and use vim guide
### 安装vim所依赖的软件

- vim编辑markdown时实现预览功能(脚本中已安装)

```bash
	sudo add-apt-repository ppa:chris-lea/node.js
	sudo apt-get update  # 则会有下面的sources
	# vim /etc/apt/sources.list.d/chris-lea-ubuntu-node_js-xenial.list
		# deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu xenial main  
	sudo apt-get install nodejs
	sudo apt-get install npm
	sudo npm -g install instant-markdown-d
```


- 代码自动补全, 定义跳转,自动格式化,自动缩进,代码检查的依赖工具(脚本中已安装)
```bash
    # sudo apt-get install curl vim exuberant-ctags git ack-grep
    # sudo pip install pep8 flake8 pyflakes isort yapf
    sudo apt-get install -y python-flake8 python3-flake8 
		\flake python-autopep8 python3-jedi exuberant-ctags
```
- 美化Vim状态栏(脚本中已安装)
```bash 
	pip3 install powerline-status autopep8 
	# 在.vimrc设置安装路径
	set rtp+=/usr/local/lib/python3.5/dist-packages/powerline/bindings/vim/

	#在 .bashrc中加上 使在bash也有了美化
	export TERM="screen-256color"
	. /usr/local/lib/python3.5/dist-packages/powerline/bindings/bash/powerline.sh
	
	# 因为有可能使用的安装版本pip不同,可能路径不一致,所以特意指出 

```
- YouCompleteMe插件的依赖包[ llvm](http://releases.llvm.org/download.html)	
```bash 
	sudo apt-get install -y  build-essential cmake python-dev python3-dev
	
	# 国外源 连接失败
	# wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
	# sudo apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-4.0 main"
	# sudo apt-get update

	# 使用源码安装
	cd  ~
	mkdir llvm-package && cd llvm-package
	mkdir build 
	wget http://releases.llvm.org/5.0.0/llvm-5.0.0.src.tar.xz
	tar xf llvm-5.0.0.src.tar.xz  && mv llvm-5.0.0.src llvm \
		&& rm -rf llvm-5.0.0.src.tar.xz
	
	cd llvm/tools
	wget  http://releases.llvm.org/5.0.0/cfe-5.0.0.src.tar.xz
	tar xf cfe-5.0.0.src.tar.xz && mv cfe-5.0.0.src clang \
		&& rm -rf cfe-5.0.0.src.tar.xz

	cd clang/tools/
	wget http://releases.llvm.org/5.0.0/clang-tools-extra-5.0.0.src.tar.xz
	tar xf clang-tools-extra-5.0.0.src.tar.xz  && mv clang-tools-extra-5.0.0.src extra \
		&& rm -rf clang-tools-extra-5.0.0.src.tar.xz

	cd ../../../../
	cd llvm/projects/
	wget http://releases.llvm.org/5.0.0/compiler-rt-5.0.0.src.tar.xz
	tar xf compiler-rt-5.0.0.src.tar.xz &&  mv compiler-rt-5.0.0.src compiler-rt \
		&& rm -rf compiler-rt-5.0.0.src.tar.xz
	cd ../../build/

	cmake ../llvm -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release

	make -j4
	sudo make install
	clang --version
```
### clone所需要的vim插件
```bash 
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

	cd ~/.vim
	git clone https://github.com/kien/ctrlp.vim.git bundle/ctrlp.vim
	
	cd ~/.vim/bundle
	git clone --recursive https://github.com/Valloric/YouCompleteMe.git
	# YCM 的顶层目录或者说根目录是 ~/.vim/bundle/YouCompleteMe
	cd YouCompleteMe
	# 检查完整性
	git submodule update --init --recursive

```

    
### 安装vim插件

- YouCompleteMe插件的安装
```bash 
	# 编译构建 ycm_core 库
	mkdir ~/.ycm_build && cd ~/.ycm_build
	# DPATH_TO_LLVM_ROOT该目录下有 bin, lib, include 等文件夹
	cmake -G "Unix Makefiles" -DPATH_TO_LLVM_ROOT=~/llvm-package/build . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
	# 构建 ycm_core
	cmake --build . --target ycm_core --config Release

	# 安装 YouCompleteMe 
	cd ~/.vim/bundle/YouCompleteMe

	# 在编译之前修改对应的python版本
	which python3
	# /home/femn/anaconda3/bin/python3
	vim install.sh 
		改变python解释器对应的版本,我将python2改成了python3
		# Found Python library: /home/femn/anaconda3/lib/libpython3.6m.so
		# 默认python2是/usr/lib/python2.7/config-x86_64-linux-gnu/libpython2.7.so

	# 编译 ycm_core
	./install.sh --clang-completer --gocode-completer


	# 配置.ycm_extra_conf.py文件
	cp ~/.vim/bundle/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py ~/.vim/
	# 再添加.vimrc配置 
	# 注意下面的 python 解释器的路径要和编译 ycm_core 的时候使用的 python 解释器是相同的版本（2 或 3）
	let g:ycm_server_python_interpreter='/home/femn/anaconda3/bin/python3'
	let g:ycm_global_ycm_extra_conf='~/.vim/.ycm_extra_conf.py'"

```
- 其它插件的安装[~/.vimrc](./vimrc)
```bash 
	# mv vimrc ~/.vimrc
	# 将.vimrc配置好之后
	sudo vim +PlugInstall +qall
	# 此时的~/.vim/目录下就已经安装好所有的插件了.
```
- 查看 YouCompleteMe是否安装成功
```bash 
	# vim 中运行任何一个都行
	:YcmToggleLogs stderr
	:YcmDiags
```
#### 一些常用的基本操作(vim命令下)

```bash 
    F3(Plug 'scrooloose/nerdtree') # 打开左侧的文件树,相当于是分割窗口了,<ctrl-w>w进行转换
    F4(Plug 'majutsushi/tagbar') # 导航栏,也相当于分割窗口
    [N]<ctrl-w>< # > # 改变窗口的宽度
    F8(Plug 'tell-k/vim-autopep8') # 自动格式化代码 F8
    ctrl+/ # 注释代码
    F5 # 运行测试
    :help :Git (Plug 'tpope/vim-fugitive') # 查看Git 集成命令
	# 调整窗口大小启动/停用鼠标
	:set mouse=a
	:set mouse-=a

    zo 展开
    zc 收到
    zn 全部展开
    zN 全部折叠
```

#### 使用ctage

```bash 
    # 手动创建索引
	cd ~/app1.6
	ctags -R *
	# 也可以用!cd /home/python/app1.6 && ctags -R *
    # 好像没有递归子目录，所以为子目录创建索引
    cd main && ctags -R *
    cd ../app1.6 #必须要cd到此目录或者 main目录下，可由 :set tags 查看
    vim runner.py
	<c+]> # 跳转到定义处
	<c+t> # 返回到引用处
    # 这样本地的所有代码，都正确的创建了索引,但源代码还是没有办法创建索引
```


#### F3打开导航树时 可选择的操作

    o       在已有窗口中打开文件、目录或书签，并跳到该窗口
    go      在已有窗口 中打开文件、目录或书签，但不跳到该窗口
    t       在新 Tab 中打开选中文件/书签，并跳到新 Tab
    T       在新 Tab 中打开选中文件/书签，但不跳到新 Tab
    i       split 一个新窗口打开选中文件，并跳到该窗口
    gi      split 一个新窗口打开选中文件，但不跳到该窗口
    s       vsplit 一个新窗口打开选中文件，并跳到该窗口
    gs      vsplit 一个新 窗口打开选中文件，但不跳到该窗口
    !       执行当前文件
    O       递归打开选中 结点下的所有目录
    x       合拢选中结点的父目录
    X       递归 合拢选中结点下的所有目录
    e       Edit the current dif

    双击    相当于 NERDTree-o
    中键    对文件相当于 NERDTree-i，对目录相当于 NERDTree-e

    D       删除当前书签

    P       跳到根结点
    p       跳到父结点
    K       跳到当前目录下同级的第一个结点
    J       跳到当前目录下同级的最后一个结点
    k       跳到当前目录下同级的前一个结点
    j       跳到当前目录下同级的后一个结点

    C       将选中目录或选中文件的父目录设为根结点
    u       将当前根结点的父目录设为根目录，并变成合拢原根结点
    U       将当前根结点的父目录设为根目录，但保持展开原根结点
    r       递归刷新选中目录
    R       递归刷新根结点
    m       显示文件系统菜单 #！！！然后根据提示进行文件的操作如新建，重命名等
    cd      将 CWD 设为选中目录

    I       切换是否显示隐藏文件
    f       切换是否使用文件过滤器
    F       切换是否显示文件
    B       切换是否显示书签

    q       关闭 NerdTree 窗口
    ?       切换是否显示 Quick Help

#### ctrlp重新定义打目录和文件方式，特别适用于大规模项目文件的浏览
	
- 启用ctrlp(在vim命令下)
```bash 
	:CtrlP或:CtrlP [starting-directory] # 来以查找文件模式来启用ctrlp
	:CtrlPBuffer或:CtrlPMRU # 来以查找缓冲或最近打开文件模式来启用ctrlp
	:CtrlPMixed# 来查找文件、查找缓冲和最近打开文件混合模式来启动 ctrlp
	
```
- 基本使用(在vim命令下)

```bash 
	<c-f> 和<c-b> #在三种查找模式中互相切换
	<c-y> # 来创建新文件和对应的父目录
	<c-d> # 来切换到只查找文件名而不是全路径
	<c-j>，<c-k> # 或箭头方向键来移动查找结果列表
	<c-t>或<c-v>，<c-x> # 来以新标签或分割窗口的方式来打开文件
	<c-z> # 来标识或取消标识文件，然后按<c-o>  来打开文件
	<c-n>，<c-p> # 来在提示历史中选择下一个/上一个字符串

```
