# LEDE-OpenWRT

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/Oakwen/openwrt/OpenWRT_Pi?label=OpenWRT_Pi&style=plastic)    ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/Oakwen/openwrt/OpenWRT_RM2100?label=OpenWRT_RM2100&style=plastic)    ![GitHub commit activity](https://img.shields.io/github/commit-activity/w/Oakwen/OpenWRT)


编译LEDE的openwrt固件，树莓派3B和红米2100专用。

---

## 感谢 [Lean](https://github.com/coolsnowwolf/lede) 的源码

以下内容来自 [Lean](https://github.com/coolsnowwolf/lede) 的 OpenWRT源码仓库。

### 注意

1. **不**要用 **root** 用户 git 和编译！！！
2. 国内用户编译前最好准备好梯子
3. 默认登陆IP 192.168.1.1, 密码 password

### 编译命令如下

#### 1. 首先装好 Ubuntu 64bit，推荐  Ubuntu  18 LTS x64

#### 2. 命令行输入 `sudo apt-get update` ，然后输入

```bash
sudo apt-get -y install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3.5 python2.7 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf
```

#### 3. 使用 `git clone https://github.com/coolsnowwolf/lede` 命令下载好源代码，然后 `cd lede` 进入目录

#### 4. 自定义配置

```bash
   ./scripts/feeds update -a
   ./scripts/feeds install -a
   make menuconfig
   ```

#### 5. `make -j8 download V=s` 下载dl库（国内请尽量全局科学上网）

#### 6. 输入 `make -j1 V=s` （-j1 后面是线程数。第一次编译推荐用单线程）即可开始编译你要的固件了

本套代码保证肯定可以编译成功。里面包括了 R20 所有源代码，包括 IPK 的。

你可以自由使用，但源码编译二次发布请注明[我的 GitHub 仓库链接](https://github.com/coolsnowwolf/lede)。谢谢合作！

### 二次编译

```bash
cd lede
git pull
./scripts/feeds update -a && ./scripts/feeds install -a
make defconfig
make -j8 download
make -j$(($(nproc) + 1)) V=s
```

### 如果需要重新配置

```bash
rm -rf ./tmp && rm -rf .config
make menuconfig
make -j$(($(nproc) + 1)) V=s
```

编译完成后输出路径：/lede/bin/targets

---

### 感谢 [1orz](https://github.com/1orz/My-action) 的编译脚本

固件可以直接去 1orz 的站点下载。

下载地址：[https://down.ssrc.win/Router/](https://down.ssrc.win/Router/)

目前文件下载服务器坐落在日本。部分用户访问会缓慢。请开全局代理下载。

---

#### 在仓库 [Openwrt](https://github.com/Oakwen/Openwrt) 中，有配合Github Actions在线编译的配置文件。在线编译在私人仓库 [Openwrt_Pi](https://github.com/Oakwen/Openwrt_Pi) 中完成
