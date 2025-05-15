BITS 64

GLOBAL _start

%include 'println.asm'

SECTION .data

; continue to append NULL, as this 'append' hides two `write`s
; so it's not a real append by any means, but for appearances
; and learning to work with pointers, it's a start
str0: db "good day sir", 0x0
str1: db "having fun with memory?", 0x0

SECTION .text

_start:
	lea rsi, str0
	call fn_println
	lea rsi, str1
	call fn_println

	; exit
	mov rax, 0x3c
	mov rdi, 0x0
	syscall
