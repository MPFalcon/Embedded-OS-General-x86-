CROSS_PREFIX := cross-compiler/out/cross/bin/i386-elf
CC := gcc
C_FLAGS := -ffreestanding -m32 -g
LD := ld
ASM := nasm
KERNEL := kernel
BOOT := boot
BUILD_DIR := build
BIN_DIR := bin
SRC := src
FIRMWARE_FILE := custom_firmware.bin
FINAL_FILE := embedded_os.bin

merge_firmware: make_bin_dir build_boot build_complete_kernel
	dd if=/dev/zero of="$(BUILD_DIR)/zeros.bin" bs=10240 count=1 seek=1 conv=notrunc
	cat "$(BUILD_DIR)/$(BOOT).bin" "$(BUILD_DIR)/$(KERNEL).bin" > "$(BUILD_DIR)/$(FIRMWARE_FILE)"
	cat "$(BUILD_DIR)/$(FIRMWARE_FILE)" "$(BUILD_DIR)/zeros.bin" > "$(BIN_DIR)/$(FINAL_FILE)"

build_complete_kernel: assemble_kernel_entry compile_kernel_body assemble_extras assemble_std
	$(CROSS_PREFIX)-$(LD) -o "$(BUILD_DIR)/$(KERNEL).bin" \
	-Ttext 0x1000 "$(BUILD_DIR)/$(KERNEL)_entry.o" \
	"$(BUILD_DIR)/$(KERNEL).o" "$(BUILD_DIR)/heap_init.o" "$(BUILD_DIR)/VGA_init.o" "$(BUILD_DIR)/stdlib.o" --oformat binary

	$(CROSS_PREFIX)-$(LD) -o "$(BUILD_DIR)/$(KERNEL).elf" \
	-Ttext 0x1000 "$(BUILD_DIR)/$(KERNEL)_entry.o" \
	"$(BUILD_DIR)/$(KERNEL).o" "$(BUILD_DIR)/heap_init.o" "$(BUILD_DIR)/VGA_init.o" "$(BUILD_DIR)/stdlib.o" --oformat elf32-i386

assemble_extras: make_build_dir
	$(ASM) "$(SRC)/coreutils/heap_init.asm" -f elf -o "$(BUILD_DIR)/heap_init.o"
	$(ASM) "$(SRC)/coreutils/VGA_init.asm" -f elf -o "$(BUILD_DIR)/VGA_init.o"

assemble_std: make_build_dir
	$(CROSS_PREFIX)-$(CC) $(C_FLAGS) -c "$(SRC)/coreutils/stdlib.c" -o "$(BUILD_DIR)/stdlib.o"

assemble_kernel_entry: make_build_dir
	$(ASM) "$(SRC)/$(KERNEL).asm" -f elf -o "$(BUILD_DIR)/$(KERNEL)_entry.o"

compile_kernel_body: make_build_dir
	$(CROSS_PREFIX)-$(CC) $(C_FLAGS) -c "$(SRC)/$(KERNEL).c" -o "$(BUILD_DIR)/$(KERNEL).o"

build_boot: make_build_dir
	$(ASM) -f bin $(SRC)/$(BOOT).asm -o $(BUILD_DIR)/$(BOOT).bin

make_build_dir:
	mkdir -p $(BUILD_DIR)/

make_bin_dir:
	mkdir -p $(BIN_DIR)/

clean:
	rm -rf $(BIN_DIR)/
	rm -rf $(BUILD_DIR)/

all: merge_firmware

rebuild: clean all

# EOF
