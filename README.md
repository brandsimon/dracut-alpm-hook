# dracut-alpm-hook

This provides hooks for alpm/pacman to build an initramfs with dracut on package update.

## Dependencies

	dash dracut systemd

## Installation

To enable this hook, copy the files to the pacman directories.

	cp etc/pacman.d/hooks/90-dracut.hook /etc/pacman.d/hooks/90-dracut.hook
	cp etc/pacman.d/scripts/dracut.sh /etc/pacman.d/scripts/dracut.sh

## Trigger build manually

To rebuild all kernels, run

	echo | dash /path/to/dracut-script.sh

To rebuild a specific kernel, run

	echo usr/lib/modules/5.3.13-arch1-1/pkgbase | dash /path/to/dracut-script.sh

## Configuration

You can change the dracut options in the script file.
