#!/bin/bash
sh_v="1.0.0"


gl_hui='\e[37m'
gl_hong='\033[31m'
gl_lv='\033[32m'
gl_huang='\033[33m'
gl_lan='\033[34m'
gl_bai='\033[0m'
gl_zi='\033[35m'
gl_slao='\033[96m'



country="default"
cn_yuan() {
if [ "$country" = "CN" ]; then
	zhushi=0
	gh_proxy="https://github.trii.cn/"
else
	zhushi=1  # 0 表示执行，1 表示不执行
	gh_proxy=""
fi

}

cn_yuan



# 定义一个函数来执行命令
run_command() {
	if [ "$zhushi" -eq 0 ]; then
		"$@"
	fi
}



permission_granted="false"

CheckFirstRun_true() {
  if grep -q '^permission_granted="true"' /usr/local/bin/s > /dev/null 2>&1; then
    sed -i 's/^permission_granted="false"/permission_granted="true"/' ./silao.sh
    sed -i 's/^permission_granted="false"/permission_granted="true"/' /usr/local/bin/s
  fi
}

CheckFirstRun_true


# 收集功能埋点信息的函数，记录当前脚本版本号，使用时间，系统版本，CPU架构，机器所在国家和用户使用的功能名称，绝对不涉及任何敏感信息，请放心！请相信我！
# 为什么要设计这个功能，目的更好的了解用户喜欢使用的功能，进一步优化功能推出更多符合用户需求的功能。
# 全文可搜搜 send_stats 函数调用位置，透明开源，如有顾虑可拒绝使用。




ENABLE_STATS="false"

send_stats() {

	if [ "$ENABLE_STATS" == "false" ]; then
		return
	fi

	country=$(curl -s ipinfo.io/country)
	os_info=$(grep PRETTY_NAME /etc/os-release | cut -d '=' -f2 | tr -d '"')
	cpu_arch=$(uname -m)
	curl -s -X POST "" \
		 -H "Content-Type: application/json" \
		 -d "{\"action\":\"$1\",\"timestamp\":\"$(date -u '+%Y-%m-%d %H:%M:%S')\",\"country\":\"$country\",\"os_info\":\"$os_info\",\"cpu_arch\":\"$cpu_arch\",\"version\":\"$sh_v\"}" &>/dev/null &
}




yinsiyuanquan1() {

if grep -q '^ENABLE_STATS="true"' /usr/local/bin/s > /dev/null 2>&1; then
	status_message="${gl_lv}正在采集数据${gl_bai}"
elif grep -q '^ENABLE_STATS="false"' /usr/local/bin/s > /dev/null 2>&1; then
	status_message="${gl_hui}采集已关闭${gl_bai}"
else
	status_message="无法确定的状态"
fi

}


yinsiyuanquan2() {

if grep -q '^ENABLE_STATS="false"' /usr/local/bin/s > /dev/null 2>&1; then
	sed -i 's/^ENABLE_STATS="true"/ENABLE_STATS="false"/' ./silao.sh
	sed -i 's/^ENABLE_STATS="true"/ENABLE_STATS="false"/' /usr/local/bin/s
fi

}



yinsiyuanquan2
cp -f ./silao.sh /usr/local/bin/s > /dev/null 2>&1



CheckFirstRun_false() {
	if grep -q '^permission_granted="false"' /usr/local/bin/s > /dev/null 2>&1; then
		UserLicenseAgreement
	fi
}

# 提示用户同意条款
UserLicenseAgreement() {
	clear
	echo -e "${gl_slao}欢迎使用肆佬一键脚本${gl_bai}"
	echo "首次使用脚本，请先阅读并同意用户许可协议。"
	echo "用户许可协议: 暂无"
	echo -e "----------------------"
	read -r -p "是否同意以上条款？(y/n): " user_input


	if [ "$user_input" = "y" ] || [ "$user_input" = "Y" ]; then
		send_stats "许可同意"
		sed -i 's/^permission_granted="false"/permission_granted="true"/' ./silao.sh
		sed -i 's/^permission_granted="false"/permission_granted="true"/' /usr/local/bin/s
	else
		send_stats "许可拒绝"
		clear
		exit
	fi
}

CheckFirstRun_false





ip_address() {
ipv4_address=$(curl -s ipv4.ip.sb)
ipv6_address=$(curl -s --max-time 1 ipv6.ip.sb)
}



