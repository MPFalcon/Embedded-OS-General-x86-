[BITS 32]
[global x86_Video_WriteCharTeletype]

x86_Video_WriteCharTeletype:
    push ebp
    mov  ebp, esp
    
    mov al, [ebp + 8]
    mov ah, 0x0f
    mov [0xb8000 + ecx], ax
    add ecx, 2

    .done:
        mov esp, ebp
        pop ebp
        ret

; EOF
