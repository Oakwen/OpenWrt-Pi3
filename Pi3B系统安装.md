# Pi3B 系统安装过程

### 1. 安装OPENFANS的x64镜像

从 [树莓派爱好者基地](https://github.com/openfans-community-offical) 下载‘无桌面增强版’，用‘rufus’刷入镜像。

### 2. 系统基本设置

#### 2.1 SSH登陆
通过SSH登陆，默认用户名```pi```，默认密码```raspberry```。先修改密码。
更新一下系统和软件。

    sudo apt update && sudo apt upgrade -y

#### 2.2 配置代理

配置git代理

    git config --global http.proxy 'socks5://192.168.8.188:1080'
    git config --global https.proxy 'socks5://192.168.8.188:1080'

    或者：
    git config --global http.proxy 'http://192.168.8.188:1081'
    git config --global https.proxy 'https://192.168.8.188:1081'

配置shell代理，```nano ~/.bashrc```，在文件最后加入：

    export https_proxy="http://192.168.8.188:1081"
    export http_proxy="http://192.168.8.188:1081"
    export all_proxy="socks5://192.168.8.188:1080"

使配置立即生效：

    source ~/.bashrc

**主机V2rayN软件要打开 “允许来自局域网的连接” ，并打开全局代理模式**

#### 2.3 安装oh_my_zsh

    sudo apt install zsh

    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    plugins=( git zsh-autosuggestions zsh-syntax-highlighting )

#### 2.4 登陆CecOS容器云平台
登陆 [CecOS容器云平台](https://192.168.8.151:8443/)，默认用户名```admin```，默认密码```password```，登录后先修改密码。