install() {
	if [ $# -eq 0 ]; then
		echo "未提供软件包参数!"
		return
	fi

	for package in "$@"; do
		if ! command -v "$package" &>/dev/null; then
			echo -e "${gl_huang}正在安装 $package...${gl_bai}"
			if command -v dnf &>/dev/null; then
				dnf -y update
				dnf install -y epel-release
				dnf install -y "$package"
			elif command -v yum &>/dev/null; then
				yum -y update
				yum install -y epel-release
				yum -y install "$package"
			elif command -v apt &>/dev/null; then
				apt update -y
				apt install -y "$package"
			elif command -v apk &>/dev/null; then
				apk update
				apk add "$package"
			elif command -v pacman &>/dev/null; then
				pacman -Syu --noconfirm
				pacman -S --noconfirm "$package"
			elif command -v zypper &>/dev/null; then
				zypper refresh
				zypper install -y "$package"
			elif command -v opkg &>/dev/null; then
				opkg update
				opkg install "$package"
			else
				echo "未知的包管理器!"
				return
			fi
		else
			echo -e "${gl_lv}$package 已经安装${gl_bai}"
		fi
	done

	return
}


install_dependency() {
	  install wget socat unzip tar
}


remove() {
	if [ $# -eq 0 ]; then
		echo "未提供软件包参数!"
		return
	fi

	for package in "$@"; do
		echo -e "${gl_huang}正在卸载 $package...${gl_bai}"
		if command -v dnf &>/dev/null; then
			dnf remove -y "${package}"*
		elif command -v yum &>/dev/null; then
			yum remove -y "${package}"*
		elif command -v apt &>/dev/null; then
			apt purge -y "${package}"*
		elif command -v apk &>/dev/null; then
			apk del "${package}*"
		elif command -v pacman &>/dev/null; then
			pacman -Rns --noconfirm "${package}"
		elif command -v zypper &>/dev/null; then
			zypper remove -y "${package}"
		elif command -v opkg &>/dev/null; then
			opkg remove "${package}"
		else
			echo "未知的包管理器!"
			return
		fi
	done

	return
}


# 通用 systemctl 函数，适用于各种发行版
systemctl() {
	COMMAND="$1"
	SERVICE_NAME="$2"

	if command -v apk &>/dev/null; then
		service "$SERVICE_NAME" "$COMMAND"
	else
		/bin/systemctl "$COMMAND" "$SERVICE_NAME"
	fi
}


# 重启服务
restart() {
	systemctl restart "$1"
	if [ $? -eq 0 ]; then
		echo "$1 服务已重启。"
	else
		echo "错误：重启 $1 服务失败。"
	fi
}

# 启动服务
start() {
	systemctl start "$1"
	if [ $? -eq 0 ]; then
		echo "$1 服务已启动。"
	else
		echo "错误：启动 $1 服务失败。"
	fi
}

# 停止服务
stop() {
	systemctl stop "$1"
	if [ $? -eq 0 ]; then
		echo "$1 服务已停止。"
	else
		echo "错误：停止 $1 服务失败。"
	fi
}

# 查看服务状态
status() {
	systemctl status "$1"
	if [ $? -eq 0 ]; then
		echo "$1 服务状态已显示。"
	else
		echo "错误：无法显示 $1 服务状态。"
	fi
}


enable() {
	SERVICE_NAME="$1"
	if command -v apk &>/dev/null; then
		rc-update add "$SERVICE_NAME" default
	else
	   /bin/systemctl enable "$SERVICE_NAME"
	fi

	echo "$SERVICE_NAME 已设置为开机自启。"
}



break_end() {
	  echo -e "${gl_lv}操作完成${gl_bai}"
	  echo "按任意键继续..."
	  read -n 1 -s -r -p ""
	  echo ""
	  clear
}

silao() {
    cd ~
    silao_sh
}



check_port() {

	docker rm -f nginx >/dev/null 2>&1

	# 定义要检测的端口
	PORT=80

	# 检查端口占用情况
	install iproute2
	result=$(ss -tulpn | grep ":\b$PORT\b")

	# 判断结果并输出相应信息
	if [ -n "$result" ]; then
			clear
			echo -e "${gl_hong}注意: ${gl_bai}端口 ${gl_huang}$PORT${gl_bai} 已被占用，无法安装环境，卸载以下程序后重试！"
			echo "$result"
			send_stats "端口冲突无法安装建站环境"
			break_end
			linux_ldnmp

	fi
}



silao_update() {

	send_stats "脚本更新"
	cd ~
	clear
	echo "更新日志"
	echo "------------------------"
	echo "全部日志: ${gh_proxy}https://raw.githubusercontent.com/silao/sh/main/silao_sh_log.txt"
	echo "------------------------"

  curl -s ${gh_proxy}https://raw.githubusercontent.com/silao/sh/main/silao_sh_log.txt | tail -n 35
  sh_v_new=$(curl -s ${gh_proxy}https://raw.githubusercontent.com/silao/sh/main/silao.sh | grep -o 'sh_v="[0-9.]*"' | cut -d '"' -f 2)

	if [ "$sh_v" = "$sh_v_new" ]; then
		echo -e "${gl_lv}你已经是最新版本！${gl_huang}v$sh_v${gl_bai}"
		send_stats "脚本已经最新了，无需更新"
	else
		echo "发现新版本！"
		echo -e "当前版本 v$sh_v        最新版本 ${gl_huang}v$sh_v_new${gl_bai}"
		echo "------------------------"
		read -e -p "确定更新脚本吗？(Y/N): " choice
		case "$choice" in
			[Yy])
				clear
				country=$(curl -s ipinfo.io/country)
				if [ "$country" = "CN" ]; then
          curl -sS -O ${gh_proxy}https://raw.githubusercontent.com/silao/sh/main/cn/silao.sh && chmod +x silao.sh
				else
          curl -sS -O ${gh_proxy}https://raw.githubusercontent.com/silao/sh/main/silao.sh && chmod +x silao.sh
				fi
				CheckFirstRun_true
				yinsiyuanquan2
        cp -f ./silao.sh /usr/local/bin/s > /dev/null 2>&1
				echo -e "${gl_lv}脚本已更新到最新版本！${gl_huang}v$sh_v_new${gl_bai}"
				send_stats "脚本已经最新$sh_v_new"
				break_end
        ./silao.sh
				exit
				;;
			[Nn])
				echo "已取消"
				;;
			*)
				;;
		esac
	fi


}



