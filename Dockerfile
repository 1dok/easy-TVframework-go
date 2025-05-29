# 使用官方 Go 镜像作为构建阶段
FROM golang:1.22 as builder

# 设置工作目录
WORKDIR /app

# 复制 go.mod 和 go.sum 并下载依赖
COPY go.mod go.sum ./
RUN go mod download

# 复制项目的所有源代码
COPY . .

# 显示 go 环境和当前目录内容（方便调试）
RUN go env && ls -al

# 构建可执行文件
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -ldflags="-s -w" -o /app/itv .

# 使用更小的基础镜像进行最终封装
FROM alpine:latest

WORKDIR /app

# 从构建阶段复制可执行文件
COPY --from=builder /app/itv /app/itv

# 如果有配置文件或静态文件，也复制进来（可选）
# COPY --from=builder /app/config /app/config

# 暴露端口（按需）
EXPOSE 8123

# 设置启动命令
ENTRYPOINT ["/app/itv"]
