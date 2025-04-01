package main

import (
    "github.com/g12777/easy-TVframework-go"  // 引用库
    "log"
)

func main() {
    // 初始化并启动应用
    err := easyTV.Start()  // 假设 easyTV 是库的一个函数
    if err != nil {
        log.Fatal(err)
    }
}
