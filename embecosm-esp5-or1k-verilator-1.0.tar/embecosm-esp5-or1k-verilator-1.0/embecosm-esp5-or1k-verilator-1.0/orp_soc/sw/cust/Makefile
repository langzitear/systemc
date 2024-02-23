
cases = cust-nocache-O0 cust-nocache-O2 cust-ic-O0 cust-ic-O2 cust-dc-O0 cust-dc-O2 cust-icdc-O0 cust-icdc-O2
common = ../support/libsupport.a

all: $(cases)

cust-nocache-O0: cust-O0.o ../support/reset-nocache.o $(common)
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

cust-nocache-O2: cust-O2.o ../support/reset-nocache.o $(common)
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

cust-ic-O0: cust-O0.o ../support/reset-ic.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 $(common)
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

cust-ic-O2: cust-O2.o ../support/reset-ic.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 $(common)
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

cust-dc-O0: cust-O0.o ../support/reset-dc.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 $(common)
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

cust-dc-O2: cust-O2.o ../support/reset-dc.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 $(common)
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

cust-icdc-O0: cust-O0.o ../support/reset-icdc.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 $(common)
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

cust-icdc-O2: cust-O2.o ../support/reset-icdc.o
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32 $(common)
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

cust-O0.o: cust.c
	or32-uclinux-gcc -O0 $? -c -o $@

cust-O2.o: cust.c
	or32-uclinux-gcc -O2 $? -c -o $@

clean:
	rm -f *.o *.or32 *.log *.bin *.srec *.hex *.log stdout.txt
