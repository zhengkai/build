<http://shadowsocks.org/en/config/advanced.html>

创建 shadowsocks 用户

    sudo adduser --system --disabled-password --disabled-login --no-create-home shadowsocks

在 `/etc/security/limits.conf` 文件增加

	shadowsocks soft noproc 51200
	shadowsocks hard noproc 51200
	shadowsocks soft nofile 51200
	shadowsocks hard nofile 51200

在 `/etc/pam.d/sudo` 文件增加

    session    required   pam_limits.so

在 `/etc/rc.local` 文件增加

    sudo -u shadowsocks /www/build/shadowsocks/start.sh >/dev/null 2>&1 &
