; ============================================================
;  slab_allocator.asm
;  32-bit x86 NASM slab allocator for kernel / freestanding use
; ============================================================

[BITS 32]

; ------------------------------------------------------------
; Configuration
; ------------------------------------------------------------

%define SLAB32_SIZE     32
%define SLAB64_SIZE     64
%define SLAB128_SIZE    128

%define SLAB_COUNT      64        ; blocks per slab

; ------------------------------------------------------------
; Exports
; ------------------------------------------------------------

[global slab_init]
[global slab_malloc]
[global slab_free]

; ------------------------------------------------------------
; BSS: Slab storage + free lists
; ------------------------------------------------------------

section .bss
align 4

; ---- slab 32 ------------------------------------------------
slab32_mem:   resb SLAB32_SIZE  * SLAB_COUNT
slab32_free:  resd 1

; ---- slab 64 ------------------------------------------------
slab64_mem:   resb SLAB64_SIZE  * SLAB_COUNT
slab64_free:  resd 1

; ---- slab 128 -----------------------------------------------
slab128_mem:  resb SLAB128_SIZE * SLAB_COUNT
slab128_free: resd 1

; ------------------------------------------------------------
; TEXT
; ------------------------------------------------------------

section .text

; ------------------------------------------------------------
; slab_init
; Initializes all slab free lists
; ------------------------------------------------------------
slab_init:
    push ebp
    mov  ebp, esp

    ; init slab32
    mov eax, slab32_mem
    mov [slab32_free], eax
    mov ecx, SLAB_COUNT - 1
.s32_loop:
    add eax, SLAB32_SIZE
    mov [eax - SLAB32_SIZE], eax
    loop .s32_loop
    mov dword [eax], 0

    ; init slab64
    mov eax, slab64_mem
    mov [slab64_free], eax
    mov ecx, SLAB_COUNT - 1
.s64_loop:
    add eax, SLAB64_SIZE
    mov [eax - SLAB64_SIZE], eax
    loop .s64_loop
    mov dword [eax], 0

    ; init slab128
    mov eax, slab128_mem
    mov [slab128_free], eax
    mov ecx, SLAB_COUNT - 1
.s128_loop:
    add eax, SLAB128_SIZE
    mov [eax - SLAB128_SIZE], eax
    loop .s128_loop
    mov dword [eax], 0

    mov esp, ebp
    pop  ebp
    ret

; ------------------------------------------------------------
; slab_malloc
; IN : EAX = size
; OUT: EAX = pointer or 0
; ------------------------------------------------------------
slab_malloc:
    push ebp
    mov  ebp, esp

    mov eax, [ebp+8]
    cmp eax, SLAB32_SIZE
    jbe .alloc32
    cmp eax, SLAB64_SIZE
    jbe .alloc64
    cmp eax, SLAB128_SIZE
    jbe .alloc128
    xor eax, eax
    mov esp, ebp
    pop  ebp
    ret

.alloc32:
    mov eax, [slab32_free]
    test eax, eax
    jz .fail
    mov edx, [eax]
    mov [slab32_free], edx
    mov esp, ebp
    pop  ebp
    ret

.alloc64:
    mov eax, [slab64_free]
    test eax, eax
    jz .fail
    mov edx, [eax]
    mov [slab64_free], edx
    mov esp, ebp
    pop  ebp
    ret

.alloc128:
    mov eax, [slab128_free]
    test eax, eax
    jz .fail
    mov edx, [eax]
    mov [slab128_free], edx
    mov esp, ebp
    pop  ebp
    ret

.fail:
    xor eax, eax
    mov esp, ebp
    pop  ebp
    ret

; ------------------------------------------------------------
; slab_free
; IN:
;   EAX = pointer returned by slab_malloc
;   ECX = original allocation size
; ------------------------------------------------------------
slab_free:
    push ebp
    mov  ebp, esp

    mov eax, [ebp+8]
    mov ecx, [ebp+12]
    cmp ecx, SLAB32_SIZE
    jbe .free32
    cmp ecx, SLAB64_SIZE
    jbe .free64
    cmp ecx, SLAB128_SIZE
    jbe .free128
    mov esp, ebp
    pop  ebp
    ret

.free32:
    mov edx, [slab32_free]
    mov [eax], edx
    mov [slab32_free], eax
    mov esp, ebp
    pop  ebp
    ret

.free64:
    mov edx, [slab64_free]
    mov [eax], edx
    mov [slab64_free], eax
    mov esp, ebp
    pop  ebp
    ret

.free128:
    mov edx, [slab128_free]
    mov [eax], edx
    mov [slab128_free], eax
    mov esp, ebp
    pop  ebp
    ret



; EOF
