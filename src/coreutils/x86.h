#ifndef _X86_H
    #define _X86_H

    #include "stdint.h"

    extern void x86_Video_WriteCharTeletype(char chr);
    extern void * malloc(uint32_t size);
    extern void init_sys();

#endif /* _X86_H */

// EOF
