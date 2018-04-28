zhengkai/build
=======

系统软件版本跟不上，那就自己编译吧    
仅适用于 Ubuntu 16.04，不确定在 Debian 或低版本 Ubuntu 上有什么问题

需要确保 `/usr/local/src` 目录可写

取最新版源代码编译的软件
-----------------------
（依赖全部走系统自带的）

* `git`
* `shadowsocks-libev`
* `vim`
* `watchman`

取最新版二进制包的软件
----------------------

* `go`
* `nodejs`

以上软件会记录已安装的版本，不会重复执行，可放入 crontab 每天跑    
安装目录 `--prefix=/usr/local`，请确保自己的 PATH 顺序，如果 which 没变可能需要 `hash -r`

其他
----

* `mysql` 走系统自带的安装，安装时生成随机密码并写入 `~/.my.cnf`
* `nginx` 取官方的 Ubuntu APT 源更新，以及额外的 SSL DH 强化
* `php` 手动更新版本，全部 shared 编译，不要安装系统自带的 PHP，会冲突
* `ssh` 安全检查，禁用 password
* `vbox` 将某个 VirtualBox instance 作为服务随系统自动开关机
* `rc-local` 高版本 Ubuntu 没有 rc.local 后的替代品
