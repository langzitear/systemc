
all: tick-nocache tick-icdc


tick-nocache: tick.o ../support/reset-nocache.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

tick-icdc: tick.o ../support/reset-icdc.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

tick.o: tick.S
	or32-uclinux-gcc -O0 $? -I../support -c -o $@

clean:
	rm -f *.o *.or32 *.log *.bin *.hex
