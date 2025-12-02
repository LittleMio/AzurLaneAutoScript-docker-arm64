# AzurLaneAutoScript Docker (ARM64)

## 简介

本项目为 [AzurLaneAutoScript](https://github.com/LmeSzinc/AzurLaneAutoScript) 提供了适配 **ARM64 架构** 的 Docker 环境，使其能够在树莓派 等 ARM设备上方便地运行。

## 注意事项

* **默认端口：** `22267`
* **如需通过 ADB USB 连接设备，请取消注释 `docker-compose.yml` 中对应的配置行**

---

## 使用说明

### 前置条件

在开始前，请确保系统已安装：

* Docker
* Docker Compose（如使用 compose）
* 已克隆 **AzurLaneAutoScript** 源码

  > 例如克隆到：`/root/AzurLaneAutoScript`

---

## 使用 Docker Compose（推荐）

### 1. 克隆本项目

```bash
git clone https://github.com/LittleMio/AzurLaneAutoScript-docker-arm64.git
cd AzurLaneAutoScript-docker-arm64
```

### 2. 配置 `docker-compose.yml`

编辑 `docker-compose.yml`，将：

```
/path/to/dir
```

替换为 **AzurLaneAutoScript 项目的实际路径**。

---

## 使用 `docker run` 手动运行

### 使用当前目录：

```bash
docker run -v ${PWD}:/app/AzurLaneAutoScript \
           --network host \
           --name ALAS \
           -e TZ=Asia/Shanghai
           -it littlemio/alas:latest
```

### 指定目录：

```bash
docker run -v /path/to/dir:/app/AzurLaneAutoScript \
           --network host \
           --name ALAS \
           -e TZ=Asia/Shanghai
           -it littlemio/alas:latest
```

请将 `/path/to/dir` 替换为你实际的 AzurLaneAutoScript 项目路径。

---

## 其他说明

* 本镜像包含 **为 ARM64 优化重新编译的 MXNet**，在 ARM 设备上具有更好的运行性能。
  更多信息请参考 MXNet 官方文档：
  [https://mxnet.apache.org/versions/1.9.1/get_started?platform=devices&iot=raspberry-pi&](https://mxnet.apache.org/versions/1.9.1/get_started?platform=devices&iot=raspberry-pi&)

* 如遇问题可提交 issue：
  [https://github.com/LittleMio/AzurLaneAutoScript-docker-arm64/issues](https://github.com/LittleMio/AzurLaneAutoScript-docker-arm64/issues)

* 或参考原项目文档进行调试：
  [https://github.com/LmeSzinc/AzurLaneAutoScript/wiki](https://github.com/LmeSzinc/AzurLaneAutoScript/wiki)

---

## 许可证

本项目基于 [GPL-3.0](./LICENSE) 许可协议开源。
