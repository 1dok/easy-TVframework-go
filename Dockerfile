# 使用官方的 Go 基础镜像
FROM golang:1.20 AS build

WORKDIR /app

# 将 go.mod 和 go.sum 文件复制到容器中
COPY go.mod go.sum ./

# 下载 Go 依赖
RUN echo "Downloading Go dependencies..." && go mod tidy

# 复制代码到容器中
COPY . .

# 打印 Go 环境和版本信息，帮助调试
RUN echo "Go version: $(go version)" && \
    go env

# 构建 Go 程序
RUN echo "Building Go program..." && go build -o easy-tv main.go

# 设置容器启动时默认执行的命令
CMD ["./easy-tv"]
