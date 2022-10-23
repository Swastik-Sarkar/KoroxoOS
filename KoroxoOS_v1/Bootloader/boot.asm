[org 0x7C00]
[bits 16]

KERNEL_LOCATION equ 0x7ef0

_main16:
	mov [BOOT_DISK], dl

	cli
	mov ax, 0x00
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7C00
	sti
    
	call memory_detection
    call upper_memory_detection

	mov ah, 0x00
	mov al, 0x03
	int 0x10

	mov bx, KERNEL_LOCATION
	mov dh, 50
	call disk_read

	jmp enter_protected_mode

%include"print_string.asm"
%include"print_dec.asm"
%include"disk.asm"
%include"memory.asm" 
%include"protected_mode.asm"
%include"gdt.asm"

[bits 32]

_main32:
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	mov ebp, 0x90000
	mov esp, ebp

	in al, 0x92
	or al, 0x02
	out 0x92, al

	jmp KERNEL_LOCATION

times 510-($-$$) db 0x00
dw 0xAA55
