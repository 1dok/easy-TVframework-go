FROM golang:1.23 AS builder
WORKDIR /app
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .
RUN go version
RUN go env
RUN ls -l /app
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /app/itv .

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
