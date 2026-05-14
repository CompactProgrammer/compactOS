org 0x0000
bits 16
cpu 386

jmp fatjmp

fat12_bpb:
    db 'MSDOS5.0' ; OEM name
    dw 512 ; bytes per sector
    db 1 ; sectors per cluster
    dw 1 ; reserved sectors
    db 2 ; number of FATs
    dw 224 ; max root dir entries
    dw 2880 ; total sectors (for 1.44MB floppy)
    db 0xf0 ; media descriptor
    dw 9 ; sectors per FAT
    dw 18 ; sectors per track
    dw 2 ; number of heads
    dd 0 ; hidden sectors
    dd 0 ; large total sectors
    .extended:
        db 0 ; drive number
        db 0 ; reserved
        db 0x29 ; boot signature
        dd 0x12345678 ; volume ID
        db 'COMPACTOS  ' ; volume label
        db 'FAT12   ' ; file system type

printstr:
    pusha
    mov bl, 0x09
    .loop:
        lodsb
        cmp al, 0
        je .done
        mov ah, 0x0e
        int 0x10
        jmp .loop
    .done:
        popa
        ret

fatjmp:
    jmp 0x07c0:setup
setup:
    mov ax, 0x07c0
    mov ds, ax
    mov es, ax
    mov ax, 0x0800
    mov ss, ax
    mov si, bootmsg
    call printstr

halt:
    cli
    hlt

bootmsg: db 'Starting compactOS...', 0

times 510-($-$$) db 0
dw 0xaa55