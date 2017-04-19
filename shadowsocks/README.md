<http://shadowsocks.org/en/config/advanced.html>

<https://github.com/shadowsocks/shadowsocks/wiki/Securing-Public-Shadowsocks-Server>

创建 shadowsocks 用户

    sudo adduser --system --disabled-password --disabled-login --no-create-home shadowsocks

在 `/etc/security/limits.conf` 文件增加

	shadowsocks soft noproc 51200
	shadowsocks hard noproc 51200
	shadowsocks soft nofile 51200
	shadowsocks hard nofile 51200

在 `/etc/pam.d/sudo` 文件增加

    session    required   pam_limits.so

安装为系统服务
-------------

运行 `service` 目录下的 `./install.sh {local|server}`

注意 server 版的脚本有条 iptables 规则禁止访问 localhost    
如果不想启用规则请删除，更改端口请修改变量 `$OUT_IF`

