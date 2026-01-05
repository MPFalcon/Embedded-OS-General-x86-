CROSS_PREFIX := cross-compiler/out/cross/bin/i386-elf
CC := gcc
C_FLAGS := -ffreestanding -m32 -O0 -g -fno-omit-frame-pointer -fno-optimize-sibling-calls
LD := ld
LD_SCRIPT := linker
ASM := nasm
KERNEL := kernel
BOOT := boot
BUILD_DIR := build
BIN_DIR := bin
SRC := src
FIRMWARE_FILE := custom_firmware.bin
FINAL_FILE := embedded_os.bin

EXTRA_FILES= heap_init VGA_init ISR
EXTRA_FILES_INPUT = $(BUILD_DIR)/heap_init.o $(BUILD_DIR)/VGA_init.o $(BUILD_DIR)/ISR.o

merge_firmware: make_bin_dir build_boot build_complete_kernel
	dd if=/dev/zero of="$(BUILD_DIR)/zeros.bin" bs=10240 count=1 seek=1 conv=notrunc
	cat "$(BUILD_DIR)/$(BOOT).bin" "$(BUILD_DIR)/$(KERNEL).bin" > "$(BUILD_DIR)/$(FIRMWARE_FILE)"
	cat "$(BUILD_DIR)/$(FIRMWARE_FILE)" "$(BUILD_DIR)/zeros.bin" > "$(BIN_DIR)/$(FINAL_FILE)"

build_complete_kernel: assemble_kernel_entry compile_kernel_body assemble_extras assemble_std
	$(CROSS_PREFIX)-$(LD) -o "$(BUILD_DIR)/$(KERNEL).bin" \
	-T $(SRC)/$(LD_SCRIPT).ld "$(BUILD_DIR)/$(KERNEL)_entry.o" \
	"$(BUILD_DIR)/$(KERNEL).o" $(EXTRA_FILES_INPUT) "$(BUILD_DIR)/stdlib.o" --oformat binary

	$(CROSS_PREFIX)-$(LD) -o "$(BUILD_DIR)/$(KERNEL).elf" \
	-T $(SRC)/$(LD_SCRIPT).ld "$(BUILD_DIR)/$(KERNEL)_entry.o" \
	"$(BUILD_DIR)/$(KERNEL).o" $(EXTRA_FILES_INPUT) "$(BUILD_DIR)/stdlib.o" --oformat elf32-i386

assemble_extras: make_build_dir
	@for f in $(EXTRA_FILES); do \
		$(ASM) "$(SRC)/coreutils/$$f.asm" -f elf -o "$(BUILD_DIR)/$$f.o"; \
	done

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
