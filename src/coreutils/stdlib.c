#include "stdlib.h"

static void putchar(char chr)
{
    x86_Video_WriteCharTeletype(chr);
}

void print(const char * _message)
{
    __asm__ volatile ("mov $0, %%ecx" ::: "ecx");
    while (*_message)
    {
        putchar(*_message);
        _message++;
    }
    __asm__ volatile ("xor %%ecx, %%ecx" ::: "ecx");
}

// EOF
