BITS 32

section .multiboot_header
align 4
global multiboot_header

multiboot_header:
    dd 0x1BADB002
    dd 0x00000000
    dd -(0x1BADB002 + 0x00000000)

section .text
global start
extern k_main

start:
    mov esp, stack_top
    push eax
    push ebx
    lgdt [gdt_ptr]

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    jmp 0x08:flush_cs

flush_cs:
    call k_main

.hang:
    cli
    hlt
    jmp .hang

section .data
align 8

gdt_start:
    dq 0
    dq 0x00CF9A000000FFFF
    dq 0x00CF92000000FFFF
gdt_end:

gdt_ptr:
    dw gdt_end - gdt_start - 1
    dd gdt_start

section .bss
align 16

stack_bottom:
    resb 4096
stack_top:
