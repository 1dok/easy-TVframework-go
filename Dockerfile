# 使用较新版本的 Go 镜像作为基础镜像
FROM golang:1.19-alpine AS builder

# 设置工作目录
WORKDIR /go/src/app

# 复制当前目录的内容到容器中
COPY . .

# 更新 alpine 镜像并安装必要的依赖（包括 git）
RUN apk update && apk add --no-cache git

# 打印 Go 版本以帮助调试
RUN go version

# 安装 garble（如果失败，可以尝试手动编译）
RUN echo "Installing garble" && go install mvdan.cc/garble@v0.14.1  # 指定兼容的版本

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
