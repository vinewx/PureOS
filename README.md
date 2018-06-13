# 说明
- 安卓自动精简脚本，可在Linux及MacOS系统下运行
- 电脑需要安装adb工具
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
