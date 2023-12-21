CC := gcc
CFLAGS := -fno-stack-protector -z execstack -no-pie

NASM := nasm


SHELLCODES_DIR := shellcodes
SHELLCODES_SRC_DIR := $(SHELLCODES_DIR)/src
SHELLCODES_BUILD_DIR := $(SHELLCODES_DIR)/build
SHELLCODES_ASM_FILES := $(wildcard $(SHELLCODES_SRC_DIR)/*.asm)
SHELLCODES_BIN_FILES := $(patsubst $(SHELLCODES_SRC_DIR)/%.asm,$(SHELLCODES_BUILD_DIR)/%.bin,$(SHELLCODES_ASM_FILES))

.PHONY: all clean

all: runner shellcodes

runner: runner.c
	$(CC) $(CFLAGS) $< -o $@

shellcodes: $(SHELLCODES_BIN_FILES)

$(SHELLCODES_BUILD_DIR)/%.bin: $(SHELLCODES_SRC_DIR)/%.asm
	$(NASM) $(NASMFLAGS) $< -o $@

clean:
	rm -f runner $(SHELLCODES_BIN_FILES)

rebuild: clean all
