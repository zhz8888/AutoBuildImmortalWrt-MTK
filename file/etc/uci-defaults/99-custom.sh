#!/bin/sh
# 该脚本为 immortalwrt 首次启动时运行的脚本，即 /etc/uci-defaults/99-custom.sh
# 设置默认防火墙规则，方便虚拟机首次访问 WebUI
uci set firewall.@zone[1].input='ACCEPT'

# 设置主机名映射，解决安卓原生 TV 无法联网的问题
uci add dhcp domain
uci set "dhcp.@domain[-1].name=time.android.com"
uci set "dhcp.@domain[-1].ip=203.107.6.88"

# 设置 DHCP 默认网关为 192.168.100.1
uci set network.lan.ipaddr='192.168.100.1'
echo "set 192.168.100.1 at $(date)" >> $LOGFILE

# 设置仅 LAN 口可访问网页终端
uci set ttyd.@ttyd[0].interface='lan wlan0 wlan1'

# 设置仅 LAN 口可连接 SSH
uci set dropbear.@dropbear[0].Interface='lan wlan0 wlan1'
uci commit

# 设置编译作者信息
FILE_PATH="/etc/openwrt_release"
NEW_DESCRIPTION="Compiled by zhz8888"
sed -i "s/DISTRIB_DESCRIPTION='[^']*'/DISTRIB_DESCRIPTION='$NEW_DESCRIPTION'/" "$FILE_PATH"

# 设置默认软件源
sed -e 's,https://downloads.immortalwrt.org,https://mirrors.cernet.edu.cn/immortalwrt,g' \
    -e 's,https://mirrors.vsean.net/openwrt,https://mirrors.cernet.edu.cn/immortalwrt,g' \
    -i.bak /etc/opkg/distfeeds.conf

exit 0
