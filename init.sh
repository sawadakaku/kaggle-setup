#!/bin/bash

# utils
cd ~/
mkdir proj lib
sudo apt-get update
sudo apt-get install -y git build-essential libatlas-base-dev
sudo apt-get install -y vim-gnome mosh tmux htop p7zip-full
sudo apt-get install -y python3-dev
git config --global credential.helper 'cache --timeout=3600'
git config --global user.email "kaku.sawada.ak@gmail.com"
git config --global user.name "Sawada Kaku"

# anaconda
# http://stuarteberg.github.io/conda-docs/help/silent.html
if ! [ -d ~/anaconda3/ ]; then
    wget --quiet https://repo.continuum.io/archive/Anaconda3-5.0.0-Linux-x86_64.sh -O lib/anaconda.sh
    /bin/bash lib/anaconda.sh -b
fi

if ! [ `echo $PATH | grep 'anaconda3/bin'` ] ; then
    echo export PATH=~/anaconda3/bin:$PATH >> ~/.bashrc
fi

shopt -s expand_aliases
source ~/.bashrc
# export PATH=~/anaconda3/bin:$PATH

pip install xgboost
pip install lightgbm
pip install tensorflow
pip install keras
pip install hyperopt

# set backend for matplotlib to Agg
matplotlibrc_path=$(python -c "import site, os, fileinput; packages_dir = site.getsitepackages()[0]; print(os.path.join(packages_dir, 'matplotlib', 'mpl-data', 'matplotlibrc'))") && \
sed -i 's/^backend      : qt5agg/backend      : agg/' $matplotlibrc_path

# install gensim(word2vec is slow?)
pip install gensim

cd

# setup dotfile
git clone git://github.com/sawadakaku/dotfiles.git

mkdir ~/.vim
mkdir ~/.vim/ftplugin
mkdir ~/.vim/dict

pythonset="python3 << EOF
import os
import sys

path = os.path.expanduser(\"~/anaconda3/lib/python3.6/site-packages\")
if not path in sys.path:
    sys.path.append(path)
EOF"

echo "$pythonset" > ~/.vim/ftplugin/python.vim

ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.gitignore_global ~/.gitignore_global
ln -sf ~/dotfiles/dict  ~/.vim/dict

head -n 3 ~/dotfiles/.gitconfig tmp
mv tmp ~/dotfiles/.gitconfig
