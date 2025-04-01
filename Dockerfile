# 构建阶段
FROM golang:1.20-alpine AS builder

# 设置工作目录
WORKDIR /app

# 将 go.mod 和 go.sum 复制到工作目录
COPY go.mod go.sum ./

# 下载依赖
RUN go clean -modcache && go mod tidy

# 复制整个项目到工作目录
COPY . .

# 打印目录结构和依赖信息
RUN echo "Printing current directory structure:" && ls -R /app
RUN echo "Checking go.mod and dependencies:" && cat go.mod && go mod tidy

# 构建 Go 程序
RUN echo "Building Go program..." && go mod download && go build -o easy-tv main.go

# 运行阶段
FROM alpine:latest

# 复制构建好的二进制文件
COPY --from=builder /app/easy-tv /usr/local/bin/easy-tv

# 设置容器启动时执行的命令
ENTRYPOINT ["easy-tv"]
