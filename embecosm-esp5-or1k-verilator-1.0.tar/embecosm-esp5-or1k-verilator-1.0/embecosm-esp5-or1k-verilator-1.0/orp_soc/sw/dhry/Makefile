
cases = dhry-nocache-O0 dhry-nocache-O2 dhry-icdc-O2
common = ../support/libsupport.a

all: $(cases)

dhry-nocache-O0: dhry-O0.o ../support/reset-nocache.o $(common)
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

dhry-nocache-O2: dhry-O2.o ../support/reset-nocache.o $(common)
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

dhry-icdc-O2: dhry-O2.o ../support/reset-icdc.o $(common)
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

dhry-O0.o: dhry.c
	or32-uclinux-gcc -I../support -O0 $? -mhard-div -c -o $@

dhry-O2.o: dhry.c
	or32-uclinux-gcc -I../support -O2 $? -mhard-div -c -o $@

clean:
	rm -f *.o *.or32 *.log *.bin *.srec *.hex *.log stdout.txt
