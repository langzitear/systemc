
all: icm-nocache icm-icdc icm-ic icm-dc


icm-nocache: icm.o ../support/reset-nocache.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

icm-icdc: icm.o ../support/reset-icdc.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

icm-ic: icm.o ../support/reset-ic.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

icm-dc: icm.o ../support/reset-dc.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

icm.o: icm.S
	or32-uclinux-gcc -O0 $? -c -o $@

clean:
	rm -f *.o *.or32 *.log *.bin *.hex
