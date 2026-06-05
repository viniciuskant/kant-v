CC      = riscv64-elf-gcc
OBJDUMP = riscv64-elf-objdump
OBJCOPY = riscv64-elf-objcopy

ARCH    = -march=rv32i
ABI     = -mabi=ilp32
CFLAGS  = -nostdlib -nostartfiles -ffreestanding
LDFLAGS = -Ttext=0

all: codigos.hex

main.elf: main.s
	$(CC) $(ARCH) $(ABI) $(CFLAGS) $(LDFLAGS) -o $@ $<

codigos.hex: main.elf
	$(OBJDUMP) -d $< | \
	grep '^[[:space:]]*[0-9a-f]\+:' | \
	awk '{print $$2}' > $@

codigos.lst: main.elf
	$(OBJDUMP) -d $< > $@

clean:
	rm -f main.elf codigos.hex codigos.lst imediatos.hex

.PHONY: all clean