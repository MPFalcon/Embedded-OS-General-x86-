#include "coreutils/stdlib.h"

int main()
{
    init_sys();
    print("FalconOS will be booting shortly...\n\nThank you for using this firmware\n\n");

    char * mem = (char *)malloc(5);
    mem[0] = 'H';
    mem[1] = 'i';
    mem[2] = ' ';
    mem[3] = 'H';
    mem[4] = 'o';


    print((const char *)mem);

    return 0;
}