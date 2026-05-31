CC      = riscv64-elf-gcc
OBJDUMP = riscv64-elf-objdump
OBJCOPY = riscv64-elf-objcopy
HEXDUMP = hexdump

ARCH    = -march=rv32i
ABI     = -mabi=ilp32
CFLAGS  = -nostdlib -nostartfiles -ffreestanding
LDFLAGS = -Ttext=0

all: codigos.hex

# Compila e linka
main.elf: main.s
	$(CC) $(ARCH) $(ABI) $(CFLAGS) $(LDFLAGS) -o $@ $<

codigos.hex: main.elf
	$(OBJCOPY) -O binary --only-section=.text $< main.bin
	$(HEXDUMP) -v -e '1/4 "%08x\n"' main.bin > $@

clean:
	rm -f main.elf main.bin codigos.hex codigos.lst

.PHONY: all clean