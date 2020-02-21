FROM debian

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN apt update && apt install -y git  zsh curl wget vim tar g++ python
RUN apt-get update -y && apt-get install -y libncurses5-dev libx11-dev libxpm-dev libxt-dev libatk1.0-dev gettext gawk make ripgrep    python-dev python3-dev
RUN apt update && apt install -y pkg-config autoconf automake python3-docutils libseccomp-dev \
    libjansson-dev \
    libyaml-dev \
    libxml2-dev
RUN apt-get remove -y vim vim-runtime gvim

# vim
COPY ./vimrc /root/.vimrc
RUN mkdir /root/.vim/
RUN mkdir /root/.vim/autoload/
COPY ./plug.vim /root/.vim/autoload
COPY ./vim.xz /tmp
RUN tar -C /tmp -xf  /tmp/vim.xz
WORKDIR /tmp/vim
RUN ./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp \
            --enable-python3interp \
            --enable-pythoninterp \
            --with-python3-config-dir=/usr/lib/python3.7/config-3.7m-x86_64-linux-gnu/ \
            --enable-perlinterp \
            --enable-luainterp \
            --enable-cscope --prefix=/usr
RUN make -j2
RUN make install


# ctags
COPY ./ctags.gz /tmp
RUN tar -C /tmp -xzf  /tmp/ctags.gz
WORKDIR /tmp/ctags
RUN ./autogen.sh
RUN ./configure
RUN make -j2
RUN make install


# ohmyzsh
COPY ./oh-my-zsh-autojump.gz /tmp
RUN tar -C /tmp -xzf  /tmp/oh-my-zsh-autojump.gz

WORKDIR /tmp/ohtojump
RUN export SHELL=/bin/zsh; sh install.sh
RUN echo "[[ -s /root/.autojump/etc/profile.d/autojump.sh ]] && source /root/.autojump/etc/profile.d/autojump.sh" >> ~/.zshrc

