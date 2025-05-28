# Use the official Golang image as the build base
FROM --platform=$BUILDPLATFORM golang:1.23 AS builder

WORKDIR /app

# 复制依赖管理文件
COPY go.mod .
COPY go.sum .

# 设置国内代理，避免依赖下载失败
ENV GOPROXY=https://goproxy.cn,direct

RUN go mod download

# 复制全部源代码
COPY . .

# 定义构建参数，设置默认值
ARG TARGETOS=linux
ARG TARGETARCH=amd64

# 编译程序，避免 CGO 依赖，传递目标平台
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -trimpath -ldflags="-s -w" -o /app/itv .

# 运行时基础镜像
FROM alpine:latest

RUN apk --no-cache --update add tzdata

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone

WORKDIR /app

# 从 builder 镜像复制编译好的二进制
COPY --from=builder /app/itv /app/itv

# 暴露端口
EXPOSE 8123

# 复制入口脚本并赋予执行权限
ADD docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
