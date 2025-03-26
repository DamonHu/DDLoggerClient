# DDLoggerClient

![](https://img.shields.io/badge/platform-MacOS-brightgreen) ![](https://img.shields.io/badge/interface-swiftUI-brightgreen) ![](https://img.shields.io/badge/license-MIT-brightgreen) 

![](./preview/Jietu20220731-212644.png)

该客户端用于方便的查看iOS手机端的调试日志库 [DDLoggerSwift](https://github.com/DamonHu/DDLoggerSwift)生成的Log日志。

[DDLoggerSwift](https://github.com/DamonHu/DDLoggerSwift) 使用SQLite存储日志信息，如果使用通用的SQLite查看工具，只是一条一条的表格，并且有的还收费。所以开发该工具方便查看配合更直观的查看数据。

## 客户端下载

[Releases](https://github.com/DamonHu/DDLoggerClient/releases)，下载`Release`中的`dmg`文件，拖拽进应用程序即可

## 本地日志

将`DDLoggerSwift`生成的`.db`文件、或者通过分享导出的`.log`文件，直接拖进左侧菜单栏，即可自动解析并根据日志类型显示颜色，可以进行搜索过滤等操作。

## 客户端配置

如果手机客户端修改了解密的`privacyLogPassword`、`privacyLogIv`的值，那么请在MAC客户端的设置中修改成对应的值，两端保持一致，否则会导致连接或者解密错误

## License

该项目基于MIT协议，您可以自由修改使用