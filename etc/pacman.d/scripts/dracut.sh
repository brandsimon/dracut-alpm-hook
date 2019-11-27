#!/usr/bin/env dash
CMDLINE="root=UUID=7af9b993-b17e-4443-92e1-9a7000c96b44"
EFI_STUB="/usr/lib/systemd/boot/efi/linuxx64.efi.stub"
FALLBACK="yes"
execdracut() {
	local kver="${1}"
	shift
	local destfile="${1}"
	shift
	if test -f "${destfile}"; then
		echo "Move ${destfile} to ${destfile}.old"
		mv "${destfile}" "${destfile}.old"
	fi
	if ! dracut --kver "${kver}" --uefi --uefi-stub "${EFI_STUB}" --nolvmconf --nomdadmconf "${@}" --kernel-cmdline "${CMDLINE}" "${destfile}" > /dev/null; then
		exit 1
	fi
}
update() {
	local kver="${1}"
	local pkgbasefile="/usr/lib/modules/${kver}/pkgbase"
	local pkgname=""
	pkgname="$(cat "${pkgbasefile}")"
	local destfile="/boot/EFI/Arch/${pkgname}.efi"
	local fallbackdestfile="/boot/EFI/Arch/${pkgname}-fallback.efi"
	echo "Update ${pkgname}: ${kver}"
	execdracut "${kver}" "${destfile}" --hostonly --hostonly-cmdline
	if ! test -z "${FALLBACK}"; then
		execdracut "${kver}" "${fallbackdestfile}" --no-hostonly --hostonly-cmdline
	fi
}
file_to_kver() {
	local file="${1}"
	local kver=""
	kver="$(echo "${file}" | sed -e "s/usr\/lib\/modules\/\([^/]*\)\/pkgbase/\1/g")"
	if test -f "/usr/lib/modules/${kver}/pkgbase"; then
		echo "${kver}"
	fi
}
kvers=""
all_kvers=""
read_something=""
while read -r line; do
	read_something="yes"
	kver="$(file_to_kver "${line}")"
	if test -z "${kver}"; then
		all_kvers="yes"
	else
		kvers="${kvers} ${kver}"
	fi
done
if test -z "${read_something}"; then
	all_kvers="yes"
fi
if ! test -z "${all_kvers}"; then
	echo "Update all kernels"
	cd /
	for line in usr/lib/modules/*/pkgbase; do
		kver="$(file_to_kver "${line}")"
		update "${kver}"
	done
else
	for kver in ${kvers}; do
		update "${kver}"
	done
fi
