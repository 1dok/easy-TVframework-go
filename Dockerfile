# 使用 Golang 官方镜像作为构建环境
FROM golang:1.20-alpine as builder

# 设置工作目录
WORKDIR /go/src/app

# 将当前目录的内容复制到容器中的工作目录
COPY . .

# 下载依赖并构建 Go 程序，生成二进制文件
RUN go mod tidy && \
    go build -o easy-tv ./main.go

# 使用较小的镜像作为运行时环境
FROM alpine:latest

# 安装必要的依赖
RUN apk --no-cache add ca-certificates

# 将构建阶段的二进制文件复制到当前镜像中
COPY --from=builder /go/src/app/easy-tv /usr/local/bin/easy-tv

# 设置容器启动命令
ENTRYPOINT ["easy-tv"]

# 配置容器暴露端口
EXPOSE 8123
