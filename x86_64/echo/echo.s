# ---------------------------------------
# echo

# build: clang -c echo.s -o build/main.s
# link: ld.lld -o build/main build/main.o
# ---------------------------------------

# swap to yasm or fasm? keep to this until strong basics, at least
# also, inline asm in c favours clang
.intel_syntax

.text
.global _start

_start:
    pop r10 # argc
    mov rdi, 1 # prep fd/stdout for syscall

# while argc is not 0
fn_iter:
    dec r10
    jz fn_exit # if ZF has been set, exit
    # iterate through argv

fn_exit:
    mov rax, 60
    mov rdi, 0
    syscall
