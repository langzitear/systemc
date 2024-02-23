all: libsupport.a reset-nocache.o reset-ic.o reset-dc.o reset-icdc.o

libsupport.a: support.o int.o except.o
	or32-uclinux-ar cru libsupport.a support.o except.o int.o
	or32-uclinux-ranlib libsupport.a

support.o: support.c
	or32-uclinux-gcc -mhard-div -O2 -c -o $@ $?

reset-nocache.o: reset.S
	or32-uclinux-gcc -mhard-div -O2 -c -DIC=0 -DDC=0 -o $@ $?

reset-dc.o: reset.S
	or32-uclinux-gcc -mhard-div -O2 -c -DIC=0 -DDC=1 -o $@ $?

reset-ic.o: reset.S
	or32-uclinux-gcc -mhard-div -O2 -c -DIC=1 -DDC=0 -o $@ $?

reset-icdc.o: reset.S
	or32-uclinux-gcc -mhard-div -O2 -c -DIC=1 -DDC=1 -o $@ $?

except.o: except.S
	or32-uclinux-gcc -mhard-div -O2 -c -o $@ $?

int.o: int.c
	or32-uclinux-gcc -mhard-div -O2 -c -o $@ $?

clean:
	rm -rf *.o *.a
