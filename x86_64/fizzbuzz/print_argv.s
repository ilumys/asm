.intel_syntax

#---------------- DATA ----------------#
    .data
    # We need buf_for_itoa to be large enough to contain a 64-bit integer.
    # endbuf_for_itoa will point to the end of buf_for_itoa and is useful
    # for passing to itoa.
    .set BUFLEN, 32
buf_for_itoa:
    .space BUFLEN, 0x0
    .set endbuf_for_itoa, buf_for_itoa + BUFLEN - 1
newline_str:
    .asciz "\n"
argc_str:
    .asciz "argc: "


#---------------- CODE ----------------#
    .globl _start
    .text
_start:
    # On entry to _start, argc is in (%rsp), argv[0] in 8(%rsp),
    # argv[1] in 16(%rsp) and so on.
    lea rdi, argc_str
    call print_cstring

    mov r12, [rsp]               # save argc in r12

    # Convert the argc value to a string and print it out
    mov rdi, r12
    lea rsi, endbuf_for_itoa
    call itoa
    mov rdi, rax
    call print_cstring
    lea rdi, newline_str
    call print_cstring

    # In a loop, pick argv[n] for 0 <= n < argc and print it out,
    # followed by a newline. r13 holds n.
    xor r13, r13

.L_argv_loop:
    mov rdi, [rsp + r13 * 8 + 8]      # argv[n] is in (rsp + 8 + 8*n)
    call print_cstring
    lea rdi, newline_str
    call print_cstring
    inc r13
    cmp r13, r12
    jl .L_argv_loop

    # exit(0)
    mov rax, 60
    mov rdi, 0
    syscall

# Function print_cstring
#   Print a null-terminated string to stdout.
# Arguments:
#   rdi     address of string
# Returns: void
print_cstring:
    # Find the terminating null
    mov r10, rdi
.L_find_null:
    cmp byte ptr [r10], 0
    je .L_end_find_null
    inc r10
    jmp .L_find_null
.L_end_find_null:
    # r10 points to the terminating null. so r10-rdi is the length
    sub r10, rdi

    # Now that we have the length, we can call sys_write
    # sys_write(unsigned fd, char* buf, size_t count)
    mov rax, 1
    # Populate address of string into rsi first, because the later
    # assignment of fd clobbers rdi.
    mov rsi, rdi
    mov rdi, 1
    mov rdx, r10
    syscall
    ret

# Function itoa
#   Convert an integer to a null-terminated string in memory.
#   Assumes that there is enough space allocated in the target
#   buffer for the representation of the integer. Since the number itself
#   is accepted in the register, its value is bounded.
# Arguments:
#   rdi:    the integer
#   rsi:    address of the *last* byte in the target buffer
# Returns:
#   rax:    address of the first byte in the target string that
#           contains valid information.
itoa:
    mov byte ptr [rsi], 0        # Write the terminating null and advance.

    # If the input number is negative, we mark it by placing 1 into r9
    # and negate it. In the end we check if r9 is 1 and add a '-' in front.
    mov r9, 0
    cmp rdi, 0
    jge .L_input_positive
    neg rdi
    mov r9, 1
.L_input_positive:

    mov rax, rdi          # Place the number into rax for the division.
    mov r8, 10            # The base is in r8

.L_next_digit:
    # Prepare rdx:rax for division by clearing rdx. rax remains from the
    # previous div. rax will be rax / 10, rdx will be the next digit to
    # write out.
    xor rdx, rdx
    div r8
    # Write the digit to the buffer, in ascii
    dec rsi
    add dl, 0x30
    mov [rsi], dl

    cmp rax, 0            # We're done when the quotient is 0.
    jne .L_next_digit

    # If we marked in r9 that the input is negative, it's time to add that
    # '-' in front of the output.
    cmp r9, 1
    jne .L_itoa_done
    dec rsi
    mov byte ptr [rsi], 2

.L_itoa_done:
    mov rax, rsi          # rsi points to the first byte now; return it.
    ret
