FROM debian:bookworm-slim

WORKDIR /tmp

# dependecies
COPY ./dependecies/install.sh ./install.sh

RUN chmod +x ./install.sh && ./install.sh

RUN mkdir -p /root/.config/nvim

COPY ./neovim/lua /root/.config/nvim/lua

COPY ./neovim/init.lua /root/.config/nvim/init.lua

RUN nvim --headless -c "lua require('omriashkenazi.packer')" -c "autocmd User PackerComplete quitall" -c "PackerSync"

COPY ./neovim/after /root/.config/nvim/after

# tmux
RUN mkdir -p /root/.config/tmux

COPY tmux/tmux.conf /root/.config/tmux/tmux.conf

RUN /root/.tmux/plugins/tpm/scripts/install_plugins.sh

RUN find /tmp -mindepth 1 -delete

# build
COPY ./dependecies/build.sh ./build.sh

RUN chmod +x ./build.sh && ./build.sh

# app integrations
COPY ./compose/customCompose.sh /root/.config/customCompose.sh

RUN chmod +x /root/.config/customCompose.sh

WORKDIR /root

RUN apt-get update && apt-get install -y bash locales && \
    sed -i 's/^# *\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen

COPY .env /root/.env

COPY .bashrc /root/.bashrc

SHELL ["/bin/bash", "-c"]

ENV TERM=xterm-256color
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

CMD ["bash"]
