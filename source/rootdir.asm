file0:
    .name: db 'KERNEL  '
    .ext: db 'EXE'
    .attr: db 0b00000111
    .reserved: db 0
    .timems: db 0
    .time: dw 0
    .date: dw 0
    .access: dw 0
    .eaindex: dw 0
    .modtime: dw 0
    .moddate: dw 0
    .startcluster: dw 2
    .filesize: dd 2048

times 7168-($-$$) db 0