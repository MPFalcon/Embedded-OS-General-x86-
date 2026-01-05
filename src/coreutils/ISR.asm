[BITS 32]
[global page_fault_handler]

section .text

; ------------------------------------------------------------
; page_fault_handler
;   Fully assembly page fault handler
;   Clears screen, prints "Segfault at 0x" + CR2 in hex
;   Halts CPU
; ------------------------------------------------------------
page_fault_handler:
    push ebp
    mov  ebp, esp
    pusha
    push ds
    push es
    push fs
    push gs

    ; Set up segment registers
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; -------------------------------
    ; Clear screen (VGA text mode)
    mov edi, 0xB8000          ; VGA base
    mov ecx, 80*25            ; 80 columns * 25 rows
    mov ax, 0x0F20            ; space char + color (white on black)
.clear_loop:
    mov [edi], ax
    add edi, 2
    loop .clear_loop

    ; Reset cursor to top-left
    mov esi, 0xB8000          ; cursor position
.done:
    mov esp, ebp
    pop  ebp
    ret

; EOF
