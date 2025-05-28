# Use the official Golang image as the build base
FROM --platform=$BUILDPLATFORM golang:1.23 AS builder

WORKDIR /app

# Copy go.mod and go.sum files for dependency management optimization
COPY go.mod .
COPY go.sum .

# 设置国内 Go 模块代理
ENV GOPROXY=https://goproxy.cn,direct

RUN go mod download

COPY . .

ARG TARGETOS TARGETARCH
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -trimpath -ldflags="-s -w" -o /app/itv .

FROM alpine:latest

RUN apk --no-cache --update add tzdata

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone

WORKDIR /app

COPY --from=builder /app/itv /app/itv

EXPOSE 8123

ADD docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
