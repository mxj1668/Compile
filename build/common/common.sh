#!/bin/bash
# https://github.com/281677160/build-openwrt
# common Module by 28677160
# matrix.target=${Modelfile}

DIY_GET_COMMON_SH() {
TYZZZ="package/lean/default-settings/files/zzz-default-settings"
LIZZZ="package/default-settings/files/zzz-default-settings"
}

# 全脚本源码通用diy.sh文件
Diy_all() {
DIY_GET_COMMON_SH
git clone -b $REPO_BRANCH --single-branch https://github.com/281677160/openwrt-package package/danshui
mv "${PATH1}"/AutoBuild_Tools.sh package/base-files/files/bin
chmod +x package/base-files/files/bin/AutoBuild_Tools.sh
if [[ ${REGULAR_UPDATE} == "true" ]]; then
git clone https://github.com/281677160/luci-app-autoupdate package/luci-app-autoupdate
mv "${PATH1}"/AutoUpdate.sh package/base-files/files/bin
chmod +x package/base-files/files/bin/AutoUpdate.sh
fi
}

# 全脚本源码通用diy2.sh文件
Diy_all2() {
DIY_GET_COMMON_SH
if [ -n "$(ls -A "${Home}/package/danshui/ddnsto" 2>/dev/null)" ]; then
mv package/danshui/ddnsto package/network/services
fi
if [[ `grep -c "# CONFIG_PACKAGE_ddnsto is not set" "${PATH1}/${CONFIG_FILE}"` -eq '0' ]]; then
sed -i '/CONFIG_PACKAGE_ddnsto/d' "${PATH1}/${CONFIG_FILE}" > /dev/null 2>&1
echo -e "\nCONFIG_PACKAGE_ddnsto=y" >> "${PATH1}/${CONFIG_FILE}"
fi

}


################################################################################################################
# LEDE源码通用diy1.sh文件
################################################################################################################
Diy_lede() {
DIY_GET_COMMON_SH
rm -rf package/lean/{luci-app-netdata,luci-theme-argon,k3screenctrl}
sed -i 's/iptables -t nat/# iptables -t nat/g' ${TYZZZ}
if [[ "${Modelfile}" == "Lede_x86_64" ]]; then
sed -i '/IMAGES_GZIP/d' "${PATH1}/${CONFIG_FILE}" > /dev/null 2>&1
echo -e "\nCONFIG_TARGET_IMAGES_GZIP=y" >> "${PATH1}/${CONFIG_FILE}"
fi

git clone https://github.com/fw876/helloworld package/danshui/luci-app-ssr-plus
git clone https://github.com/xiaorouji/openwrt-passwall package/danshui/luci-app-passwall
git clone https://github.com/jerrykuku/luci-app-vssr package/danshui/luci-app-vssr
git clone https://github.com/vernesong/OpenClash package/danshui/luci-app-openclash
git clone https://github.com/frainzy1477/luci-app-clash package/danshui/luci-app-clash
}
################################################################################################################
# LEDE源码通用diy2.sh文件
Diy_lede2() {
DIY_GET_COMMON_SH
cp -Rf "${Home}"/build/common/LEDE/files "${Home}"
cp -Rf "${Home}"/build/common/LEDE/diy/* "${Home}"
sed -i '/exit 0/i\echo "*/4 * * * * chmod +x /etc/webweb.sh && source /etc/webweb.sh" >> /etc/crontabs/root' ${TYZZZ}
}


################################################################################################################
# LIENOL源码通用diy1.sh文件
################################################################################################################
Diy_lienol() {
DIY_GET_COMMON_SH
rm -rf package/diy/luci-app-adguardhome
rm -rf package/lean/{luci-app-netdata,luci-theme-argon,k3screenctrl}
git clone https://github.com/fw876/helloworld package/danshui/luci-app-ssr-plus
git clone https://github.com/xiaorouji/openwrt-passwall package/danshui/luci-app-passwall
git clone https://github.com/jerrykuku/luci-app-vssr package/danshui/luci-app-vssr
git clone https://github.com/vernesong/OpenClash package/danshui/luci-app-openclash
git clone https://github.com/frainzy1477/luci-app-clash package/danshui/luci-app-clash
}
################################################################################################################
# LIENOL源码通用diy2.sh文件
Diy_lienol2() {
DIY_GET_COMMON_SH
cp -Rf "${Home}"/build/common/LIENOL/files "${Home}"
cp -Rf "${Home}"/build/common/LIENOL/diy/* "${Home}"
rm -rf feeds/packages/net/adguardhome
sed -i '/exit 0/i\echo "*/1 * * * * chmod +x /etc/webweb.sh && source /etc/webweb.sh" >> /etc/crontabs/root' ${LIZZZ}
sed -i 's/DEFAULT_PACKAGES +=/DEFAULT_PACKAGES += luci-app-passwall/g' target/linux/x86/Makefile
}


