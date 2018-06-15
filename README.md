# 说明
- 安卓自动精简脚本，支持Windows/Linux/MacOS操作系统
- Windows将自动安装adb驱动，Linux及MacOS操作系统需自行安装adb工具
- 请自行修改purelist.txt精简列表
- 将自动删除所有用户级APP，请精简完后再安装自己需要的APP或者恢复备份
- 无法删除MIUI系统线刷版cust分区下的推广APP，请自行删除

# 使用方法：
手机开启usb调试模式，并给予电脑授权
```
 git clone https://github.com/vinewx/PureOS.git
 cd PureOS
 
 #Linux系统
 bash Pure_Linux.sh
 
 #Mac系统
 bash Pure_Mac.sh
```
Windows系统：
[点击下载](https://github.com/vinewx/PureOS/archive/master.zip)  
 解压后运行 Pure_Win.bat

# License

[The MIT License (MIT)](https://raw.githubusercontent.com/vinewx/PureOS/master/LICENSE)

# Credits

This repo relies on the following third-party projects:

* In production:
  * [mbuilov/sed-windows](https://github.com/mbuilov/sed-windows)
