rm -r bins
mkdir bins
nasm -f bin source/boot.asm -o bins/boot.bin
nasm -f bin source/fat.asm -o bins/fat.bin
nasm -f bin source/rootdir.asm -o bins/rootdir.bin
nasm -f bin source/kernel.asm -o bins/kernel.bin
cat bins/boot.bin bins/fat.bin bins/rootdir.bin bins/kernel.bin > build/disk1.img