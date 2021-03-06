
# 终端复用工具[tmux](https://github.com/tmux/tmux)
tmux采用C/S模型构建，输入tmux命令就相当于开启了一个服务器，此时默认将新建一个会话，然后会话中默认新建一个窗口，窗口中默认新建一个面板

1. Session:会话，tmux使用会话管理不同任务，你可以创建用于work的会话、或者用于play的会话，随时可以切换不同的会话。
2. Window:窗口，tmux会话可以包含多个窗口，每个窗口都是一个完整的终端。
3. Pane:面板，窗口可以切分出任意数量、任意大小的面板，每个面板均是一个shell终端。

一个tmux session（会话）可以包含多个window（窗口），窗口默认充满会话界面，因此这些窗口中可以运行相关性不大的任务。
一个window又可以包含多个pane（面板），窗口下的面板，都处于同一界面下，这些面板适合运行相关性高的任务，以便同时观察到它们的运行情况。


## 安装tmux(脚本中已经安装)
```bash
    sudo apt install tmux xsel xclip

	# 使得进入shell时，自动 挂载/启动 到tmux,在.bashrc文件在添加
		tmux_init()
		{
			tmux new-session -s kumu -d -n local    # 开启一个会话
			tmux new-window -n other          # 开启一个窗口
			tmux split-window -h                # 开启一个竖屏
			#tmux split-window -v top          # 开启一个横屏,并执行top命令
			tmux select-window -t 1
			tmux -2 attach-session -d           # tmux -2强制启用256color，连接已开启的tmux
		}
		# 判断是否已有开启的tmux会话，没有则开启
		if which tmux 2>&1 >/dev/null; then
			test -z $TMUX && (tmux attach || tmux_init)
		fi
	
	# 为了在tmux环境中使用.bashrc的环境变量
	# 在 .profile在加上
	. ~/.bashrc
```
## 安装插件处理器[TPM](https://github.com/tmux-plugins/tpm)
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    tmux # 进入tmux环境

## 重新加载配置文件[~/tmux.conf](./tmux.conf) 注意本人的<prefix> = ctrl+a
    tmux source-file ~/.tmux.conf
    # 进入到命令模式后输入source-file ~/.tmux.conf，回车后生效
    # 在tmux环境下 <prefix>+r
    <prefix> + I # 安装需要的插件

## tmux基本用法
查看插件
	ls ~/.tmux/plugins/

在tmux环境中 升级所有插件

	<prefix> + U

创建会话(shell环境中)

    tmux # 新建一个无名称的会话,默认是0
    tmux new -s demo # 新建一个名称为demo的会话
断开会话(tmux环境中)

    tmux detach # 断开当前会话，会话在后台运行
    Ctrl+x + d # 或使用快捷键组合
进入会话(shell)

    tmux a # 默认进入第一个会话
    tmux a -t demo # 进入到名称为demo的会话
关闭会话(shell or tmux)

    tmux kill-session -t demo # 关闭demo会话
    tmux kill-server # 关闭服务器，所有的会话都将关闭
    kill命令有kill-pane、kill-server、kill-session 和 kill-window四种
查看所有的会话(shell or tmux)

    tmux ls

## Tmux快捷指令

### 系统命令

    prefix ?	列出所有快捷键；按q返回
    prefix d	脱离当前会话,可暂时返回Shell界面，输入tmux attach能够重新进入之前会话
    prefix s	选择并切换会话；在同时开启了多个会话时使用
    prefix D	选择要脱离的会话；在同时开启了多个会话时使用
    prefix :	进入命令行模式；此时可输入支持的命令，例如kill-server所有tmux会话
    prefix [	复制模式，光标移动到复制内容位置，空格键开始，方向键选择复制，回车确认，q/Esc退出
    prefix ]	进入粘贴模式，粘贴之前复制的内容，按q/Esc退出
    prefix ~	列出提示信息缓存；其中包含了之前tmux返回的各种提示信息
    prefix t	显示当前的时间
    prefix Ctrl+z	挂起当前会话

### 窗口（window）指令

    prefix c	创建新窗口
    prefix &	关闭当前窗口
    prefix 数字键	切换到指定窗口
    prefix p	切换至上一窗口
    prefix n	切换至下一窗口
    prefix l	前后窗口间互相切换
    prefix w	通过窗口列表切换窗口
    prefix ,	重命名当前窗口，便于识别
    prefix .	修改当前窗口编号，相当于重新排序
    prefix f	在所有窗口中查找关键词，便于窗口多了切换

### 面板（pane）指令

    prefix -	将当前面板上下分屏
    prefix |	将当前面板左右分屏
    prefix x	关闭当前分屏
    prefix !	将当前面板置于新窗口,即新建一个窗口,其中仅包含当前面板
    prefix Ctrl+方向键	以1个单元格为单位移动边缘以调整当前面板大小
    prefix Alt+方向键	以5个单元格为单位移动边缘以调整当前面板大小
    prefix 空格键	可以在默认面板布局中切换，试试就知道了
    prefix q	显示面板编号
    prefix o	选择当前窗口中下一个面板
    prefix 方向键	移动光标选择对应面板
    prefix {	向前置换当前面板  
    prefix }	向后置换当前面板
    prefix Alt+o	逆时针旋转当前窗口的面板
    prefix Ctrl+o	顺时针旋转当前窗口的面板
    prefix z	tmux 1.8新特性，最大化当前所在面板,再重复一次按键后恢复正常
    prefix ;   切换到最后一次使用的面板   

	# tmux之间的复制
	# $ sudo apt-get install xsel xclip
	prefix [ 进入选择模式
	点击v键进入vi-mode选择模式,VIM的移动命令进行选择
	选择完毕后用y复制到tmux剪贴板
	prefix ] 复制到光标所在位置
	q 退出

### 使用[tmux-yank](https://github.com/tmux-plugins/tmux-yank)

	普通模式下:
	<prefix> + y #把当前命令行的内容拷到剪切板（支持bash,zsh,python解释器；稍加配置还支持vim命令栏）
	<prefix> + Y #把当前面板的路径拷到剪切板
	选择模式下:

	y # 把当前选中的内容拷到剪切板
	Y # 把当前选中的内容拷到剪切板，然后再粘到命令行（退出tmux选择模式后会看到zsh提示符后已经粘好内容了，直接敲回车就可以执行）
	# 本人使用的时候有bug,所以没有安装
### 使用tmux-resurrect:系统重启之后比较容易地恢复tmux session 
	prefix Ctrl-s       # save tmux session to local file
	prefix Ctrl-r       # reload tmux session from local file
	值得注意的是，恢复后，原窗口中的进程会被杀掉。如果你是重启后恢复，那自然没什么问题，但是平时试验的时候可要留心有没有重要的任务正在运行中

