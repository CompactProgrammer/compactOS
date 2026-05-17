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
findkernel:
    .findrootdir:
        mov ax, [fat12_bpb+0x16]
        mov bl, [fat12_bpb+0x10]
        mul bl
        inc ax
        mov [resandfats], ax
        call lbatochs
        push dx
    .getrootdirsectors:
        mov ax, [fat12_bpb+0x11]
        mov bx, 32
        mul bx
        mov bx, 512
        div bx
        mov [rootdirsize], ax
    .loadrootdir:
        pop dx
        mov ah, 0x02
        xor dh, dh
        push ax
        mov ax, 0x0100
        mov es, ax
        pop ax
        xor bx, bx
        int 0x13
        jc error
    .findkernelsetup:
        mov di, kernelname
        mov si, 0
        mov cx, [fat12_bpb+0x11]
    .findkernelloop:
        call cmpstrings
        jnc .foundkernel
        add si, 32
        loop .findkernelloop
        jmp error
    .foundkernel:
        add si, 26
        mov ax, [es:si]
        xor bx, bx
        mov bl, [fat12_bpb+0x0d]
        mul bx
        add ax, [resandfats]
        add ax, [rootdirsize]
        call lbatochs
    .loadkernel:
        mov ah, 0x02
        mov al, 4
        xor dh, dh
        push ax
        mov ax, 0x1000
        mov es, ax
        pop ax
        xor bx, bx
        int 0x13
        jc error
    .jumpkernel:
        jmp 0x1000:0

jmp halt

error:
    mov si, errormsg
    call printstr
halt:
    cli
    hlt

bootmsg: db 'Starting compactOS...', 0
errormsg: db 'ERROR', 0
kernelname: db 'KERNEL  EXE', 0
resandfats: dw 0
rootdirsize: dw 0

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

lbatochs:
    push ax
    push bx
    .sector:
        xor dx, dx
        mov bx, [fat12_bpb+0x18]
        div bx
        inc dx
        mov cl, dl
    .headandcylinder:
        xor dx, dx
        mov bx, [fat12_bpb+0x1a]
        div bx
        mov dh, dl
        mov ch, al
        shl al, 6
        or cl, al
    .done:
        pop bx
        pop ax
        ret

cmpstrings:
    pusha
    .loop:
        mov ah, [es:di]
        mov al, [ds:si]
        cmp ah, al
        jne .notfound
        cmp ah, 0
        je .done
        inc di
        inc si
        jmp .loop
    .notfound:
        stc
    .done:
        popa
        ret

times 510-($-$$) db 0
dw 0xaa55