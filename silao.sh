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
echo -e "${gl_slao}3.   ${gl_bai}系统sdfsd清理"
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