
all: except-nocache except-icdc

except-nocache: except_test_s.o except_test.o
	or32-uclinux-gcc -Wall -g -nostdlib -mhard-div -T../support/orp.ld -o $@.or32 ../support/reset-nocache.o except_test_s.o except_test.o ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

except-icdc: except_test_s.o except_test.o
	or32-uclinux-gcc -Wall -g -nostdlib -mhard-div -T../support/orp.ld -o $@.or32 ../support/reset-icdc.o except_test_s.o except_test.o ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

except_test.o: except_test.c Makefile
	or32-uclinux-gcc -I../support -g -O2 -c -o except_test.o except_test.c -Wall -g -nostdlib -mhard-div

except_test_s.o: except_test_s.S Makefile
	or32-uclinux-gcc -I../support -g -c -o except_test_s.o except_test_s.S -Wall -g -nostdlib -mhard-div

except.o: except.S Makefile
	or32-uclinux-gcc -I../support -g -c -o except.o except.S  -Wall -g -nostdlib -mhard-div

clean:
	rm -rf *.o *.bin *.hex *.srec *.or32 *.log stdout.txt

