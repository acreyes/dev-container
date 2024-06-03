ARG img=ubuntu:22.04
FROM $img as base

######################
## dependencies will need 
### cmake + gcc for neovim
### stow to install configs
### zsh .... ohmyzsh
### ripgrep 


# this could be put inside of a script that checks for the OS and uses
# the appropriate package mangager to install these....
# for now I always use ubuntu
RUN apt-get update && \
    apt-get install -yq \
            cmake \
            gcc \
            git \
            stow \
            ripgrep \
            zsh  \
            curl \
            gettext \
            tmux


## neovim
FROM base as nvim
RUN git clone -b stable https://github.com/neovim/neovim.git && \
       cd neovim && \
       make CMAKE_BUILD_TYPE=RelWithDebInfo && \
       make install

FROM nvim as dotfile
RUN useradd -m -G sudo -s $(which zsh) main
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
USER main
WORKDIR /home/main
RUN git clone https://github.com/acreyes/.dotfiles.git && \
    cd .dotfiles && \
    ./install.sh && \
    cd /home/main


ENTRYPOINT ["/usr/bin/zsh"]




