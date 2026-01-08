#include "coreutils/stdlib.h"

typedef enum status_flags
{
    SINGLE = 0x01,
    DEGREE = 0x02,
    AWAY = 0x04,
    MODEL = 0x08,
} flags_t;

typedef struct __attribute__((packed)) embedded_object
{
    uint8_t name[12];
    uint32_t status_flag;
} obj_t;

obj_t new_object;
char mem[6];

int main()
{
    slab_init();
    init_VGA();
    
    print("FalconOS will be booting shortly...\n\nThank you for using this firmware\n\n");


    for (int idx = 0; idx < 1; idx++)
    {
        mem[0] = 'H';
        mem[1] = 'i';
        mem[2] = ' ';
        mem[3] = 'H';
        mem[4] = 'o';
        mem[5] = '\0';

        print(mem);
    }

    // print(mem);

    char name[] = "HELLO U";
    for (int idx = 0; idx < 7; idx++)
    {
        new_object.name[idx] = name[idx];
    }
    new_object.status_flag = (SINGLE | MODEL);

    print(new_object.name);

    return 0;
}

// EOF
