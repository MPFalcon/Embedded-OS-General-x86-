MEMORY
{
    FLASH (rw) : ORIGIN = 0x00001000, LENGTH = 128K
    RAM (rwx) : ORIGIN = 0x00100000, LENGTH = 20K
}

/* Entry point of the kernel */
ENTRY(_start)
/* Memory layout for bare-metal kernel */
SECTIONS
{
    /* Start of code: kernel is loaded at 0x1000 */
    .text : {
        *(.text)    /* all code sections */
        *(.rodata)
        . = ALIGN(4);
    } > FLASH

    /* Initialized data (optional, usually very small in early kernel) */
    .data : {
        . = ALIGN(4);
        *(.data)
        . = ALIGN(4);
    } > RAM

    /* Align .bss to 1 MB */
    .bss : {
        . = ALIGN(4);
        *(.bss)
        *(.COMMON)
        . = ALIGN(4);
    } > RAM
}