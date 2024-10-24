不需要特殊安装，只是记一下：

重置特定用户的 samba 密码 `sudo smbpasswd -a 用户名`

列举 samba 用户 `sudo pdbedit -L` （也可以加个 `-v`）

目录例子

    [share]
    	comment = public share
    	path = /share
    	read only = no
    	browsable = yes
    	valid users = zhengkai
