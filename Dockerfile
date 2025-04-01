# 使用较新的 Go 镜像作为基础镜像
FROM golang:1.19-alpine AS builder

# 设置工作目录
WORKDIR /go/src/app

# 复制当前目录的内容到容器中
COPY . .

# 更新 alpine 镜像并安装必要的依赖（包括 git）
RUN apk update && apk add --no-cache git

# 打印 Go 版本和一些环境变量以帮助调试
RUN go version
RUN echo $GOPATH
RUN echo $GOROOT

# 安装 garble，使用兼容的 Go 版本
RUN echo "Installing garble" && go install mvdan.cc/garble@v0.14.1 || echo "Failed to install garble"

# 如果安装失败，显示错误信息
RUN echo "Checking garble installation" && garble version || echo "Garble is not installed"

# 下载依赖
RUN go mod tidy

# 使用 garble 构建项目
RUN garble build -o easy-tv

# 使用更小的基础镜像来运行应用
FROM alpine:latest

# 安装运行时所需的依赖
RUN apk --no-cache add ca-certificates

# 将构建的二进制文件从构建阶段复制过来
COPY --from=builder /go/src/app/easy-tv /usr/local/bin/

# 设置容器的默认命令
CMD ["easy-tv"]
