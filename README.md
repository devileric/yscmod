# YSC APK Auto Update Tool

用于 Windows 下一键给 YSC APK 注入自动更新模块。

## 功能

- APK 反编译
- 注入自动更新 Activity
- APK 重打包
- 对齐、签名、验证
- 更新地址固定为 `https://*/update/update.json`

## 本地工具文件

由于 GitHub 仓库是公开的，以下敏感或大型二进制文件不上传：

- `ysc-update.jks`：签名私钥
- `config.json`：包含本地签名配置
- `apktool.jar`
- `apksigner.jar`

请在本地工具目录放置对应文件，并根据 `config.example.json` 创建 `config.json`。

**不要把签名私钥、密码提交到 GitHub。**

## 使用

1. 安装 Python 3 和 Java 8+。
2. 准备 `apktool.jar`、`apksigner.jar` 和本地签名 JKS。
3. 从 `config.example.json` 创建 `config.json`。
4. 双击 `build_exe.bat` 构建 EXE。
5. 将 APK 拖到 `YSC_AutoUpdate.exe` 上。

输出文件位于 `output/`。

## 更新 JSON

示例：

```json
{
  "versionCode": 628,
  "versionName": "6.2.8",
  "apkUrl": "https://*/update/ysc.apk",
  "updateLog": "修复若干问题",
  "forceUpdate": false
}
```
