# ----------------------------
# fizzbuzz in x64 assembly
# usage: fizzbuzz [number]
#
# counts from 1 to n, printing 'fizz' if the number is divisible by three,
# 'buzz' if the number is divisible by five, and 'fizzbuzz' if the number
# is divisible by both three and five
# ----------------------------

.intel_syntax

.text
.global _start

# registers consumed:
# r10: argc
# r8: argv
# r9: counter

_start:
    pop r10 # argc
    cmp r10, 2
    jne _exit # if argc != 2, exit
    mov r8, qword ptr [rsp + 8] # copy argv[1], where displacement = 8 bytes

    # prep gpr's for div
    mov r11, 3
    mov r12, 5

    # prep count for syscall
    # need a better way of handling this
    # currently is very unrealiable. transform to buffer
    mov rdx, 2

    mov r9, 1 # set counter

# iterate from 1 to argv[1]
_iter:
    cmp r9, r8
    je _exit
    xor rax, rax
    xor rdx, rdx
    mov rax, r9 # load counter into rdx
    div r11
    cmp rdx, 0 # check flags to see if rax is evenly divisible by 3
    jnz _buzz # if remainder != 0, jump past fizz

_fizz:
    mov rax, r9
    div r12
    cmp rdx, 0
    jz _fizzbuzz # if also evenly divisible by 5
    lea rsi, l_fizz
    mov rdi, 6
    jmp _print

_buzz:
    xor rax, rax
    xor rdx, rdx
    mov rax, r9
    div r12
    cmp rdx, 0
    jnz _num # if neither evenly divisible by 3 or 5
    lea rsi, l_buzz
    mov rdi, 6
    jmp _print

_fizzbuzz:
    lea rsi, l_fizzbuzz
    mov rdi, 10
    jmp _print

_num:
    mov rsi, r9
    mov rdi, 2

_print:
    mov rax, 1 # write
    mov rdi, 1 # fd = stdout
    syscall
    inc r9
    jmp _iter

_exit:
    mov rax, 60
    mov rdi, 0
    syscall

l_fizz:
    .ascii "fizz\n"
l_buzz:
    .ascii "buzz\n"
l_fizzbuzz:
    .ascii "fizzbuzz\n"
