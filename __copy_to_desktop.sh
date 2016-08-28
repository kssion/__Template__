#! /bin/sh

# 当前执行目录
path="$(dirname "$0")"
echo ""
echo ""
echo ""


echo "\033[0;47;34m"
echo "********************************"
echo "*                              *"
echo "*         项目生成工具         *"
echo "*                              *"
echo "********************************""\033[0m"
echo ""
echo ""


path=${path//" "/"\ "}
# echo "路径:\033[0;30;32m $path \033[0m"
# echo ""

# 模版名称
project_name="__Template__"

echo "(项目自动生成保存在桌面)"

echo "\033[1;47;31m"
echo "请输入项目的英文名称(\033[1;47;31m不能包含空格\033[0m\033[1;47;31m):\033[0m" 

read name

if [ -z $name ]; then
	echo "\033[1;47;31m"
	echo "没有输入名称，请重新执行脚本！\033[0m"
else
	name_1=${name//" "/""}
	if [[ $name_1 = $name ]]; then

		echo "名称: $name"

		echo "\033[0;47;34m"
		echo "> 复制文件..\033[0m"
		
		# 复制文件命令
		cmd_copy="cp -rf $path/$project_name/ ~/Desktop/$name"
		echo "$cmd_copy"

		# 执行命令
		$(eval $cmd_copy)

		echo "\033[0;47;34m"
		echo "> 更改文件名称..\033[0m"

		# 更改文件名称命令
		cmd_rename="mv ~/Desktop/$name/$project_name/ ~/Desktop/$name/$name"
		echo "$cmd_rename"
		$(eval $cmd_rename)

		cmd_rename="mv ~/Desktop/$name/$project_name.xcodeproj/ ~/Desktop/$name/$name.xcodeproj"
		echo "$cmd_rename"
		$(eval $cmd_rename)
		
		echo "\033[0;47;34m"
		echo "> 搜索替换..\033[0m"

		# 搜索替换命令
		f_path="~/Desktop/$name/"
		echo $f_path

		cmd_search_replace="grep -I -l -r -e $project_name $f_path* | xargs sed -i '' s/$project_name/$name/g"
		echo "$cmd_search_replace"

		# 执行命令
		$(eval $cmd_search_replace)
		
		echo "\033[0;47;34m"
		echo "> 项目生成完毕！\033[0m"
		echo ""
	else
		echo "\033[0;47;31m"
		echo "项目名称不能包含空格！\033[0m"
	fi
fi
