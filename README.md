# dracut-alpm-hook

This provides hooks for alpm/pacman to build an initramfs with dracut on package update.
To enable this hook, copy the files to the pacman directories.

## Dependencies

	dash dracut systemd

## Trigger build manually

To rebuild all kernels, run

	echo | dash /path/to/dracut-script.sh

To rebuild a specific kernel, run

	echo usr/lib/modules/5.3.13-arch1-1/pkgbase | dash /path/to/dracut-script.sh
