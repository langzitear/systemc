#include "board.h"
#include "uart.h"


#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)

#define WAIT_FOR_XMITR \
        do { \
                lsr = REG8(UART_BASE + UART_LSR); \
        } while ((lsr & BOTH_EMPTY) != BOTH_EMPTY)

#define WAIT_FOR_THRE \
        do { \
                lsr = REG8(UART_BASE + UART_LSR); \
        } while ((lsr & UART_LSR_THRE) != UART_LSR_THRE)

#define CHECK_FOR_CHAR (REG8(UART_BASE + UART_LSR) & UART_LSR_DR)

#define WAIT_FOR_CHAR \
         do { \
                lsr = REG8(UART_BASE + UART_LSR); \
         } while ((lsr & UART_LSR_DR) != UART_LSR_DR)

#define UART_TX_BUFF_LEN 32
#define UART_TX_BUFF_MASK (UART_TX_BUFF_LEN -1)

char tx_buff[UART_TX_BUFF_LEN];
volatile int tx_level, rx_level;

void uart_init(void)
{
        int devisor;
 
        /* Reset receiver and transmiter */
        REG8(UART_BASE + UART_FCR) = UART_FCR_ENABLE_FIFO | UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT | UART_FCR_TRIGGER_14;
 
        /* Disable all interrupts */
        REG8(UART_BASE + UART_IER) = 0x00;
 
        /* Set 8 bit char, 1 stop bit, no parity */
        REG8(UART_BASE + UART_LCR) = UART_LCR_WLEN8 & ~(UART_LCR_STOP | UART_LCR_PARITY);
 
        /* Set baud rate */
        devisor = IN_CLK/(16 * UART_BAUD_RATE);
        REG8(UART_BASE + UART_LCR) |= UART_LCR_DLAB;
        REG8(UART_BASE + UART_DLL) = devisor & 0x000000ff;
        REG8(UART_BASE + UART_DLM) = (devisor >> 8) & 0x000000ff;
        REG8(UART_BASE + UART_LCR) &= ~(UART_LCR_DLAB);
 
        return;
}

void uart_putc(char c)
{
        unsigned char lsr;
        
        WAIT_FOR_THRE;
        REG8(UART_BASE + UART_TX) = c;
        if(c == '\n') {
          WAIT_FOR_THRE;
          REG8(UART_BASE + UART_TX) = '\r';
        }
        WAIT_FOR_XMITR;
}

void uart_print_str(char *p)
{
        while(*p != 0) {
                uart_putc(*p);
                p++;
        }
}


void uart_print_long(unsigned long ul)
{
  int i;
  char c;

  
  uart_print_str("0x");
  for(i=0; i<8; i++) {

  c = (char) (ul>>((7-i)*4)) & 0xf;
  if(c >= 0x0 && c<=0x9)
    c += '0';
  else
    c += 'a' - 10;
  uart_putc(c);
  }

}


void uart_print_short(unsigned long ul)
{
  int i;
  char c;
  char flag=0;

  
  uart_print_str("0x");
  for(i=0; i<8; i++) {

  c = (char) (ul>>((7-i)*4)) & 0xf;
  if(c >= 0x0 && c<=0x9)
    c += '0';
  else
    c += 'a' - 10;
  if ((c != '0') || (i==7))
    flag=1;
  if(flag)
    uart_putc(c);
  }

}



char uart_getc()
{
        unsigned char lsr;
        char c;

        WAIT_FOR_CHAR;
        c = REG8(UART_BASE + UART_RX);
        return c;
}

