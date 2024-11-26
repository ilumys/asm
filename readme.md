# Assembly

For learning and writing Assembly across different architectures, using llvm

Linux syscall reference: [syscalls.mebeim.net](https://syscalls.mebeim.net/?table=x86/64/x64/latest)

## Running

Build: `clang -Wall -g -masm=intel -c {file}.asm -o build/main.o`

Link: `ld.lld -o build/main build/main.o`

x86_64 is built and tested for amd64 linux

