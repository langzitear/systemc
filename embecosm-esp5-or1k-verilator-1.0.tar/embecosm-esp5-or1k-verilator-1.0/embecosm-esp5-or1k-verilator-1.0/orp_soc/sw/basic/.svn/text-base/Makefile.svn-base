
all: basic-nocache basic-icdc basic-ic basic-dc


basic-nocache: basic.o ../support/reset-nocache.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

basic-icdc: basic.o ../support/reset-icdc.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

basic-ic: basic.o ../support/reset-ic.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

basic-dc: basic.o ../support/reset-dc.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

basic.o: basic.S
	or32-uclinux-gcc -O0 $? -c -o $@

clean:
	rm -f *.o *.or32 *.log *.bin *.hex
