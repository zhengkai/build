代理分两部分

1. docker 本身 pull image 时的代理
2. 容器内的应用访问外部网络的代理

# Docker 代理配置

[官方文档](https://docs.docker.com/engine/daemon/proxy/)

下列文件应写在 `/etc/docker/daemon.json` 中。

```
{
  "proxies": {
    "http-proxy": "http://proxy.example.com:3128",
    "https-proxy": "https://proxy.example.com:3129",
    "no-proxy": "*.test.example.com,.example.org,127.0.0.0/8"
  }
}
```

service 配置文件 `/etc/systemd/system/docker.service.d/http-proxy.conf`：

```
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:3128"
Environment="HTTPS_PROXY=https://proxy.example.com:3129"
```

# 容器内应用代理配置

[官方文档](https://docs.docker.com/engine/cli/proxy/)


```
{
 "proxies": {
   "default": {
     "httpProxy": "http://proxy.example.com:3128",
     "httpsProxy": "https://proxy.example.com:3129",
     "noProxy": "*.test.example.com,.example.org,127.0.0.0/8"
   }
 }
}
```

检测方式为

```
docker run --rm alpine sh -c 'env | grep -i  _PROXY'
```
