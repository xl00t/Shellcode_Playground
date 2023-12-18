CC := gcc
CFLAGS := -fno-stack-protector -z execstack -no-pie

NASM := nasm
NASMFLAGS := -f elf64

OBJCOPY := objcopy
OBJCOPYFLAGS := -O binary

SHELLCODES_DIR := shellcodes
SHELLCODES_SRC_DIR := $(SHELLCODES_DIR)/src
SHELLCODES_BUILD_DIR := $(SHELLCODES_DIR)/build
SHELLCODES_ASM_FILES := $(wildcard $(SHELLCODES_SRC_DIR)/*.asm)
SHELLCODES_OBJ_FILES := $(patsubst $(SHELLCODES_SRC_DIR)/%.asm,$(SHELLCODES_BUILD_DIR)/%.o,$(SHELLCODES_ASM_FILES))
SHELLCODES_BIN_FILES := $(patsubst $(SHELLCODES_SRC_DIR)/%.asm,$(SHELLCODES_BUILD_DIR)/%.bin,$(SHELLCODES_ASM_FILES))

.PHONY: all clean

all: runner shellcodes

runner: runner.c
	$(CC) $(CFLAGS) $< -o $@

shellcodes: $(SHELLCODES_BIN_FILES)

$(SHELLCODES_BUILD_DIR)/%.o: $(SHELLCODES_SRC_DIR)/%.asm
	$(NASM) $(NASMFLAGS) $< -o $@

$(SHELLCODES_BUILD_DIR)/%.bin: $(SHELLCODES_BUILD_DIR)/%.o
	$(OBJCOPY) $(OBJCOPYFLAGS) $< $@

clean:
	rm -f runner $(SHELLCODES_OBJ_FILES) $(SHELLCODES_BIN_FILES)
	find $(SHELLCODES_SRC_DIR) -type f -name '*.o' -delete

rebuild: clean all
