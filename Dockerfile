# 使用支持的 Go 版本的镜像作为构建阶段的基础镜像
FROM golang:1.19-alpine AS builder

# 设置工作目录
WORKDIR /go/src/app

# 复制当前目录的内容到容器中
COPY . .

# 更新 alpine 镜像中的 apk 并安装所需的包
RUN apk update && apk add --no-cache git

# 打印 Go 版本以帮助调试
RUN go version

# 安装 garble，使用兼容的 Go 版本
RUN echo "Installing garble" && go install mvdan.cc/garble@latest

# 下载依赖
RUN go mod tidy

# 构建项目（假设没有 main.go，我们需要确认具体构建命令）
RUN garble build -o easy-tv

# 使用更小的基础镜像来运行应用
FROM alpine:latest

# 安装运行时所需的依赖
RUN apk --no-cache add ca-certificates

# 将构建的二进制文件从构建阶段复制过来
COPY --from=builder /go/src/app/easy-tv /usr/local/bin/

# 设置容器的默认命令
CMD ["easy-tv"]
