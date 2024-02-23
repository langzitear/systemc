#define REG8(x) (*(volatile unsigned char *)(x))
#define REG32(x) (*(volatile unsigned long *)(x))

#ifdef XESS
#define MC_ENABLED	    0
#else
#define MC_ENABLED	    1
#endif
#define IC_ENABLE 	    0

#define MC_CSR_VAL      0x0B000300
#define MC_MASK_VAL     0x000000e0
#define FLASH_BASE_ADD  0x04000000
#define FLASH_TMS_VAL   0x0010a10a
#define SDRAM_BASE_ADD  0x00000000
#define SDRAM_TMS_VAL   0x07248230

#ifdef XESS
#define IN_CLK  	      10000000
#else
#define IN_CLK  	      25000000
#endif

#ifdef XESS
#define UART_BAUD_RATE 	19200
#else
#define UART_BAUD_RATE 	9600 /* 115200 */
#endif

#define UART_BASE  	    0x90000000
#ifdef XESS
#define ETH_BASE	0x92000000
#else
#define ETH_BASE        0xD0000000
#endif
#define MC_BASE_ADD     0x60000000
 
#define ETH0_INT	_int_main	/* was:    0x00080000 */  /* Not correct */

/*#define ETH_DATA_BASE   0x00020000   Address for ETH_DATA */
 #define ETH_DATA_BASE   0xa8000000 /*  Address for ETH_DATA */
#define ETH_MACADDR0	0x00
#define ETH_MACADDR1	0x09
#define ETH_MACADDR2	0x12
#define ETH_MACADDR3	0x34
#define ETH_MACADDR4	0x56
#define ETH_MACADDR5	0x00

