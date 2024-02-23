
cases = cbasic-nocache-O0 cbasic-nocache-O2 cbasic-ic-O0 cbasic-ic-O2 cbasic-dc-O0 cbasic-dc-O2 cbasic-icdc-O0 cbasic-icdc-O2
common = ../support/libsupport.a

all: $(cases)

cbasic-nocache-O0: cbasic-O0.o ../support/reset-nocache.o $(common)
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

cbasic-nocache-O2: cbasic-O2.o ../support/reset-nocache.o $(common)
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

cbasic-ic-O0: cbasic-O0.o ../support/reset-ic.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 $(common)
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

cbasic-ic-O2: cbasic-O2.o ../support/reset-ic.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 $(common)
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

cbasic-dc-O0: cbasic-O0.o ../support/reset-dc.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 $(common)
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

cbasic-dc-O2: cbasic-O2.o ../support/reset-dc.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 $(common)
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

cbasic-icdc-O0: cbasic-O0.o ../support/reset-icdc.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 $(common)
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

cbasic-icdc-O2: cbasic-O2.o ../support/reset-icdc.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 $(common)
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

cbasic-O0.o: cbasic.c
	or32-uclinux-gcc -O0 $? -c -o $@

cbasic-O2.o: cbasic.c
	or32-uclinux-gcc -O2 $? -c -o $@

clean:
	rm -f *.o *.or32 *.log *.bin *.srec *.hex *.log stdout.txt
