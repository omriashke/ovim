FROM debian:12

WORKDIR /tmp

# git
COPY ./git/git-install.sh ./git-install.sh

RUN chmod +x ./git-install.sh && ./git-install.sh

# neovim
COPY ./neovim/neovim-install.sh ./neovim-install.sh

RUN chmod +x ./neovim-install.sh && ./neovim-install.sh

RUN mkdir -p /root/.config/nvim

COPY ./neovim/lua /root/.config/nvim/lua

COPY ./neovim/init.lua /root/.config/nvim/init.lua

RUN nvim --headless -c "lua require('omriashkenazi.packer')" -c "autocmd User PackerComplete quitall" -c "PackerSync"

RUN nvim --headless -c "MasonInstall lua-language-server typescript-language-server js-debug-adapter" -c "qa"

COPY ./neovim/after /root/.config/nvim/after

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

RUN find /tmp -mindepth 1 -delete

# app integrations
COPY ./compose/customCompose.sh /root/.config/customCompose.sh

RUN chmod +x /root/.config/customCompose.sh

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
