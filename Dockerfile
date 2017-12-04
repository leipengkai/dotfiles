FROM python:latest
MAINTAINER leipengkai (https://github.com/leipengkai/)

RUN apt-get update \
    && apt-get --force-yes install -y curl vim exuberant-ctags git ack-grep vim-nox \
    && apt-get install -y python-flake8 python3-flake8 flake flake8 python-autopep8 python3-jedi \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN pip install pep8 flake8 pyflakes isort yapf 


ADD vim/vimrc /root/.vimrc 
RUN timeout 5m vim || true

CMD ["vim","/src"]
# Currently only available in the VIM environment, there is a Dockerfile with a test, later on for the overall environment

# 运行
# alias vim-python='docker run -it --rm -v $(pwd):/src femn/vim_python'
# vim-python # 需要下载镜像，可能会比较慢
# # 打开的vim的文件管理系统，选择需要编辑的文件既可
# # 编辑时 会在容器的/src/下编辑，保存退出之后，会保存到主机的$(PWD)目录下
