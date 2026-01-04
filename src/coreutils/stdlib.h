#ifndef _STDLIB_H
    #define _STDLIB_H
    
    #include "stdint.h"
    #include "heap_init.h"
    #include "VGA_init.h"
    
    void print(const char * _message);
    void * malloc(uint32_t size);
    void free(void * ptr, uint32_t size);

#endif /* _STDLIB_H */

// EOF
