
all: mmu-nocache mmu-icdc

mmu-nocache: mmu_asm.o mmu.o except.o
	or32-uclinux-gcc -Wall -g -nostdlib -mhard-div -T../support/orp.ld -o $@.or32 ../support/reset-nocache.o except.o mmu_asm.o mmu.o ../support/libsupport.a 
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

mmu-icdc: mmu_asm.o mmu.o except.o
	or32-uclinux-gcc -Wall -g -nostdlib -mhard-div -T../support/orp.ld -o $@.or32 ../support/reset-icdc.o except.o mmu_asm.o mmu.o ../support/libsupport.a 
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

mmu.o: mmu.c Makefile
	or32-uclinux-gcc -O2 -I../support -c -o mmu.o mmu.c -Wall -g -nostdlib -mhard-div

mmu_asm.o: mmu_asm.S Makefile
	or32-uclinux-gcc -I../support -c -o mmu_asm.o mmu_asm.S -Wall -g -nostdlib -mhard-div

except.o: except.S Makefile
	or32-uclinux-gcc -I../support -c -o except.o except.S  -Wall -g -nostdlib -mhard-div

clean:
	rm -rf *.o *.or32 *.bin *.hex *.log stdout.txt

