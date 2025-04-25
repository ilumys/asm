BITS 64

global _start

section .data
        msg: db "hello", 0xa  ; define seq of bytes. 0xa is LF in ascii

section .text

_start:
        mov rax, 0x1  ; syscall=write
        mov rdi, 0x1  ; fd=stdout
        lea rsi, msg  ; buffer
        mov rdx, 6    ; num bytes
        syscall

        mov rax, 0x3c ; syscall=exit
        mov rdi, 0x0  ; exitcode
        syscall
