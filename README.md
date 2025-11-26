# eNSP-PerfectWorld-Fix (eNSP 与完美平台冲突修复工具)

## 简介 / Introduction
在运行华为 eNSP 模拟器时，如果后台运行着完美世界竞技平台（Perfect World Arena），会导致 eNSP 启动报错（通常是 40 错误或一直加载）。

这是因为完美平台的反作弊服务 `MessageTransfer` 可能会占用底层资源或端口。

本脚本可以：
1. **自动检测** 完美世界竞技平台是否运行。
2. **交互式询问** 是否关闭进程（支持回车默认确认）。
3. **自动停止** 冲突的 `MessageTransfer` 服务。
4. **一键启动** eNSP 客户端。

## 使用方法 / Usage
1. 下载仓库中的 `完美平台和eNSP冲突修复工具 - by qiuxtao.bat` 文件。
2. **右键 -> 编辑**，确认 `ENSP_PATH` 路径是否为你电脑上的 eNSP 安装路径（默认为 `C:\Program Files\Huawei\eNSP\eNSP_Client.exe`）。
3. **双击运行** 脚本即可。

## 注意事项 / Notes
* 脚本包含中文字符，请确保文件编码为 **ANSI**，否则可能出现乱码或检测失败。
* 脚本需要管理员权限运行（会自动请求）。

## 作者 / Author
[秋晓桃](https://github.com/qiuxtao)
