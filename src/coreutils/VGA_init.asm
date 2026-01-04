[BITS 32]
[global VGA_Write]
[global init_VGA]

; VGA (Screen) Constants
%define VGA_LIMIT 0xf00
%define VGA_BASE 0xB8000
%define VGA_COLS 0xA0
%define VGA_ROWS 0x30
%define ATTR     0x0F

section .bss
; VGA Cursors
cursor_row:  resd 1
cursor_col:  resd 1

section .text
VGA_Write:
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
    mov esp, ebp
    pop  ebp
    ret

init_VGA:
    mov dword [cursor_col], 0
    mov dword [cursor_row], 0
    ret

; EOF
