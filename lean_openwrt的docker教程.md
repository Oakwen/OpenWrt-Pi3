# Lean_Openwrt固件docker教程

通过SSH登陆树莓派之后，进行如下设置：

## 1. 打开网卡混杂模式

```bash
sudo ip link set eth0 promisc on
```

## 2. 创建网络

根据树莓派所处的网络环境来修改

```bash
docker network create -d macvlan --subnet=192.168.8.0/24 --gateway=192.168.8.8 -o parent=eth0 macnet
```

此时，我们使用 ```docker network ls``` 命令可以看到网络macnet已建立成功：

```bash
➜  ~ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
1fc3e04b1fb0        bridge              bridge              local
36edda857271        docker_gwbridge     bridge              local
02c5e6342a19        host                host                local
mbb38zqiyrlw        ingress             overlay             swarm
33754810fabb        macnet              macvlan             local
dd8bb95bd9bd        none                null                local
```

## 3. 建立以及启动容器

### 3.1 创建volume和容器镜像

创建volume，导入dcker镜像

```bash
docker volume create downloads-volume

docker import openwrt-bcm27xx-bcm2710-rpi-3-rootfs.tar.gz lean_openwrt
```

### 3.2 启动容器

* 启动容器

```bash
docker run -it -d --restart always --network macnet --privileged --name openwrt lean_openwrt /sbin/init
```

* 启动容器和volume

```bash
docker run -it --mount type=volume,source=downloads-volume,target=/root/downloads -d --restart always --network macnet --privileged --name openwrt lean_openwrt /sbin/init
```

其中：

```--restart always``` 参数表示容器退出时始终重启，使服务尽量保持始终可用；

```--name openwrt``` 参数定义了容器的名称；

```-d``` 参数定义使容器运行在 Daemon 模式；

```--network macnet``` 参数定义将容器加入 maxnet网络；

```--privileged``` 参数定义容器运行在特权模式下；

```lean_openwrt为``` Docker 镜像名

```/sbin/init``` 定义容器启动后执行的命令。

启动容器后，我们可以使用```docker ps -a``` 命令查看当前运行的容器：

```bash
➜  ~ docker ps -a
CONTAINER ID    IMAGE                   COMMAND             CREATED             STATUS       PORTS   NAMES
0c4f49b77bc2    tianwen_lean_openwrt    "/sbin/init"        2 hours ago         Up 2 hours           tianwen_openwrt
```

若容器运行信息STATUS列为 UP状态，则说明容器运行正常。

## 4. 进入容器并修改Openwrt配置

### 4.1 进入容器

```bash
docker exec -it openwrt /bin/sh
```

其中：

openwrt为容器名称；

bash为进入容器后执行的命令。

执行此命令后我们便进入 OpenWrt 的命令行界面。

### 4.2 编辑/etc/config/network

```bash
vi /etc/config/network
```

需要修改LAN口参数：

```bash
config interface 'lan'
    option type 'bridge'
    option ifname 'eth0'
    option proto 'static'
    option ipaddr '192.168.8.100'
    option netmask '255.255.255.0'
    option ip6assign '60'
    option gateway '192.168.8.8'
    option broadcast '192.168.8.255'
    option dns '192.168.8.8'
```

```option ipaddr``` 项目定义了 OpenWrt 的 IP 地址，在完成网段设置后，IP最后一段可根据自己的爱好修改（前提是符合规则且不和现有已分配 IP 冲突）。

#### 在原文件基础上，只修改ipaddr的值，网关、广播和dns地址通过网页修改

### 4.3 检查/etc/resolv.conf配置

如果出现Ping IP正常，不能Ping域名，就要检查/etc/resolv.conf的配置是否正确。

```bash
/ # cat /etc/resolv.conf
#nameserver 127.0.0.11
#nameserver 8.8.8.8
nameserver 192.168.8.8
```

使用下面的方法来自动设置resolv.conf
在openwrt系统中，修改rc.local开机启动代码：
```vi /etc/rc.local```

```bash
# Fix Luci, Don't remove !!
umount /etc/resolv.conf
rm /etc/resolv.conf
ln -s /tmp/resolv.conf.auto /etc/resolv.conf
```

```vi /tmp/resolv.conf.auto```

```bash
# Interface lan
nameserver 192.168.8.8
```

## 5. 重启Openwrt网络

```bash
/etc/init.d/network restart
```

## 6. 进入控制面板

在浏览器中输入第 4.2 步```option ipaddr``` 项目中的 IP 进入 Luci 控制面板，若```option ipaddr``` 的参数为 192.168.8.100，则可以在浏览器输入[Openwrt控制面板](http://192.168.8.100)。

用户名：```root```

密码：```password```

### 登录之后第一时间修改密码

## 7. 关闭DHCP服务

在 “网络 - 接口 - Lan - 修改” 界面中，勾选下方的 “忽略此接口（不在此接口提供 DHCP 服务）”，并“保存&应用”。
![关闭DHCP服务](https://github.com/Oakwen/Openwrt-Pi3/raw/master/images/shutdown_dhcp.png)

## 8. 主路由DHCP设置

进入路由器后台中，将主路由的 DHCP 的默认网关和 DNS 服务器设置为第 4.25 步中```option ipaddr``` 项目中的 IP。

![主路由dhcp设置](https://raw.githubusercontent.com/Oakwen/Openwrt-Pi3/master/images/main_router_dhcp_setting.png)

**在梅林固件中，开启科学上网的情况下，DNS设置不生效！**

## 9. 重新连接路由器

完成以上操作后，断开设备（如手机，电脑）与路由器的连接，重新连接路由器，连接路由器的设备将获取到我们设置到的 IP。

## 10. 其他修复

### 10.1 关闭WLAN硬件加速

设置旁路路由后，若出现访问国内网站网速慢，不稳定的情况（多见于 Pandavan 及其改版固件，如华硕老毛子固件），请在路由器的控制面板中关闭有关 WLAN 的硬件加速，比如选择“Offload TCP/UDP for LAN”（若未出现此现象请忽略）：

![关闭WLAN硬件加速](https://github.com/Oakwen/Openwrt-Pi3/raw/master/images/VLAN_speedup.png)

### 10.2 宿主机网络修复

OpenWrt 容器运行后，宿主机内可能无法正常连接外部网络，需要修改宿主机的 ```/etc/network/interfaces``` 文件以修复：

先备份文件再编辑：

```bash
cp /etc/network/interfaces /etc/network/interfaces.bak # 备份文件
vim /etc/network/interfaces # 使用 vim 编辑文件
```

在文件后加入：

```bash
auto eth0
iface eth0 inet manual

auto macvlan
iface macvlan inet static
    address 192.168.8.151
    netmask 255.255.255.0
    gateway 192.168.8.8
    dns-nameservers 192.168.8.8
    pre-up ip link add macvlan link eth0 type macvlan mode bridge
    post-down ip link del macvlan link eth0 type macvlan mode bridge
```
