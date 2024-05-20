用于 mysql 初次安装

取官方 apt 仓库 https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/

生成随机密码并写入 `~/.my.cnf`

ulimit 限制 http://serverfault.com/a/815837/183566

-----------------

备忘：

    sudo mysqld --initialize --user=mysql

重置数据库

	mysql_secure_installation

之前会产生临时密码，用这个命令转为正式

-----------------

## MySQL GPG 文件更新

从 <https://dev.mysql.com/doc/refman/8.0/en/checking-gpg-signature.html> 拷贝，或者

    gpg --keyserver pgpkeys.mit.edu --recv-key B7B3B788A8D3785C

导出成二进制 `.gpg` 文件

    gpg --export B7B3B788A8D3785C

导出成文本 `.asc` 文件

    gpg -a --export B7B3B788A8D3785C 
