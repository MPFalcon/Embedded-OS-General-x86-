#include "stdlib.h"

static void putchar(char chr)
{
    x86_Video_WriteCharTeletype(chr);
}

void print(const char * _message)
{
    while (*_message)
    {
        putchar(*_message);
        _message++;
    }
}

// EOF
