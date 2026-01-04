#ifndef _HEAP_INIT_H
    #define _HEAP_INIT_H

    #include "stdint.h"

    extern void slab_init(void);
    extern void * slab_malloc(uint32_t size);
    extern void slab_free(void* ptr, uint32_t size);

#endif /* _HEAP_INIT_H */

// EOF
