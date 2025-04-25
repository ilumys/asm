# Assembly

For learning and writing Assembly across different architectures, using llvm

Linux syscall reference: [syscalls.mebeim.net](https://syscalls.mebeim.net/?table=x86/64/x64/latest)

## Running

x86_64 is built and tested for amd64 linux

For files with `.s` extensionn;

Build: `clang -Wall -g -masm=intel -c {file}.asm -o build/main.o`

Link: `ld.lld -o build/main build/main.o`

Files ending `.asm` have been written for NASM and can be built and executed with:
`nasm -f elf64 {file.asm} && ld.lld {file.o} && ./a.out`

If debugging, add `-F dwarf` to nasm call
