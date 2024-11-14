# hello world in x64 assembly

# entry point
.global _start

# label, not function, but naming convenience
_start:
    mov rdi, 19 # length of string
    lea rsi, l_hi # load address of string into rsi
    call fn_print
    mov rdi, 0 # set exit code
    jmp fn_exit

# parameters:
#   rdi: length of string
#   rsi: string to print
fn_print:
    # prepare to syscall write
    mov rax, 1
    # write takes fd in rdi, buf in rsi, and count in rdx
    mov rdx, rdi
    mov rdi, 1
    syscall # now execute
    ret

# does what it says
# prefer to set exit code where you have context
# not that I am conditionally setting it here, but practice
fn_exit:
    mov rax, 60
    syscall

l_hi:
    .ascii "Hello, from world!\n"
