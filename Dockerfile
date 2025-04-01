# 使用官方 Golang 镜像作为构建环境
FROM golang:1.20-alpine AS builder

# 设置工作目录
WORKDIR /app

# 拷贝整个项目代码到工作目录
COPY . .

# 下载依赖并构建 Go 程序，生成二进制文件
RUN go mod tidy && \
    go build -o easy-tv ./main.go  # 假设 main.go 位于根目录

# 使用更轻量的 Alpine 镜像作为运行环境
FROM alpine:latest

# 创建工作目录
WORKDIR /root/

# 从构建阶段复制编译好的二进制文件
COPY --from=builder /app/easy-tv .

# 开放服务端口（假设程序监听 8080）
EXPOSE 8080

# 运行程序
CMD ["./easy-tv"]
