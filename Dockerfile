FROM golang:1.20 AS build

WORKDIR /app

# 复制代码到容器中
COPY . .

# 下载依赖并构建 Go 程序
RUN go mod tidy && \
    go build -o easy-tv main.go  # 构建新的 main.go 文件

# 设置默认命令，启动程序
CMD ["./easy-tv"]
