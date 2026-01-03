#!/bin/bash

qemu-system-i386 -drive format=raw,file=bin/embedded_os.bin,index=0,if=floppy -m 128M

# EOF
