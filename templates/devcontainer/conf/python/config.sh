#!/bin/bash
set -x

# vscode extensions
# declare -a exts=(
#     ms-python.python
#     ms-python.vscode-pylance
# )
# for ext in "${exts[@]}"; do
#     code --install-extension "$ext"
# done

# config
CUR_DIR=$(dirname "${BASH_SOURCE[0]}")
source ${SCRIPT_DIR}/helper.sh
# merge_vsconf "${CUR_DIR}/vscode/*" "${WORKSPACE_DIR}/.vscode"

CONDA_VERSION=latest
#MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh"
MINICONDA_URL="https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh"
wget "${MINICONDA_URL}" -O miniconda.sh
bash miniconda.sh -ub -p $HOME/.conda
rm miniconda.sh
# curl -sSf ${MINICONDA_URL} | bash -s -- -b -p $HOME/miniconda
find $HOME/.conda -follow -type f -name '*.a' -delete
find $HOME/.conda -follow -type f -name '*.js.map' -delete

safe_link ${CUR_DIR}/.condarc ${HOME}/.condarc
source $HOME/.conda/etc/profile.d/conda.sh
conda clean -afy
conda init zsh

conda create -y -n jupyter python=3.8 # 创建jupyter环境
conda activate jupyter # 进入该环境
conda install -y jupyter notebook # 安装Jupyter包
conda install -y nb_conda_kernels
conda install -y ipykernel

# 安装 jupyter_contrib_nbextensions (python包)
conda install -y -c conda-forge jupyter_contrib_nbextensions
# 安装 nbextension 插件(javascript and css files)
jupyter contrib nbextension install --user

# 安装nbextensions_configurator
conda install -y -c conda-forge jupyter_nbextensions_configurator
# 安装Jupyter插件
jupyter nbextensions_configurator enable --user
# Hinterland：代码补全
# Table of Contents (2) ：添加目录——通过markdown文件自动生成目录，可以快速跳转
# Code prettify：PEP8规范优化代码
# Codefolding：代码折叠——折叠不需要展示的代码
# Highlighter：Markdown文本高亮