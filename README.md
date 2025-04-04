# easy-TVframework-go
#### 可用itv服务器IP在 liveITV/config.go 中配置，当前配置为示例不可直接使用。

## Golang 多品台构建支持
go install mvdan.cc/garble@latest

## Docker多品台构建支持
docker buildx create --name mybuilder --use --driver docker-container  
docker buildx inspect --bootstrap

## 编译二进制可执行文件&执行
### 全平台
make  

### 指定平台
make linux_amd64

### 运行二进制文件
itv_linux_amd64 -token=itv

## 构建多平台镜像并推送至HUB仓库
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t g12777/easy-TV:latest --push .

## Docker部署运行
docker run -d --restart always -p 8123:8123 --name easy-TV g12777/easy-TV:latest -token=mytoken

## 编辑 Sync_Update.sh 39行 指定升级服务器SSH
#### 检查升级路径在config中配置
#### version与线上不一致会触发升级
