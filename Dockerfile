# 使用一个官方的 Golang 镜像（指定一个兼容的 Go 版本）
FROM golang:1.18 AS build

WORKDIR /app

# 复制代码到容器中
COPY . .

# 下载依赖并构建 Go 程序
RUN go mod tidy && \
    go build -o easy-tv ./cmd/main.go
