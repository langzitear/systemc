
cases = mul-nocache-O0 mul-nocache-O2 mul-ic-O0 mul-ic-O2 mul-dc-O0 mul-dc-O2 mul-icdc-O2 mul-icdc-O0
common = ../support/libsupport.a

all: $(cases)

mul-nocache-O0: mul-O0.o ../support/reset-nocache.o $(common)
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

mul-nocache-O2: mul-O2.o ../support/reset-nocache.o $(common)
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

mul-ic-O0: mul-O0.o ../support/reset-ic.o $(common)
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

mul-ic-O2: mul-O2.o ../support/reset-ic.o $(common)
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

mul-dc-O0: mul-O0.o ../support/reset-dc.o $(common)
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

mul-dc-O2: mul-O2.o ../support/reset-dc.o $(common)
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

mul-icdc-O0: mul-O0.o ../support/reset-icdc.o $(common)
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

mul-icdc-O2: mul-O2.o ../support/reset-icdc.o  $(common)
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

mul-O0.o: mul.c
	or32-uclinux-gcc -I../support -O0 $? -c -o $@

mul-O2.o: mul.c
	or32-uclinux-gcc -I../support -O2 $? -c -o $@

clean:
	rm -f *.o *.or32 *.log *.bin *.hex *.log stdout.txt 
