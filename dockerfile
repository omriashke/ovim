FROM debian:12

WORKDIR /tmp

# git
COPY ./git/git-install.sh ./git-install.sh

RUN chmod +x ./git-install.sh && ./git-install.sh

# dependecies
COPY ./dependecies/default.sh ./default.sh

RUN chmod +x ./default.sh && ./default.sh

# docker
COPY ./docker/docker-install.sh ./docker-install.sh

RUN chmod +x ./docker-install.sh && ./docker-install.sh

# tmux
RUN mkdir -p /root/.config/tmux

COPY ./tmux/tmux-install.sh ./tmux-install.sh

RUN chmod +x ./tmux-install.sh && ./tmux-install.sh

COPY tmux/tmux.conf /root/.config/tmux/tmux.conf

RUN /root/.tmux/plugins/tpm/scripts/install_plugins.sh

# neovim
RUN mkdir -p /root/.config/nvim

COPY ./neovim/neovim-install.sh ./neovim-install.sh

COPY ./neovim/lua /root/.config/nvim/lua

COPY ./neovim/init.lua /root/.config/nvim/init.lua

RUN chmod +x ./neovim-install.sh && ./neovim-install.sh

RUN nvim --headless -c "lua require('omriashkenazi.packer')" -c "autocmd User PackerComplete quitall" -c "PackerSync"

COPY ./neovim/after /root/.config/nvim/after

WORKDIR /root

RUN apt update && apt install -y bash locales && \
    sed -i 's/^# *\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen

COPY .bashrc /root/.bashrc

SHELL ["/bin/bash", "-c"]

ENV TERM xterm-256color
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

CMD ["bash"]
