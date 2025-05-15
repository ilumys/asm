BITS 64

; fn_strlen
; 
; Arguments:
; rdx    contains pointer to string
;
; Returns:
; rdx    byte length of string
fn_strlen:
	mov r11, rdx ; copy mem address to r11

_strlen_nextchar:
	cmp byte [rdx], 0x0 ; check if current byte of string is NULL
	jz _strlen_calculate
	inc rdx
	jmp _strlen_nextchar

_strlen_calculate:
	sub rdx, r11
	ret

; fn_println
; Naive implementation of appending LINEFEED to a string and writing to stdout
;
; Arguments:
; rsi    string pointer
;
; Returns:
; void
fn_println:
	mov rdx, rsi	; copy str* to rdx
	call fn_strlen	; get length of existing string
	call sys_write

	mov rsi, 0xa	; rsi is four bytes, hence this will push `00 00 00 0a`
	push rsi	; onto the stack, and as the system is little endian
			; this will write starting `0a 00 ..`, thus we have a
			; 'new string' to print. dodgy, of course, but a neat
			; learning opportunity

	mov  rsi, rsp	; prep subsequent fn calls, setting our 'new' str pointer
	mov  rdx, rsi	; copy ptr to evaluate string length
	call fn_strlen
	call sys_write

	pop rsi
	ret

; system call wrapper
sys_write:
	mov rax, 0x1	; set syscall
	mov rdi, 0x1	; set fd
	syscall		; write
	ret
