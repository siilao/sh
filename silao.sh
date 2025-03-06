#!/bin/bash
sh_v="1.0"


gl_hui='\e[37m'
gl_hong='\033[31m'
gl_lv='\033[32m'
gl_huang='\033[33m'
gl_lan='\033[34m'
gl_bai='\033[0m'
gl_zi='\033[35m'
gl_slao='\033[96m'

linux_ps() {

	clear
	send_stats "系统信息查询"

	ip_address

	cpu_info=$(lscpu | awk -F': +' '/Model name:/ {print $2; exit}')

	cpu_usage_percent=$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else printf "%.0f\n", (($2+$4-u1) * 100 / (t-t1))}' \
		<(grep 'cpu ' /proc/stat) <(sleep 1; grep 'cpu ' /proc/stat))

	cpu_cores=$(nproc)

	mem_info=$(free -b | awk 'NR==2{printf "%.2f/%.2f MB (%.2f%%)", $3/1024/1024, $2/1024/1024, $3*100/$2}')

	disk_info=$(df -h | awk '$NF=="/"{printf "%s/%s (%s)", $3, $2, $5}')

	ipinfo=$(curl -s ipinfo.io)
	country=$(echo "$ipinfo" | grep 'country' | awk -F': ' '{print $2}' | tr -d '",')
	city=$(echo "$ipinfo" | grep 'city' | awk -F': ' '{print $2}' | tr -d '",')
	isp_info=$(echo "$ipinfo" | grep 'org' | awk -F': ' '{print $2}' | tr -d '",')


	cpu_arch=$(uname -m)

	hostname=$(uname -n)

	kernel_version=$(uname -r)

	congestion_algorithm=$(sysctl -n net.ipv4.tcp_congestion_control)
	queue_algorithm=$(sysctl -n net.core.default_qdisc)

	# 尝试使用 lsb_release 获取系统信息
	os_info=$(grep PRETTY_NAME /etc/os-release | cut -d '=' -f2 | tr -d '"')

	output_status

	current_time=$(date "+%Y-%m-%d %I:%M %p")


	swap_info=$(free -m | awk 'NR==3{used=$3; total=$2; if (total == 0) {percentage=0} else {percentage=used*100/total}; printf "%dMB/%dMB (%d%%)", used, total, percentage}')

	runtime=$(cat /proc/uptime | awk -F. '{run_days=int($1 / 86400);run_hours=int(($1 % 86400) / 3600);run_minutes=int(($1 % 3600) / 60); if (run_days > 0) printf("%d天 ", run_days); if (run_hours > 0) printf("%d时 ", run_hours); printf("%d分\n", run_minutes)}')

	timezone=$(current_timezone)


	echo ""
	echo -e "系统信息查询"
	echo -e "${gl_slao}------------------------"
	echo -e "${gl_slao}主机名: ${gl_bai}$hostname"
	echo -e "${gl_slao}运营商: ${gl_bai}$isp_info"
	echo -e "${gl_slao}------------------------"
	echo -e "${gl_slao}系统版本: ${gl_bai}$os_info"
	echo -e "${gl_slao}Linux版本: ${gl_bai}$kernel_version"
	echo -e "${gl_slao}------------------------"
	echo -e "${gl_slao}CPU架构: ${gl_bai}$cpu_arch"
	echo -e "${gl_slao}CPU型号: ${gl_bai}$cpu_info"
	echo -e "${gl_slao}CPU核心数: ${gl_bai}$cpu_cores"
	echo -e "${gl_slao}------------------------"
	echo -e "${gl_slao}CPU占用: ${gl_bai}$cpu_usage_percent%"
	echo -e "${gl_slao}物理内存: ${gl_bai}$mem_info"
	echo -e "${gl_slao}虚拟内存: ${gl_bai}$swap_info"
	echo -e "${gl_slao}硬盘占用: ${gl_bai}$disk_info"
	echo -e "${gl_slao}------------------------"
	echo -e "${gl_slao}$output"
	echo -e "${gl_slao}------------------------"
	echo -e "${gl_slao}网络拥堵算法: ${gl_bai}$congestion_algorithm $queue_algorithm"
	echo -e "${gl_slao}------------------------"
	echo -e "${gl_slao}公网IPv4地址: ${gl_bai}$ipv4_address"
	echo -e "${gl_slao}公网IPv6地址: ${gl_bai}$ipv6_address"
	echo -e "${gl_slao}------------------------"
	echo -e "${gl_slao}地理位置: ${gl_bai}$country $city"
	echo -e "${gl_slao}系统时区: ${gl_bai}$timezone"
	echo -e "${gl_slao}系统时间: ${gl_bai}$current_time"
	echo -e "${gl_slao}------------------------"
	echo -e "${gl_slao}系统运行时长: ${gl_bai}$runtime"
	echo



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