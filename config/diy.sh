#!/bin/bash
# 本脚本工作目录必须是git仓库的主目录
# Add Some Package
./scripts/feeds update -a

rm -rf package/lean/luci-app-jd-dailybonus package/lean/luci-theme-argon
rm -rf package/feeds/packages/smartdns
mkdir -p package/custom && cd package/custom
git clone --depth=1 -b lede https://github.com/pymumu/luci-app-smartdns.git
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git
git clone --depth=1 https://github.com/thinktip/luci-theme-neobird.git
git clone --depth=1 https://github.com/pymumu/smartdns.git
git clone --depth=1 https://github.com/vernesong/OpenClash.git
git clone --depth=1 https://github.com/fw876/helloworld.git

cd -
./scripts/feeds install -a

# Modify default IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate
sed -i 's/192.168/10.0/g' package/base-files/files/bin/config_generate

# Modify some default settings
# curl -fsSL https://raw.githubusercontent.com/1orz/My-action/master/lede/zzz-default-settings >package/lean/default-settings/files/zzz-default-settings
