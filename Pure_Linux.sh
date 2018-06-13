#=================================================
#       System Required: Linux/MacOS
#       Description: PureOS for Android
#       Version: 1.0.0
#       Author: vinew
#       Blog: https://vinew.cc/
#=================================================
echo " "
echo " "
echo "................................"
echo "..._.._..__..__._..____.._.._..."
echo "../.)(.\(..)(..(.\(..__)/.)(.\.."
echo "..\.\/./.)(./..../.)._).\./\./.."
echo "...\__/.(__)\_)__)(____)(_/\_).."
echo "................................"
echo " "
echo " "
echo " **************** Software *****************"
echo " PureOS for Android"
echo ""
echo " https://vinew.cc/"
echo ""
echo " Made with heart by ViNew"
echo ""
echo " *******************************************"

output=`dirname $0`/output
log=$output/log.txt
other_app=$output/otherapp.sh
purelist=`dirname $0`/purelist.txt
pure_app=$output/PureOS.sh
pure_app_tmp=$output/pureapptmp.txt
system_app=$output/systemapp.txt

cd `dirname $0`

#清理目录
if [ -d "$output" ];then
	rm -rf $output
fi

echo "Getting Package Name"
mkdir -p $output

#获取第三方APP包名
adb shell pm list packages -3 >> $other_app
sed -i 's/package:/adb\ shell\ pm\ uninstall\ --user\ 0\ /g' $other_app

#获取系统APP包名
adb shell pm list packages -s -f >> $system_app

echo "Generating PureOS scripts"
for i in `cat $purelist`
		do
		grep "$i" $system_app >> $pure_app_tmp
		done
sed -i 's/.*=/adb\ shell\ pm\ uninstall\ --user\ 0\ /g' $pure_app_tmp
sort -k2n $pure_app_tmp | awk '{if ($0!=line) print;line=$0}' >> $pure_app
rm -rf $pure_app_tmp
cat $other_app >> $pure_app

echo "Running PureOS scripts"
echo "It may take a few minutes."
bash $pure_app >> $log

echo "All done! Enjoy!"