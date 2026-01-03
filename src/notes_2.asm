; ================================
; Minimal x86 Bootloader
; ================================

[BITS 16]
[ORG 0x7C00]

banner:
    mov ah, 0x0e ; 0x0e is TTY mode so screen can be interfaced with
    mov bx, os_name
print_os_name:
    mov al, [bx] 
    cmp al, 0
    je print_os_name_exit
    int 0x10
    inc bx
    jmp print_os_name
os_name:
    db "FalconOS will be booting shortly...", 0
print_os_name_exit:

start:
    cli                 ; Disable interrupts

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00      ; Stack grows downward

; ----------------
; Load the GDT
; ----------------
    lgdt [gdt_descriptor]

; ----------------
; Enter protected mode
; ----------------
    mov eax, cr0
    or eax, 1           ; Set PE bit
    mov cr0, eax

    jmp CODE_SEL:protected_mode   ; FAR jump required

; ================================
; GDT
; ================================

; Global Descriptor Table (GDT) is needed to for Protected Mode
; Describes a list of properties
; Using the Flat Memory Model where memory is contiguous

; Code Segment Descriptor
; Base ~= loc = 0 (32 bits)
; Limit ~= size = 0xfffff (20 bits)

; Present = 1 for used segments
; Privilege = 00 | 01 | 10 | 11 = 00 ("ring")
; Type = 1 if code OR data segment

; Flags - Boolean 1 or 0
; Sets of flags
; - Type flags (4 bits)
; - Other flags (4 bits)

; Type flags = 1010
; Code? Yes, thus: 1
; Conforming: 0
; Readable: 1 to read constants
; Accessed: Managed by CPU: 0

; Other flags = 1100
; Granularity 1 => limit *= 0x1000
; 32 bits: 1
; Last two is NULL

; Data Segment Descriptor
; pres, priv, type = 1001
; Type flags = 0010
; Other flags = 1100

gdt_start:
    null_desc:
        dd 0
        dd 0
    code_desc:
        dw 0xffff ; limit: 0xfffff
        dw 0 ; 16 bits + - pres, priv, type (p,p,t) = 1001
        db 0 ; 8 bits = 24 - Type flags = 1010
    ; Other flags = 1100

        db 10011010b ; p,p,t and type flags
        db 11001111b ; Other + limit (last four bits for padding)
        db 0 ; base
    data_desc:
        dw 0xffff
        dw 0
        db 0
        db 10010010b
        db 11001111b
        db 0
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size
    dd gdt_start ; start

CODE_SEL equ code_desc - gdt_start
DATA_SEL equ data_desc - gdt_start

; ================================
; Protected Mode
; ================================
[BITS 32]
protected_mode:
    mov ax, DATA_SEL
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; Print the letter 'a' in protected mode
    mov al, 0x41
    mov ah, 0x0f
    mov [0xb8000], ax

hang:
    hlt
    jmp hang

; ================================
; Boot sector padding + signature
; ================================
times 510 - ($ - $$) db 0
dw 0xAA55
