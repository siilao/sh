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


siilao_sh() {
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
  00) siilao_update ;;
  0) clear ; exit ;;
  *) echo "无效的输入!" ;;
esac
	break_end
done
}