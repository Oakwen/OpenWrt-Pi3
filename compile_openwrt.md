
# 编译lede_openwrt过程记录

## 1. 配置编译环境

```bash
sudo apt-get update

sudo apt-get install mkisofs build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3.5 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf

sudo apt-get autoremove --purge

sudo apt-get clean
```

## 2. git clone 代码

```bash
git clone https://github.com/coolsnowwolf/lede

cd lede

./scripts/feeds update -a

./scripts/feeds install -a
```

## 3. 配置文件

```bash
cd lede

curl -fsSL https://raw.githubusercontent.com/1orz/My-action/master/lean-lede/rpi/.config >.config

#./lede/package/openwrt-packages 文件夹内文件需删除
bash <(curl -fsSL https://raw.githubusercontent.com/1orz/My-action/master/lean-lede/diy.sh)

./scripts/feeds install -a

make defconfig
```

需要修改配置则运行：

```bash
make menuconfig
```

增加 htop，vim

## 4. 下载dl库，尽量全局科学上网

```bash
cd lede

make download -j8

find dl -size -1024c -exec ls -l {} \;

find dl -size -1024c -exec rm -f {} \;
```

## 5. 多线程编译

```bash
cd lede

echo -e "$(nproc) thread compile"

df -h

make -j$(nproc)

df -h
```

## 6. 单线程编译

```bash
df -h

cd lede

make -j1 V=s

df -h
```

## 7. 二次编译

```bash
cd lede

git pull

./scripts/feeds update -a && ./scripts/feeds install -a

make defconfig

make -j8 download

make -j$(($(nproc) + 1)) V=s
```

## 8. 二次编译（需要重新配置）

```bash
rm -rf ./tmp && rm -rf .config

make menuconfig

make -j$(($(nproc) + 1)) V=s
```
