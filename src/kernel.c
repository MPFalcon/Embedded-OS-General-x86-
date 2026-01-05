#include "coreutils/stdlib.h"

typedef struct embedded_object
{
    uint8_t byte_1;
    uint8_t byte_2;
    uint8_t byte_3;
    uint8_t byte_4;
} obj_t;

int main()
{
    slab_init();
    init_VGA();

    print("FalconOS will be booting shortly...\n\nThank you for using this firmware\n\n");

    char * mem = (char *)malloc(6);

    for (int idx = 0; idx < 30; idx++)
    {
        mem[0] = 'H';
        mem[1] = 'i';
        mem[2] = ' ';
        mem[3] = 'H';
        mem[4] = 'o';
        mem[5] = '\0';

        print(mem);

        free(mem, 6);
        mem = NULL;

        mem = (char *)malloc(6);
    }

    return 0;
}