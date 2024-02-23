
all: eth.or32 eth-flash.or32 eth-xess-flash.or32

reset.o: reset.S Makefile
	or32-rtems-gcc -c -o reset.o reset.S

reset-flash.o: reset-flash.S Makefile
	or32-rtems-gcc -c -o reset-flash.o reset-flash.S

reset-xess-flash.o: reset-flash.S Makefile
	or32-rtems-gcc -c -DXESS -o reset-xess-flash.o reset-flash.S

uart.o: uart.c Makefile
	or32-rtems-gcc -O2 -c -o uart.o uart.c

uart-xess.o: uart.c Makefile
	or32-rtems-gcc -O2 -DXESS -c -o uart-xess.o uart.c

eth.o: eth.c Makefile
	or32-rtems-gcc -O2 -c -o eth.o eth.c

eth-xess.o: eth.c Makefile
	or32-rtems-gcc -O2 -DXESS -c -o eth-xess.o eth.c

dhry.o: dhry.c Makefile dhry.h
	or32-rtems-gcc -O2 -msoft-div -c -o dhry.o dhry.c

camera_test.o: camera_test.c Makefile
	or32-rtems-gcc -O2 -c -o camera_test.o camera_test.c

eth.or32: reset.o uart.o eth.o camera_test.o dhry.o Makefile
	or32-rtems-ld -Tram.ld -o eth.or32 reset.o uart.o eth.o camera_test.o dhry.o
	or32-rtems-objcopy -O binary eth.or32 eth.bin
	../utils/bin2flimg 4 eth.bin > eth.mem
	../utils/bin2srec eth.bin > eth.srec

eth-flash.or32: reset-flash.o uart.o eth.o camera_test.o dhry.o Makefile
	or32-rtems-ld -Txess.ld -o eth-flash.or32 reset-flash.o uart.o eth.o camera_test.o dhry.o
	or32-rtems-objcopy -O binary eth-flash.or32 eth-flash.bin
	../utils/bin2flimg 4 eth-flash.bin > /tmp/or32_flash.img
	../utils/bin2flimg 1 eth-flash.bin > eth-flash_byte.img

eth-xess-flash.or32: reset-xess-flash.o uart-xess.o eth-xess.o camera_test.o dhry.o Makefile
	or32-rtems-ld -Txess.ld -o eth-xess-flash.or32 reset-xess-flash.o uart-xess.o eth-xess.o camera_test.o dhry.o
	or32-rtems-objcopy -O binary eth-xess-flash.or32 eth-xess-flash.bin
	../utils/bin2flimg 1 eth-xess-flash.bin > eth-xess-flash_byte.img
	../utils/bin2srec eth-xess-flash.bin > eth-xess-flash.srec

clean:
	rm -f *.o *.or32  *.bin *.srec *.mem *.img
