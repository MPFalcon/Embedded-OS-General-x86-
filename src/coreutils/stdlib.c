#include "stdlib.h"

static void putchar(char chr)
{
    VGA_Write(chr);
}

void print(const char * _message)
{
    while (*_message)
    {
        putchar(*_message);
        _message++;
    }
}

void * malloc(uint32_t size)
{
    void * new_ptr = NULL;
    new_ptr = slab_malloc(size);

    return new_ptr;
}

void free(void * ptr, uint32_t size)
{
    slab_free(ptr, size);
}

// EOF
