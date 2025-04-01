# 构建 Go 程序
RUN echo "Building Go program..." && \
    go mod download && \
    ls -l && \
    go build -o easy-tv main.go
