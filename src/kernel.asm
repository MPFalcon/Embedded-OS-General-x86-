[BITS 32]
[global _start]
[extern main]

_start:
    call main
.hang:
    hlt
    jmp .hang

; EOF
