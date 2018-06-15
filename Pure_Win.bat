@echo off
setlocal EnableExtensions EnableDelayedExpansion
color 3f

cd /d "%~dp0"
set "path=%~dp0Bin;!path!"

title 安卓自动精简脚本 by ViNew
echo =================================================
echo   ................................
echo   ..._.._..__..__._..____.._.._...
echo   ../.)(.\(..)(..(.\(..__)/.)(.\..
echo   ..\.\/./.)(./..../.)._).\./\./..
echo   ...\__/.(__)\_)__)(____)(_/\_)..
echo   ................................
echo.
echo   一键自动精简安卓系统：
echo   * 自动识别安卓系统APP包名；
echo   * 理论上支持所有机型各种ROM；
echo   * 自动安装adb驱动；
echo   * 无需root,不必解BL锁；
echo   * OTA更新后精简依然有效无需重新执行脚本；
echo   * 请自行修改purelist.txt精简列表；
echo   * 删错APP或者精简完后悔了，双清即可恢复。
echo.
echo =================================================

set "UseAdb=1"
echo.
pause
echo =================================================
echo   检查环境
echo.

:CHECK_ENV

if "!UseAdb!"=="1" (
	for /f "tokens=*" %%t in ('adb get-state') do set "adbState=%%t"
	echo.
	echo   Adb状态: !adbState!
	if not "!adbState!"=="device" (
		echo.
		echo   尝试安装adb驱动
		call "InstallUsbDriver.cmd"

		adb kill-server
		ping -n 2 127.0.0.1 >nul
		
		for /f "tokens=*" %%t in ('adb get-state') do set "adbState=%%t"
		echo.
		echo   Adb状态: !adbState!
		if not "!adbState!"=="device" (
			echo.
			echo   无法连接adb，请确保：
			echo.
			echo   * 把手机接上USB。
			echo.
			pause
			goto :CHECK_ENV
		)
	)
)

echo.
echo =================================================
echo   清理目录
echo.

if "!UseAdb!"=="1" (
	FastCopy /cmd=delete /no_ui "output" "Bin/FastCopy.log" "Bin/FastCopy2.ini"
)

if "!UseAdb!"=="1" (
	echo.
	echo =================================================
	echo   获取第三方APP包名
	echo.

	if not exist "output" md "output"
		cd "output"
		adb shell pm list packages -3 >> otherapp.txt
		if errorlevel 1 echo   获取第三方APP包名失败 & pause & exit /b
		cd "%~dp0"
	)
)

if "!UseAdb!"=="1" (
	echo.
	echo =================================================
	echo   获取精简APP包名
	echo.
		cd "output"
		adb shell pm list packages -s -f >> systemapp.txt
		cd "%~dp0"
		for /f "delims=""" %%i in ('type "purelist.txt"') do (
	 	type "output\systemapp.txt"|findstr /i "%%i" >> output\pureapp.tmp
		)
		cd "output"
		cd.>pureapp.txt
		for /f "delims=" %%i in (pureapp.tmp) do (
		find /i "%%i" pureapp.txt||echo %%i>>pureapp.txt
		)
		FastCopy /cmd=delete /no_ui "pureapp.tmp"
		if errorlevel 1 echo   获取精简APP包名失败 & pause & exit /b
		cd "%~dp0"	
)

if "!UseAdb!"=="1" (
	echo.
	echo =================================================
	echo   生成精简脚本
	echo.
		pause
		cd "output"
		for /f "delims=" %%i in ("pureapp.txt") do (
		if %%~zi lss 2 (
		echo.
		echo   精简列表中不存在未被精简APP
		echo.
		echo   请按任意键退出
		pause >nul
		exit /b
		)
		)
		type otherapp.txt pureapp.txt >> PureOS.bat
		if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
   			sed_x86 -i 's/.*=/adb\ shell\ pm\ uninstall\ --user\ 0\ /g' PureOS.bat
			sed_x86 -i 's/package:/adb\ shell\ pm\ uninstall\ --user\ 0\ /g' PureOS.bat
		) else (
    		sed_x64 -i "s/.*=/adb\ shell\ pm\ uninstall\ --user\ 0\ /g" PureOS.bat
			sed_x64 -i "s/package:/adb\ shell\ pm\ uninstall\ --user\ 0\ /g" PureOS.bat
		)
		if errorlevel 1 echo   生成精简脚本失败 & pause & exit /b
		cls
		cd "%~dp0"
)

if not exist "output\PureOS.bat" (
	echo.
	echo   找不到精简脚本，无法继续。
	echo.
	echo   请按任意键退出
	pause >nul
	exit /b
)

echo.
echo =================================================
echo   执行精简脚本
echo.
		cd "output"
		call PureOS.bat
		if errorlevel 1 echo   执行精简脚本失败 & pause & exit /b
		cd "%~dp0"


echo.
echo =================================================
echo   清理目录
echo.

if "!UseAdb!"=="1" (
	FastCopy /cmd=delete /no_ui "output" "Bin/FastCopy.log" "Bin/FastCopy2.ini"
)

if "!UseAdb!"=="1" (
	echo.
	echo =================================================
	echo   精简完成
	echo.
	echo   欢迎访问我的博客 https://vinew.cc
	echo.
	pause
) 

goto :EOF
endlocal
pause