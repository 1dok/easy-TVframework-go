# 设置基础镜像
FROM golang:1.20-alpine AS builder

# 创建工作目录
WORKDIR /app

# 复制 go.mod 和 go.sum 文件
COPY go.mod go.sum ./

# 下载依赖
RUN go mod download

# 复制源代码
COPY . .

# 打印 Go 版本
RUN go version

# 构建 Go 程序
RUN echo "Building Go program..." && go build -o easy-tv ./cmd/app.go

# 使用更小的基础镜像进行运行
FROM alpine:latest

# 设置工作目录
WORKDIR /root/

# 拷贝构建产物
COPY --from=builder /app/easy-tv .

# 暴露端口
EXPOSE 8123

# 运行程序
ENTRYPOINT ["./easy-tv"]
