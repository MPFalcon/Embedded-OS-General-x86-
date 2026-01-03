[BITS 32]
[global x86_Video_WriteCharTeletype]
[global malloc]
[global init_sys]

VGA_LIMIT equ 0xf00
VGA_BASE equ 0xB8000
VGA_COLS equ 0xA0 ; 80 0x50
VGA_ROWS equ 0x30 ; 25 0x19
ATTR     equ 0x0F


section .bss
cursor_row:  resd 1
cursor_col:  resd 1
heap_start:  resb 0x1000   ; 4 KB heap (reserved memory)
heap_ptr:    resd 1        ; pointer to next free byte

section .text
x86_Video_WriteCharTeletype:
    push ebp
    mov  ebp, esp
    mov  al, [ebp+8]      ; character

    ; ----- handle '\n' -----
    cmp  al, 0x0a           ; '\n'
    je   .newline

    ; ----- handle '\r' -----
    cmp  al, 0x0d           ; '\r'
    je   .carriage

    ; ----- printable character -----
    mov  edx, [cursor_row]
    mov  ebx, VGA_COLS
    imul edx, ebx             ; eax = row * 80
    add  edx, [cursor_col]

    mov  ah, ATTR
    mov  [VGA_BASE + edx], ax

    add  dword [cursor_col], 2

    cmp  dword [cursor_col], (VGA_COLS * 2)
    jl   .done

.newline:
    mov  dword [cursor_col], 0
    inc  dword [cursor_row]
    jmp  .scroll_check

.carriage:
    mov  dword [cursor_col], 0
    jmp  .done

.scroll_check:
    cmp  dword [cursor_row], VGA_ROWS
    jl   .done

    ; simple wrap (no scrolling yet)
    mov  dword [cursor_row], 0

.done:
    pop  ebp
    ret

malloc:
    push ebx
    push ecx

    mov ebx, [heap_ptr]    ; current heap pointer
    mov ecx, eax           ; requested size

    add eax, ebx           ; calculate new pointer after allocation
    mov [heap_ptr], eax    ; bump the heap pointer

    mov eax, ebx           ; return old pointer as allocated block

    pop ecx
    pop ebx
    ret

init_sys:
    mov dword [cursor_col], 0
    mov dword [cursor_row], 0
    mov eax, heap_start    ; start of heap
    mov [heap_ptr], eax
    ret

; EOF
