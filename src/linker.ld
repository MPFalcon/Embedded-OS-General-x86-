/* Entry point of the kernel */
ENTRY(_start)

/* Memory layout for bare-metal kernel */
SECTIONS
{
    /* Start of code: kernel is loaded at 0x1000 */
    . = 0x001000;  /* 0x1000 */
    .text : {
        *(.text)    /* all code sections */
    }

    /* Initialized data (optional, usually very small in early kernel) */
    .data : {
        *(.data)
    }

    /* Align .bss to 1 MB */
    . = 0x00100000;  /* 1 MB */
    .bss : {
        *(.bss)
    }
}