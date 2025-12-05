# === Paths ===
BUILD_DIR := build
SRC_DIR   := src

# === Tools ===
CC  := gcc
ASM := nasm
LD  := ld

# === Flags ===
# 32-bit freestanding kernel C flags
CFLAGS   := -m32 -O2 -ffreestanding -fno-pic -Wall -Wextra -I$(SRC_DIR)
CFLAGS   += -std=gnu11

# 32-bit NASM objects
ASMFLAGS := -f elf32

# 32-bit linker, custom linker script, no standard libs
LDFLAGS  := -m elf_i386 -T $(SRC_DIR)/linker.ld -nostdlib

# === Sources ===
SRCS := \
    drivers/debug.c \
    drivers/filesystem/fat.c \
    drivers/gdt.c \
    drivers/idt.c \
    drivers/interrupt.asm \
    drivers/key.c \
    drivers/pci.c \
    drivers/pic.c \
    drivers/pit.c \
    drivers/ports.c \
    drivers/ps2_keyboard.c \
    drivers/ps2_mouse.c \
    drivers/keymaps/ps2_keymap_fi.c \
    drivers/keymaps/ps2_keymap_us.c \
    drivers/ps2.c \
    drivers/sound.c \
    drivers/storage/ata.c \
    drivers/storage/device.c \
    drivers/storage/gpt.c \
    drivers/storage/partition.c \
    drivers/ssp.c \
    drivers/utils.c \
    drivers/vga.c \
    drivers/vbe.c \
    drivers/GPU/vmsvga/vmsvga.c \
    kernel/kernel.c \
    kernel/krnentry.asm \
    kernel/panic.c \
    memory/kmalloc.c \
    memory/pmm.c \
    shell/shell.c \
    shell/terminal.c \
    shell/commands/command.c \
    shell/commands/clear/clear.c \
    shell/commands/beep/beep.c \
    shell/commands/calc/calc.c \
    shell/commands/compdate/compdate.c \
    shell/commands/echo/echo.c \
    shell/commands/pause/pause.c \
    shell/commands/pl/pl.c \
    shell/commands/chstat/chstat.c \
    shell/commands/cd/cd.c \
    shell/commands/cat/cat.c \
    shell/commands/ls/ls.c \
    shell/commands/whereami/whereami.c \
    shell/commands/vbetest/vbetest.c

# === Targets ===
KERNEL_ELF := $(BUILD_DIR)/kernel.elf
DISK_IMG   := image.hdd

# Turn "foo/bar.c" and "foo/bar.asm" into "build/foo/bar.c.o" etc.
OBJS := $(addprefix $(BUILD_DIR)/,$(addsuffix .o,$(SRCS)))

.PHONY: all kernel img run clean

all: img

kernel: $(KERNEL_ELF)

# Link the kernel
$(KERNEL_ELF): $(OBJS)
	$(LD) $(LDFLAGS) -o $(KERNEL_ELF) $(OBJS)

# Build disk image (your script)
img: $(KERNEL_ELF)
	./create-disk.sh

# Run under QEMU
run: img
	qemu-system-x86_64 -drive file=$(DISK_IMG),format=raw -serial stdio

# Cleanup
clean:
	rm -rf $(BUILD_DIR) image.hdd

# === Compile rules ===

# C -> .o
$(BUILD_DIR)/%.c.o: $(SRC_DIR)/%.c Makefile
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

# ASM -> .o
$(BUILD_DIR)/%.asm.o: $(SRC_DIR)/%.asm Makefile
	@mkdir -p $(@D)
	$(ASM) $(ASMFLAGS) $< -o $@

# Include auto-generated dependency files if they exist
-include $(OBJS:.o=.d)