silao_sh() {
while true; do
clear

echo -e "${gl_slao}___ _   _    _    _  "
echo "|_  |   |   /_\  / \ "
echo "__| |   |__ | |  \_/ "
echo "                                "
echo -e "肆佬一键脚本工具 v$sh_v 只为更简单的Linux的使用！"
echo -e "适配Ubuntu/Debian/CentOS/Alpine/Kali/Arch/RedHat/Fedora/Alma/Rocky系统"
echo -e "-输入${gl_huang}s${gl_slao}可快速启动此脚本${gl_bai}"
echo -e "${gl_slao}------------------------${gl_bai}"
echo -e "${gl_slao}1.   ${gl_bai}系统信息查询"
echo -e "${gl_slao}2.   ${gl_bai}系统更新"
echo -e "${gl_slao}3.   ${gl_bai}系统清理"
echo -e "${gl_slao}------------------------${gl_bai}"
echo -e "${gl_slao}00.  ${gl_bai}脚本更新"
echo -e "${gl_slao}------------------------${gl_bai}"
echo -e "${gl_slao}0.   ${gl_bai}退出脚本"
echo -e "${gl_slao}------------------------${gl_bai}"
read -p "请输入你的选择: " choice

case $choice in
  1) linux_ps ;;
  2) clear ; send_stats "系统更新" ; linux_update ;;
  3) clear ; send_stats "系统清理" ; linux_clean ;;
  00) silao_update ;;
  0) clear ; exit ;;
  *) echo "无效的输入!" ;;
esac
	break_end
done
}


s_info() {
send_stats "s命令参考用例"
echo "无效参数"
echo "-------------------"
echo "视频介绍: https://www.bilibili.com/video/BV1ib421E7it?t=0.1"
echo "以下是s命令参考用例："
echo "启动脚本            s"
echo "安装软件包          s install nano wget | s add nano wget | s 安装 nano wget"
echo "卸载软件包          s remove nano wget | s del nano wget | s uninstall nano wget | s 卸载 nano wget"
echo "更新系统            s update | s 更新"
echo "清理系统垃圾        s clean | s 清理"

}



if [ "$#" -eq 0 ]; then
  # 如果没有参数，运行交互式逻辑
  silao_sh
else
	# 如果有参数，执行相应函数
	case $1 in
		install|add|安装)
			shift
			send_stats "安装软件"
			install "$@"
			;;
		remove|del|uninstall|卸载)
			shift
			send_stats "卸载软件"
			remove "$@"
			;;
		update|更新)
			linux_update
			;;
		clean|清理)
			linux_clean
			;;
		dd|重装)
			dd_xitong
			;;
		bbr3|bbrv3)
			bbrv3
			;;
		nhyh|内核优化)
			Kernel_optimize
			;;
		trash|hsz|回收站)
			linux_trash
			;;
		wp|wordpress)
			shift
			ldnmp_wp "$@"

			;;
		fd|rp|反代)
			shift
			ldnmp_Proxy "$@"
			;;
		status|状态)
			shift
			send_stats "软件状态查看"
			status "$@"
			;;
		start|启动)
			shift
			send_stats "软件启动"
			start "$@"
			;;
		stop|停止)
			shift
			send_stats "软件暂停"
			stop "$@"
			;;
		restart|重启)
			shift
			send_stats "软件重启"
			restart "$@"
			;;

		enable|autostart|开机启动)
			shift
			send_stats "软件开机自启"
			enable "$@"
			;;

		ssl)
			shift
			if [ "$1" = "ps" ]; then
				send_stats "查看证书状态"
				ssl_ps
			elif [ -z "$1" ]; then
				add_ssl
				send_stats "快速申请证书"
			elif [ -n "$1" ]; then
				add_ssl "$1"
				send_stats "快速申请证书"
			else
				s_info
			fi
			;;

		docker)
			shift
			case $1 in
				install|安装)
					send_stats "快捷安装docker"
					install_docker
					;;
				ps|容器)
					send_stats "快捷容器管理"
					docker_ps
					;;
				img|镜像)
					send_stats "快捷镜像管理"
					docker_image
					;;
				*)
					s_info
					;;
			esac
			;;

		web)
		   shift
			if [ "$1" = "cache" ]; then
				web_cache
			elif [ -z "$1" ]; then
				ldnmp_web_status
			else
				s_info
			fi
			;;
		*)
			s_info
			;;
	esac
fi
