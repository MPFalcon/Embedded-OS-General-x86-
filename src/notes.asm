[org 0x7c00] ; 0x7c00 Prints the entire string

mov ah, 0x0e ; 0x0e is TTY mode so screen can be interfaced with
mov ebx, os_name

print_os_name:
    mov al, [ebx] 
    cmp al, 0
    je print_os_name_exit
    int 0x10
    inc ebx
    jmp print_os_name
os_name:
    db '\nFalconOS', 0
print_os_name_exit:

mov ecx, 0x01

capture_input:
    ; System waiting for a key to be pressed
    ; mov ah, 0 to initialize
    ; int 0x16 interrupt code associated for capturing input
    ; - al = ASCII Character
    ; - ah = Scancode
    mov ah, 0
    mov edx, buffer
    int 0x16
    mov [edx], al
    inc edx
    mov ah, 0x0e
    int 0x10
    inc ecx
    cmp ecx, 0x0a
    jle capture_input
capture_input_exit:

; print_input:
;     mov al, [edx] 
;     cmp al, 0
;     je exit
;     int 0x10
;     inc edx
;     jmp print_input

buffer:
    times 10 db 0

exit:
    jmp $

; Pad bytes to boot sector
times 510-($-$$) db 0
dw 0xaa55

; EOF