################################################################################################################
# 天灵源码通用diy1.sh文件
################################################################################################################
Diy_immortalwrt() {
DIY_GET_COMMON_SH
rm -rf package/lienol/luci-app-timecontrol
rm -rf package/lean/luci-theme-argon
}

################################################################################################################
# 天灵源码通用diy2.sh文件
Diy_immortalwrt2() {
DIY_GET_COMMON_SH
cp -Rf "${Home}"/build/common/PROJECT/files "${Home}"
cp -Rf "${Home}"/build/common/PROJECT/diy/* "${Home}"
rm -rf feeds/luci/applications/{luci-app-adguardhome,luci-app-argon-config}
rm -rf feeds/luci/themes/{luci-theme-argonv2,luci-theme-argonv3}
sed -i '/exit 0/i\echo "*/4 * * * * chmod +x /etc/webweb.sh && source /etc/webweb.sh" >> /etc/crontabs/root' ${TYZZZ}
sed -i "/exit 0/i\sed -i '/DISTRIB_REVISION/d' /etc/openwrt_release" ${TYZZZ}
}


################################################################################################################
# 判断脚本是否缺少主要文件（如果缺少settings.ini设置文件在检测脚本设置就运行错误了）

Diy_settings() {
DIY_GET_COMMON_SH
rm -rf ${Home}/build/QUEWENJIANerros
if [ -z "$(ls -A "$PATH1/${CONFIG_FILE}" 2>/dev/null)" ]; then
	echo
	echo "编译脚本缺少[${CONFIG_FILE}]名称的配置文件,请在[build/${Modelfile}]文件夹内补齐"
	echo "errors" > ${Home}/build/QUEWENJIANerros
	echo
fi
if [ -z "$(ls -A "$PATH1/${DIY_P1_SH}" 2>/dev/null)" ]; then
	echo
	echo "编译脚本缺少[${DIY_P1_SH}]名称的自定义设置文件,请在[build/${Modelfile}]文件夹内补齐"
	echo "errors" > ${Home}/build/QUEWENJIANerros
	echo
fi
if [ -z "$(ls -A "$PATH1/${DIY_P2_SH}" 2>/dev/null)" ]; then
	echo
	echo "编译脚本缺少[${DIY_P2_SH}]名称的自定义设置文件,请在[build/${Modelfile}]文件夹内补齐"
	echo "errors" > ${Home}/build/QUEWENJIANerros
	echo
fi
if [ -n "$(ls -A "${Home}/build/QUEWENJIANerros" 2>/dev/null)" ]; then
rm -rf ${Home}/build/QUEWENJIANerros
exit 1
fi
}

################################################################################################################
# 判断插件冲突

