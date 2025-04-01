# 使用一个官方的 Golang 镜像，指定 Go 1.20 版本
FROM golang:1.20 AS build

WORKDIR /app

# 复制代码到容器中
COPY . .

# 下载依赖并构建 Go 程序
RUN go mod tidy && \
    go build -o easy-tv ./cmd/main.go

# 设置默认命令，启动程序
CMD ["./easy-tv"]
