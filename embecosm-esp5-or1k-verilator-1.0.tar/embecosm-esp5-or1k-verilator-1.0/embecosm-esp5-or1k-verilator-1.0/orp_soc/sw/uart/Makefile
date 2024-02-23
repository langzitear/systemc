
cases = uart-nocache uart-icdc
common = ../support/libsupport.a

all: $(cases)

uart-nocache: uart.o ../support/reset-nocache.o $(common)
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

uart-icdc: uart.o ../support/reset-icdc.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 $(common)
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

uart.o: uart.c
	or32-uclinux-gcc -O2 $? -c -o $@

clean:
	rm -f *.o *.or32 *.log *.bin *.srec *.hex *.log stdout.txt
