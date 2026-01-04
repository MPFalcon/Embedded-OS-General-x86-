[BITS 32]

global page_fault_handler

section .data
msg_pf:     db "Segfault at 0x",0
hex_digits: db "0123456789ABCDEF"

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

    ; -------------------------------
    ; Print message "Segfault at 0x"
    mov esi, msg_pf
.next_char:
    lodsb
    test al, al
    jz .done_msg
    call putchar
    jmp .next_char
.done_msg:

    ; -------------------------------
    ; Print CR2 (faulting address) in hex
    mov eax, cr2
    mov ecx, 8
.print_hex:
    rol eax, 4                ; rotate high nibble into low 4 bits
    mov bl, al
    and bl, 0x0F
    mov al, [hex_digits + ebx]
    call putchar
    loop .print_hex

    ; Print newline
    mov al, 0x0A
    call putchar

    ; -------------------------------
    ; Halt CPU
.halt:
    hlt
    jmp .halt

; ------------------------------------------------------------
; Simple VGA putchar
; Writes AL to [ESI], increments ESI by 2
; Uses white on black (color 0x0F)
; ------------------------------------------------------------
putchar:
    push ebp
    mov  ebp, esp
    pusha
    mov ah, 0x0F               ; white on black
    mov [esi], ax
    add esi, 2
    popa
    mov esp, ebp
    pop  ebp
    ret

; EOF
