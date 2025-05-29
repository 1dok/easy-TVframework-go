# 使用官方 Go 镜像作为构建阶段
FROM golang:1.22 AS builder

WORKDIR /app

# 复制依赖配置文件
COPY go.mod ./
COPY go.sum ./

# 安装依赖（关键）
RUN go mod tidy

# 复制源代码
COPY . .

# 显示环境和项目结构（可调试）
RUN go env && ls -al

# 构建二进制文件
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -ldflags="-s -w" -o /app/itv .

# 使用极简镜像
FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/itv .

EXPOSE 8123
ENTRYPOINT ["/app/itv"]
