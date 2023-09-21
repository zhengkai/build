通常可以用编译好的二进制包，运行 `bin.sh`

如果有特殊需求（如取最新开发版本而非稳定版本），执行 `./source.sh`    
会先下载最新的二进制包，用来编译 git 上的 go 源代码，默认是 master 分支，也可以 checkout 到指定的 tag 或 commit 重新编

注意 `/usr/local/go/bin` 在 PATH 里尽量靠前
