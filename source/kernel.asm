org 0x0000
bits 16
cpu 386

header:
    .jmp: jmp setup
    .sign: db 'EXE0' ; .EXE file signature
    .extrabytes: dw 0 ; number of bytes in last block
    .totalblocks: dw 4 ; total blocks in file
    .ddtentries: dw 4 ; number of data descriptor table entries
    .headsize: dw 2 ; size of header in paragraphs
    .ddt: dw ddt ; file offset of data descriptor table
    .bits: db 16 ; what bit mode the file is meant to be loaded in
    .reserved: times 14 db 0 ; reserved

; ddt entry types:
; 1 = code segment
; 2 = data segment (initialized from file)
; 3 = data segment (empty, to be zero-initialized by loader)
; 4 = stack segment

ddt:
    .code:
        db 1 ; data type
        db 0 ; reserved
        dw setup ; file offset of code segment
        dw 2048 ; size of code segment in bytes
        dw 0 ; relocated segment (set by loader)
    .generaldata:
        db 2 ; data type
        db 0 ; reserved
        dw 1024 ; file offset of data segment
        dw 512 ; size of data segment in bytes
        dw 0 ; relocated segment (set by loader)
    .moduletable:
        db 2 ; data type
        db 0 ; reserved
        dw 1536 ; file offset of module table
        dw 512 ; size of module table in bytes
        dw 0 ; relocated segment (set by loader)
    .stack:
        db 4 ; data type
        db 0 ; reserved
        dw 0 ; file offset of module table
        dw 512 ; size of stack in bytes
        dw 0 ; relocated segment (set by loader)

setup:
    mov ax, 0
    int 0x16
    mov ah, 0x0e
    int 0x10
    jmp setup

halt:
    cli
    hlt

times 1024-($-$$) db 0

times 1536-($-$$) db 0

moduletable:

times 2048-($-$$) db 0