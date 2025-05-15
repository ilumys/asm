BITS 64

GLOBAL _start

SECTION .data
str: db "string of some length", 0xa, 0x0 ; terminate with NULL byte

SECTION .text

_start:
	lea rdx, str	; load pointer into rdx
	call fn_strlen	; call function

	mov rax, 0x1	; syscall = write
	lea rsi, str
	mov rdi, 0x1	; fd = stdout
	syscall

	mov rax, 0x3c	; syscall = exit
	mov rdi, 0x0
	syscall

; fn_strlen
; Takes a pointer to a string and returns its length in bytes
;
; Arguments:
; rdx    string pointer
;
; Returns:
; rdx    number of bytes
;
fn_strlen:
	mov r11, rdx	; copy pointer from rdx to r11

_nextchar:			; a poor man's for loop
	cmp byte [rdx], 0x0	; compare current byte to NULL
	jz _calculate		; if byte[rsi] and 0x0 are equal, jump
	inc rdx			; else, move to next byte
	jmp _nextchar		; repeat

_calculate:
	sub rdx, r11	; pointer arithmetic. subtract addr in r11 (which
			; points to the zeroth byte) from rdx (which has
			; been incremented to the last byte), finally
			; returning the number of bytes used
	ret
; end fn_strlen
