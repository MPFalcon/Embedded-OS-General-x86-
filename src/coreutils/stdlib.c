#include "stdlib.h"

static void putchar(char chr)
{
    VGA_Write(chr);
}

void print(const char * _message)
{
    if (NULL == _message)
    {
        page_fault_handler();
    }

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
    for (uint32_t idx = 0; idx < size; idx++)
    {
        ((uint8_t *)new_ptr)[idx] = 0x00;
    }

    return new_ptr;
}

void free(void * ptr, uint32_t size)
{
    slab_free(ptr, size);
}

// EOF
