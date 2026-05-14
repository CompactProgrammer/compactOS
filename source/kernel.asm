org 0x0000
bits 16
cpu 386

header:
    .sign: db 'EX16' ; .EXE file signature
    .extrabytes: dw 0 ; number of bytes in last page
    .totalblocks: dw 4 ; total blocks in file
    .ddtentries: dw 0 ; number of data descriptor entries
    .headsize: dw 2 ; size of header in paragraphs
    .minalloc: dw 64 ; minimum paragraphs needed
    .reqalloc: dw 128 ; paragraphs requested
    .ddt: dw ddt ; file offset of data descriptor table
    .stacksize: dw 0 ; size of stack in paragraphs
    .reserved: times 12 db 0 ; reserved

; ddt entry types:
; 1 = code segment
; 2 = data segment (initialized from file)
; 3 = data segment (empty, to be zero-initialized by loader)

ddt:
    .code:
        db 1 ; data type
        db 0 ; reserved
        dw setup ; file offset of code segment
        dw 2048 ; size of code segment in bytes
        dw 0 ; relocated segment (set by loader)
    .generaldata:
        db 3 ; data type
        db 0 ; reserved
        dw 0 ; file offset of data segment
        dw 512 ; size of data segment in bytes
        dw 0 ; relocated segment (set by loader)
    .moduletable:
        db 2 ; data type
        db 0 ; reserved
        dw 1536 ; file offset of module table
        dw 512 ; size of module table in bytes
        dw 0 ; relocated segment (set by loader)

setup:

halt:
    cli
    hlt

times 1536-($-$$) db 0

moduletable:

times 2048-($-$$) db 0