Diy_chajian() {
DIY_GET_COMMON_SH
echo
echo "				插件冲突信息" > ${Home}/CHONGTU

if [[ `grep -c "CONFIG_PACKAGE_luci-app-bypass_INCLUDE_V2ray=y" ${Home}/.config` -eq '1' ]]; then
	sed -i 's/CONFIG_PACKAGE_luci-app-bypass_INCLUDE_V2ray=y/# CONFIG_PACKAGE_luci-app-bypass_INCLUDE_V2ray is not set/g' ${Home}/.config
	echo -e "\nCONFIG_PACKAGE_luci-app-bypass=y" >> ${Home}/.config
	echo " 您选择的luci-app-bypass勾选了V2ray，Xary已包含V2ray，已删除V2ray" >>CHONGTU
	echo "插件冲突信息" > ${Home}/Chajianlibiao
fi
if [[ `grep -c "CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_V2ray=y" ${Home}/.config` -eq '1' ]]; then
	sed -i 's/CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_V2ray=y/# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_V2ray is not set/g' ${Home}/.config
	echo " 您选择的luci-app-ssr-plus勾选了V2ray，Xary已包含V2ray，已删除V2ray" >>CHONGTU
	echo "插件冲突信息" > ${Home}/Chajianlibiao
fi
if [[ `grep -c "CONFIG_PACKAGE_luci-app-samba=y" ${Home}/.config` -eq '1' ]]; then
	if [[ `grep -c "CONFIG_PACKAGE_luci-app-samba4=y" ${Home}/.config` -eq '1' ]]; then
		sed -i 's/CONFIG_PACKAGE_autosamba=y/# CONFIG_PACKAGE_autosamba is not set/g' ${Home}/.config
		sed -i 's/CONFIG_PACKAGE_luci-app-samba=y/# CONFIG_PACKAGE_luci-app-samba is not set/g' ${Home}/.config
		sed -i 's/CONFIG_PACKAGE_luci-i18n-samba-zh-cn=y/# CONFIG_PACKAGE_luci-i18n-samba-zh-cn is not set/g' ${Home}/.config
		sed -i 's/CONFIG_PACKAGE_samba36-server=y/# CONFIG_PACKAGE_samba36-server is not set/g' ${Home}/.config
		echo " 您同时选择luci-app-samba和luci-app-samba4，插件有冲突，已删除luci-app-samba" >>CHONGTU
		echo "插件冲突信息" > ${Home}/Chajianlibiao
	fi
	
fi
if [[ `grep -c "CONFIG_PACKAGE_luci-app-docker=y" ${Home}/.config` -eq '1' ]]; then
	if [[ `grep -c "CONFIG_PACKAGE_luci-app-dockerman=y" ${Home}/.config` -eq '1' ]]; then
		sed -i 's/CONFIG_PACKAGE_luci-app-dockerman=y/# CONFIG_PACKAGE_luci-app-dockerman is not set/g' ${Home}/.config
		sed -i 's/CONFIG_PACKAGE_luci-lib-docker=y/# CONFIG_PACKAGE_luci-lib-docker is not set/g' ${Home}/.config
		sed -i 's/CONFIG_PACKAGE_luci-i18n-dockerman-zh-cn=y/# CONFIG_PACKAGE_luci-i18n-dockerman-zh-cn is not set/g' ${Home}/.config
		echo " 您同时选择luci-app-docker和luci-app-dockerman，插件有冲突，已删除luci-app-dockerman" >>CHONGTU
		echo "插件冲突信息" > ${Home}/Chajianlibiao
	fi
	
fi
if [[ `grep -c "CONFIG_PACKAGE_luci-app-autotimeset=y" ${Home}/.config` -eq '1' ]]; then
	if [[ `grep -c "CONFIG_PACKAGE_luci-app-autoreboot=y" ${Home}/.config` -eq '1' ]]; then
		sed -i 's/CONFIG_PACKAGE_luci-app-autoreboot=y/# CONFIG_PACKAGE_luci-app-autoreboot is not set/g' ${Home}/.config
		sed -i 's/CONFIG_PACKAGE_luci-i18n-autoreboot-zh-cn=y/# CONFIG_PACKAGE_luci-i18n-autoreboot-zh-cn=y is not set/g' ${Home}/.config
		echo " 您同时选择luci-app-autotimeset和luci-app-autoreboot，插件有冲突，已删除luci-app-autoreboot" >>CHONGTU
		echo "插件冲突信息" > ${Home}/Chajianlibiao
	fi
	
fi
if [[ `grep -c "CONFIG_PACKAGE_luci-app-advanced=y" ${Home}/.config` -eq '1' ]]; then
	if [[ `grep -c "CONFIG_PACKAGE_luci-app-filebrowser=y" ${Home}/.config` -eq '1' ]]; then
		sed -i 's/CONFIG_PACKAGE_luci-app-filebrowser=y/# CONFIG_PACKAGE_luci-app-filebrowser is not set/g' ${Home}/.config
		sed -i 's/CONFIG_PACKAGE_luci-i18n-filebrowser-zh-cn=y/# CONFIG_PACKAGE_luci-i18n-filebrowser-zh-cn=y is not set/g' ${Home}/.config
		echo " 您同时选择luci-app-advanced和luci-app-filebrowser，插件有冲突，已删除luci-app-filebrowser" >>CHONGTU
		echo "插件冲突信息" > ${Home}/Chajianlibiao
	fi
	
fi
if [[ `grep -c "CONFIG_PACKAGE_luci-theme-argon=y" ${Home}/.config` -eq '1' ]]; then
	if [[ `grep -c "CONFIG_PACKAGE_luci-theme-argon_new=y" ${Home}/.config` -eq '1' ]]; then
		sed -i 's/CONFIG_PACKAGE_luci-theme-argon_new=y/# CONFIG_PACKAGE_luci-theme-argon_new is not set/g' ${Home}/.config
		echo " 您同时选择luci-theme-argon和luci-theme-argon_new，插件有冲突，已删除luci-theme-argon_new" >>CHONGTU
		echo "插件冲突信息" > ${Home}/Chajianlibiao
	fi

fi
if [[ `grep -c "CONFIG_PACKAGE_luci-app-sfe=y" ${Home}/.config` -eq '1' ]]; then
	if [[ `grep -c "CONFIG_PACKAGE_luci-app-flowoffload=y" ${Home}/.config` -eq '1' ]]; then
		echo " 提示：您同时选择了luci-app-sfe和luci-app-flowoffload，两个Turbo ACC网络加速" >>CHONGTU
		echo "插件冲突信息" > ${Home}/Chajianlibiao
	fi
fi
if [[ `grep -c "CONFIG_TARGET_ROOTFS_EXT4FS=y" .config` -eq '1' ]]; then
	echo " 请注意，您选择了ext4安装的固件格式" > ${Home}/EXT4
	echo " 请在Target Images  --->里面的下面两项的数值调整" >> ${Home}/EXT4
	echo " （16）Kernel partition size (in MB) " >> ${Home}/EXT4
	echo " （160）Root filesystem partition size (in MB)" >> ${Home}/EXT4
	echo " 请把（16）Kernel partition size (in MB) 设置成（30）Kernel partition size (in MB) 或者更高数值 " >> ${Home}/EXT4
	echo " 请把（160）Root filesystem partition size (in MB) 设置成（950）Root filesystem partition size (in MB) 或者更高数值" >> ${Home}/EXT4
	echo " （160）Root filesystem partition size (in MB) 这项设置数值请避免使用‘128’、‘256’、‘512’、‘1024’等之类的数值" >> ${Home}/EXT4
	echo " 选择了ext4安装格式的固件，（160）Root filesystem partition size (in MB) 这项数值太低容易造成插件空间不足编译错误" >> ${Home}/EXT4
	echo " " >> ${Home}/EXT4
fi
if [ -n "$(ls -A "${Home}/Chajianlibiao" 2>/dev/null)" ]; then
	echo "" >>CHONGTU
	echo "   插件冲突会导致编译失败，以上操作如非您所需，请关闭此次编译，重新开始编译，避开冲突重新选择插件" >>CHONGTU
	echo "" >>CHONGTU
else
	rm -rf CHONGTU
fi
}


