#!/bin/bash
set -euo pipefail

BUILD_DIR=build
IMG=image.hdd
SIZE_MB=64

LIMINE_DIR=limine
CONF=limine.conf
KERNEL_ELF=${BUILD_DIR}/kernel.elf
FONT_FILE=Unifont.psf

export PATH="$PATH:/usr/sbin:/sbin"

[ -f "$KERNEL_ELF" ] || { echo "Missing $KERNEL_ELF"; exit 1; }
[ -f "$CONF" ]       || { echo "Missing $CONF";       exit 1; }
[ -f "$FONT_FILE" ]  || { echo "Missing $FONT_FILE";  exit 1; }
[ -f "$LIMINE_DIR/limine-bios.sys" ] || { echo "Missing limine-bios.sys. Run: make -C limine"; exit 1; }
[ -f "$LIMINE_DIR/BOOTX64.EFI" ]     || { echo "Missing UEFI files. Run: make -C limine"; exit 1; }
[ -f "$LIMINE_DIR/BOOTIA32.EFI" ]    || { echo "Missing UEFI files. Run: make -C limine"; exit 1; }

rm -f "$IMG"
dd if=/dev/zero of="$IMG" bs=1M count=0 seek=$SIZE_MB

sgdisk "$IMG" -n 1:2048:4095 -t 1:ef02 -c 1:"BIOS Boot"
sgdisk "$IMG" -n 2:4096:0   -t 2:ef00 -c 2:"ESP"

"$LIMINE_DIR/limine" bios-install "$IMG"

FAT_OFFSET=$((4096 * 512))

mformat -i "$IMG"@@$FAT_OFFSET -F

mmd -i "$IMG"@@$FAT_OFFSET ::/EFI
mmd -i "$IMG"@@$FAT_OFFSET ::/EFI/BOOT
mmd -i "$IMG"@@$FAT_OFFSET ::/boot
mmd -i "$IMG"@@$FAT_OFFSET ::/boot/limine

mcopy -i "$IMG"@@$FAT_OFFSET "$KERNEL_ELF" ::/boot/ChoacuryOS.elf
mcopy -i "$IMG"@@$FAT_OFFSET "$CONF" ::/limine.conf
mcopy -i "$IMG"@@$FAT_OFFSET "$LIMINE_DIR/limine-bios.sys" ::/
mcopy -i "$IMG"@@$FAT_OFFSET "$LIMINE_DIR/BOOTX64.EFI" ::/EFI/BOOT
mcopy -i "$IMG"@@$FAT_OFFSET "$LIMINE_DIR/BOOTIA32.EFI" ::/EFI/BOOT
mcopy -i "$IMG"@@$FAT_OFFSET "$FONT_FILE" ::/

echo "Done!"
