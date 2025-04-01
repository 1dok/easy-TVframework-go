# 构建阶段
FROM golang:1.20-alpine AS builder

# 设置工作目录
WORKDIR /app

# 将 go.mod 和 go.sum 复制到工作目录
COPY go.mod go.sum ./

# 打印模块信息和环境变量
RUN echo "Checking go.mod content:" && cat go.mod
RUN echo "Go environment:" && go env

# 下载依赖
RUN echo "Running go mod tidy:" && go mod tidy
RUN echo "Downloading modules:" && go mod download

# 复制整个项目到工作目录
COPY . .

# 打印目录结构
RUN echo "Printing current directory:" && pwd
RUN echo "Listing files:" && ls -al
RUN echo "Listing /app:" && ls -al /app

# 构建 Go 程序
RUN echo "Building Go program..." && go mod tidy && go mod download && go build -o easy-tv main.go

# 运行阶段
FROM alpine:latest

# 复制构建好的二进制文件
COPY --from=builder /app/easy-tv /usr/local/bin/easy-tv

# 设置容器启动时执行的命令
ENTRYPOINT ["easy-tv"]