################################################################################################################
# 判断是否选择AdGuard Home是就指定机型给内核

Diy_adgu() {
DIY_GET_COMMON_SH
grep -i CONFIG_PACKAGE_luci-app .config | grep  -v \# > Plug-in
grep -i CONFIG_PACKAGE_luci-theme .config | grep  -v \# >> Plug-in
sed -i "s/=y//g" Plug-in
sed -i "s/CONFIG_PACKAGE_//g" Plug-in
sed -i '/INCLUDE/d' Plug-in > /dev/null 2>&1
cat -n Plug-in > Plugin
sed -i 's/	luci/、luci/g' Plugin
awk '{print "  " $0}' Plugin > Plug-in
if [ `grep -c "CONFIG_TARGET_x86_64=y" ${Home}/.config` -eq '1' ]; then
	TARGET_ADG="x86-64"
else
	TARGET_ADG="$(egrep -o "CONFIG_TARGET.*DEVICE.*=y" .config | sed -r 's/.*DEVICE_(.*)=y/\1/')"
fi

rm -rf {LICENSE,README,README.md,CONTRIBUTED.md,README_EN.md}
rm -rf ./*/{LICENSE,README,README.md}
rm -rf ./*/*/{LICENSE,README,README.md}
rm -rf ./*/*/*/{LICENSE,README,README.md}
}


################################################################################################################
# 编译信息

