#!/bin/bash

# utils
cd ~/
mkdir proj lib
sudo apt-get update
sudo apt-get install -y git build-essential libatlas-base-dev
sudo apt-get install -y vim-gnome mosh tmux htop p7zip-full
sudo apt-get install -y python3-dev
git config --global credential.helper 'cache --timeout=3600'

# anaconda
# http://stuarteberg.github.io/conda-docs/help/silent.html
if ! [ -d ~/anaconda3/ ]; then
    wget --quiet https://repo.continuum.io/archive/Anaconda3-5.3.1-Linux-x86_64.sh -O lib/anaconda.sh
    /bin/bash lib/anaconda.sh -b
fi

if ! [ `echo $PATH | grep 'anaconda3/bin'` ] ; then
    echo export PATH=~/anaconda3/bin:$PATH >> ~/.bashrc
fi

shopt -s expand_aliases
source ~/.bashrc
# export PATH=~/anaconda3/bin:$PATH

python3 -m pip install \
    boto3 \
    catboost \
    eli5 \
    fastFM \
    flake8 \
    gensim \
    google-cloud-bigquery \
    h5py \
    hyperopt \
    jedi \
    joblib \
    jupyter \
    jupyterthemes \
    keras \
    lightgbm \
    matplotlib \
    networkx==1.11 \
    nltk \
    numpy \
    opencv-python \
    optuna \
    pandas \
    pillow \
    pydot_ng \
    scikit-learn \
    scipy \
    seaborn \
    shap \
    sympy \
    tensorboardX \
    tensorflow \
    torch \
    torchvision \
    tqdm \
    xgboost \


# set backend for matplotlib to Agg
matplotlibrc_path=$(python -c "import site, os, fileinput; packages_dir = site.getsitepackages()[0]; print(os.path.join(packages_dir, 'matplotlib', 'mpl-data', 'matplotlibrc'))") && \
sed -i 's/^backend      : qt5agg/backend      : agg/' $matplotlibrc_path


# setup dotfile
cd
git clone git://github.com/sawadakaku/dotfiles.git

cd ~/dotfiles
make tmux.conf
make bash

pythonset="python3 << EOF
import os
import sys

path = os.path.expanduser(\"~/anaconda3/lib/python3.7/site-packages\")
if not path in sys.path:
    sys.path.append(path)
EOF"

echo "$pythonset" > ~/.vim/ftplugin/python.vim

if grep '\[url "github:"\]' ~/dotfiles/.gitconfig > /dev/null; then
    head -n 3 ~/dotfiles/.gitconfig > tmp
    mv tmp ~/dotfiles/.gitconfig
fi
