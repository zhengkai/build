修改 `/lib/systemd/system/getty@.service` 文件

找到

    ExecStart=-/sbin/agetty -o '-p -- \\u' --noclear %I $TERM

改为

    ExecStart=-/sbin/agetty -a zhengkai --noclear %I $TERM