Diy_xinxi_Base() {
GET_TARGET_INFO
if [[ "${TARGET_PROFILE}" =~ (x86-64|phicomm-k3|d-team_newifi-d2|phicomm_k2p|k2p|phicomm_k2p-32m) ]]; then
	Firmware_mz="${TARGET_PROFILE}自动适配"
	Firmware_hz="${TARGET_PROFILE}自动适配"
else
	Firmware_mz="${Up_Firmware}"
	Firmware_hz="${Firmware_sfx}"
fi
if [[ "${Modelfile}" =~ (Lede_phicomm_n1|Project_phicomm_n1) ]]; then
	TARGET_PROFILE="N1,Vplus,Beikeyun,L1Pro,S9xxx"
fi
echo
echo " 编译源码: ${COMP2}"
echo " 源码链接: ${REPO_URL}"
echo " 源码分支: ${REPO_BRANCH}"
echo " 源码作者: ${ZUOZHE}"
echo " 编译机型: ${TARGET_PROFILE}"
echo " 固件作者: ${Author}"
echo " 仓库地址: ${Github_Repo}"
echo " 启动编号: #${Run_number}（${CangKu}仓库第${Run_number}次启动[${Run_workflow}]工作流程）"
echo " 编译时间: $(TZ=UTC-8 date "+%Y年%m月%d号-%H时%M分")"
echo " 您当前使用【${Modelfile}】文件夹编译【${TARGET_PROFILE}】固件"
echo
if [[ ${UPLOAD_FIRMWARE} == "true" ]]; then
	echo " 上传固件在github actions: 开启"
else
	echo " 上传固件在github actions: 关闭"
fi
if [[ ${UPLOAD_CONFIG} == "true" ]]; then
	echo " 上传[.config]配置文件: 开启"
else
	echo " 上传[.config]配置文件: 关闭"
fi
if [[ ${UPLOAD_BIN_DIR} == "true" ]]; then
	echo " 上传BIN文件夹(固件+IPK): 开启"
else
	echo " 上传BIN文件夹(固件+IPK): 关闭"
fi
if [[ ${UPLOAD_COWTRANSFER} == "true" ]]; then
	echo " 上传固件到到【奶牛快传】和【WETRANSFER】: 开启"
else
	echo " 上传固件到到【奶牛快传】和【WETRANSFER】: 关闭"
fi
if [[ ${UPLOAD_RELEASE} == "true" ]]; then
	echo " 发布固件: 开启"
else
	echo " 发布固件: 关闭"
fi
if [[ ${SERVERCHAN_SCKEY} == "true" ]]; then
	echo " 微信/电报通知: 开启"
else
	echo " 微信/电报通知: 关闭"
fi
if [[ ${SSH_ACTIONS} == "true" ]]; then
	echo " SSH远程连接: 开启"
else
	echo " SSH远程连接: 关闭"
fi
if [[ ${SSHYC} == "true" ]]; then
	echo " SSH远程连接临时开关: 开启"
fi
if [[ ${REGULAR_UPDATE} == "true" ]]; then
	echo
	echo " 把定时自动更新插件编译进固件: 开启"
	echo " 插件版本: ${AutoUpdate_Version}"
	echo " 固件名称: ${Firmware_mz}"
	echo " 固件后缀: ${Firmware_hz}"
	echo " 固件版本: ${Openwrt_Version}"
	echo " 云端路径: ${Github_UP_RELEASE}"
	echo " 《编译成功，会自动把固件发布到指定地址，然后才会生成云端路径》"
	echo " 《5.0版本跟5.2版本的检测机制不一样，首次编译完5.2版本的请手动安装5.2版本编译的固件》"
	echo " 《普通的那个发布固件跟云端的发布路径是两码事，如果你不需要普通发布的可以不用打开发布功能》"
	echo " 《请把“REPO_TOKEN”密匙设置好,没设置好密匙不能发布就生成不了云端地址》"
	echo " 《x86-64、phicomm_k2p、phicomm-k3、newifi-d2已自动适配固件名字跟后缀，无需自行设置》"
	echo " 《x86设置安装固件时候请最少分配2G内存，要不然内存太低，自动更新不了》"
	echo " 《如有其他机子可以用定时更新固件的话，请告诉我，我把固件名字跟后缀适配了》"
	echo
else
	echo " 把定时自动更新插件编译进固件: 关闭"
	echo
fi
if [ -n "$(ls -A "${Home}/EXT4" 2>/dev/null)" ]; then
	[ -s EXT4 ] && cat EXT4
	rm -rf EXT4
fi
echo " 系统空间      类型   总数  已用  可用 使用率"
cd ../ && df -hT $PWD && cd openwrt
echo
if [ -n "$(ls -A "${Home}/Chajianlibiao" 2>/dev/null)" ]; then
	echo
	[ -s CHONGTU ] && cat CHONGTU
fi
if [ -n "$(ls -A "${Home}/Plug-in" 2>/dev/null)" ]; then
	echo
	echo "	   已选插件列表"
	[ -s Plug-in ] && cat Plug-in
	echo
fi
rm -rf {CHONGTU,Plug-in,Plugin,Chajianlibiao}
}
