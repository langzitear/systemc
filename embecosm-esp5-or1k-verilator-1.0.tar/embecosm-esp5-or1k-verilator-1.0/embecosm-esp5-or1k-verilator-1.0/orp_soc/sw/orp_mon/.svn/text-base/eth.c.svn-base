#include "board.h"
#include "uart.h"
#include "eth.h"
#include "spr_defs.h"

extern void lolev_ie(void);
extern void lolev_idis(void);

int tx_pointer_index = 0;
unsigned long dest_mac_addr[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};

unsigned long strtoul(char *s)
{
  int base = 10;
  char *ptmp;
  unsigned long val = 0;
  unsigned long digit = 1;
  
  ptmp = s;
  while (*ptmp != '\0')
    if (*ptmp++ == 'x')
      base = 16;
      
  while (ptmp-- != s)
    if ((*ptmp >= '0') &&
        (*ptmp <= '9'))
    {
        val += (*ptmp - '0') * digit;
        digit *= base;
    }
    else
    if ((*ptmp >= 'a') &&
        (*ptmp <= 'f'))
    {
        val += (*ptmp - 'a' + 10) * digit;
        digit *= base;
    }

  return val;
}

int strcmp (const char *s1, const char *s2)
{

  while (*s1 != '\0' && *s1 == *s2)
  {
    s1++;
    s2++;
  }
  
  return (*(unsigned char *) s1) - (*(unsigned char *) s2);                      
}

void eth_init(void)
{
  /* Reset ethernet core */
  REG32(ETH_REG_BASE + ETH_MODER) = 0x0;              /* 0 */
  REG32(ETH_REG_BASE + ETH_MODER) |= ETH_MODER_RST;   /* Reset ON */
  REG32(ETH_REG_BASE + ETH_MODER) &= ~ETH_MODER_RST;  /* Reset OFF */

  /* Setting RX_BD base to 0x80 */
  REG32(ETH_REG_BASE + ETH_RX_BD_NUM) = 0x00000080;

  /* RxEn, TxEn, Promisc, IFG, CRCEn */
  REG32(ETH_REG_BASE + ETH_MODER) |= ETH_MODER_RXEN | ETH_MODER_TXEN | ETH_MODER_PRO | ETH_MODER_CRCEN | ETH_MODER_PAD;

  /* Set local MAC address */
  REG32(ETH_REG_BASE + ETH_MAC_ADDR1) = ETH_MACADDR0 << 8 |
  					ETH_MACADDR1;
  REG32(ETH_REG_BASE + ETH_MAC_ADDR0) = ETH_MACADDR2 << 24 |
  					ETH_MACADDR3 << 16 |
  					ETH_MACADDR4 << 8 |
  					ETH_MACADDR5;

  return;
}

void init_tx_bd_pool(int max)
{

  int cnt, i;
  
  for(i=0; i<=max; i++){

    /* Set Tx BD status */
    REG32( ETH_BD_BASE + ((i*2) << 2) ) = ETH_TX_BD_PAD | ETH_TX_BD_CRC | ETH_RX_BD_IRQ;

    if(i==max)
      REG32( ETH_BD_BASE + ((i*2) << 2) ) |= ETH_TX_BD_WRAP; // Last Tx BD - Wrap

    /* Initialize Tx BD pointer */
    REG32( ETH_BD_BASE + ((1+i*2) << 2) ) = ETH_DATA_BASE + i * ETH_MAXBUF_LEN;
  }
}



void show_tx_bd(int start, int max)
{

  int cnt, i;
  
  for(i=start; i<=max; i++){

    /* Read Tx BD */
    uart_print_str("LEN:");
    uart_print_short(REG32(ETH_BD_BASE + (i << 3)) >> 16);
    uart_print_str(" RD:");
    uart_print_short((REG32(ETH_BD_BASE + (i << 3)) >> 15) & 0x1);
    uart_print_str(" IRQ:");
    uart_print_short((REG32(ETH_BD_BASE + (i << 3)) >> 14) & 0x1);
    uart_print_str(" WR:");
    uart_print_short((REG32(ETH_BD_BASE + (i << 3)) >> 13) & 0x1);
    uart_print_str(" PAD:");
    uart_print_short((REG32(ETH_BD_BASE + (i << 3)) >> 12) & 0x1);
    uart_print_str(" CRC:");
    uart_print_short((REG32(ETH_BD_BASE + (i << 3)) >> 11) & 0x1);
    uart_print_str(" UR:");
    uart_print_short((REG32(ETH_BD_BASE + (i << 3)) >> 8) & 0x1);
    uart_print_str(" RTRY:");
    uart_print_short((REG32(ETH_BD_BASE + (i << 3)) >> 4) & 0xf);
    uart_print_str(" RL:");
    uart_print_short((REG32(ETH_BD_BASE + (i << 3)) >> 3) & 0x1);
    uart_print_str(" LC:");
    uart_print_short((REG32(ETH_BD_BASE + (i << 3)) >> 2) & 0x1);
    uart_print_str(" DF:");
    uart_print_short((REG32(ETH_BD_BASE + (i << 3)) >> 1) & 0x1);
    uart_print_str(" CS:");
    uart_print_short((REG32(ETH_BD_BASE + (i << 3)) >> 0) & 0x1);
    uart_print_str("\nTx Buffer Pointer: ");
    uart_print_long(REG32(ETH_BD_BASE + (i << 3) + 4));
    uart_print_str("\n");
  }
}




void show_rx_bd(int start, int max)
{

  int cnt, i;
  
  unsigned long rx_bd_base, rx_bd_num;

  rx_bd_num =  REG32(ETH_REG_BASE + ETH_RX_BD_NUM);
  rx_bd_base = ETH_BD_BASE + (rx_bd_num << 2);

  for(i=start; i<=max; i++){

    /* Read Rx BD */
    uart_print_str("LEN:");
    uart_print_short(REG32(rx_bd_base + (i << 3)) >> 16);
    uart_print_str(" E:");
    uart_print_short((REG32(rx_bd_base + (i << 3)) >> 15) & 0x1);
    uart_print_str(" IRQ:");
    uart_print_short((REG32(rx_bd_base + (i << 3)) >> 14) & 0x1);
    uart_print_str(" WR:");
    uart_print_short((REG32(rx_bd_base + (i << 3)) >> 13) & 0x1);
    uart_print_str(" M:");
    uart_print_short((REG32(rx_bd_base + (i << 3)) >> 7) & 0x1);
    uart_print_str(" OR:");
    uart_print_short((REG32(rx_bd_base + (i << 3)) >> 6) & 0x1);
    uart_print_str(" IS:");
    uart_print_short((REG32(rx_bd_base + (i << 3)) >> 5) & 0x1);
    uart_print_str(" DN:");
    uart_print_short((REG32(rx_bd_base + (i << 3)) >> 4) & 0x1);
    uart_print_str(" TL:");
    uart_print_short((REG32(rx_bd_base + (i << 3)) >> 3) & 0x1);
    uart_print_str(" SF:");
    uart_print_short((REG32(rx_bd_base + (i << 3)) >> 2) & 0x1);
    uart_print_str(" CRC:");
    uart_print_short((REG32(rx_bd_base + (i << 3)) >> 1) & 0x1);
    uart_print_str(" LC:");
    uart_print_short((REG32(rx_bd_base + (i << 3)) >> 0) & 0x1);
    uart_print_str("\nRx Buffer Pointer: ");
    uart_print_long(REG32(rx_bd_base + (i << 3) + 4));
    uart_print_str("\n");
  }
}

void show_mem(int start, int stop)
{

  unsigned long i;

  if (((i = start) & 0xf) != 0x0)
    {
      uart_print_str("\n");
      uart_print_long(i);
      uart_print_str(": ");
    }
  for(; i<=stop; i += 4){
    if ((i & 0xf) == 0x0)
    {
      uart_print_str("\n");
      uart_print_long(i);
      uart_print_str(": ");
    }

    /* Read one word */
    uart_print_long(REG32(i));
    uart_print_str(" ");
  }
  uart_print_str("\n");
}

void ic_enable()
{
	unsigned long addr;
	unsigned long sr;

	/* Invalidate IC */
	for (addr = 0; addr < 8192; addr += 16)
		asm("l.mtspr r0,%0,%1": : "r" (addr), "i" (SPR_ICBIR));  
  
	/* Enable IC */
	asm("l.mfspr %0,r0,%1": "=r" (sr) : "i" (SPR_SR));
	sr |= SPR_SR_ICE;
	asm("l.mtspr r0,%0,%1": : "r" (sr), "i" (SPR_SR));  
	asm("l.nop");
	asm("l.nop");
	asm("l.nop");
	asm("l.nop");
}

void ic_disable()
{
	unsigned long addr;
	unsigned long sr;

  /* Disable IC */
	asm("l.mfspr %0,r0,%1": "=r" (sr) : "i" (SPR_SR));
	sr &= ~SPR_SR_ICE;
	asm("l.mtspr r0,%0,%1": : "r" (sr), "i" (SPR_SR));  
	asm("l.nop");
	asm("l.nop");
	asm("l.nop");
	asm("l.nop");
}


void dc_enable()
{
	unsigned long addr;
	unsigned long sr;

	/* Invalidate DC */
	for (addr = 0; addr < 8192; addr += 16)
		asm("l.mtspr r0,%0,%1": : "r" (addr), "i" (SPR_DCBIR));  
  
	/* Enable DC */
	asm("l.mfspr %0,r0,%1": "=r" (sr) : "i" (SPR_SR));
	sr |= SPR_SR_DCE;
	asm("l.mtspr r0,%0,%1": : "r" (sr), "i" (SPR_SR));  
	asm("l.nop");
	asm("l.nop");
	asm("l.nop");
	asm("l.nop");
}

void dc_disable()
{
	unsigned long addr;
	unsigned long sr;

  /* Disable DC */
	asm("l.mfspr %0,r0,%1": "=r" (sr) : "i" (SPR_SR));
	sr &= ~SPR_SR_DCE;
	asm("l.mtspr r0,%0,%1": : "r" (sr), "i" (SPR_SR));  
	asm("l.nop");
	asm("l.nop");
	asm("l.nop");
	asm("l.nop");
}

void cmd_mfspr(unsigned long addr)
{
  unsigned long val;

  /* Read SPR */
  asm("l.mfspr %0,%1,0": "=r" (val) : "r" (addr));

  uart_print_str("\nSPR ");
  uart_print_short(addr);
  uart_print_str(": ");
  uart_print_long(val);
}

void cmd_mtspr(unsigned long addr, unsigned long val)
{

  /* Write SPR */
  asm("l.mtspr %0,%1,0": : "r" (addr), "r" (val));
  cmd_mfspr(addr);
}


void init_rx_bd_pool(int max)
{

  int cnt, i;
  unsigned long rx_bd_base, rx_bd_num;

  rx_bd_num =  REG32(ETH_REG_BASE + ETH_RX_BD_NUM);
  rx_bd_base = ETH_BD_BASE + (rx_bd_num << 2);

  for(i=0; i<=max; i++){

    /* Initialize Rx BD pointer */
    REG32( rx_bd_base + ((1+i*2) << 2) ) = ETH_DATA_BASE + (rx_bd_num + i) * ETH_MAXBUF_LEN;

     /* Set Rx BD status */
    REG32( rx_bd_base + ((i*2) << 2) ) = ETH_RX_BD_IRQ;         

    if(i==max)
      REG32( rx_bd_base + ((i*2) << 2) ) |= ETH_RX_BD_WRAP; // Last Rx BD - Wrap

    REG32( rx_bd_base + ((i*2) << 2) ) |= ETH_RX_BD_EMPTY;  // Empty

  }
}


void show_buffer(unsigned long start_addr, unsigned long len)
{
  show_mem(start_addr, start_addr + len - 1);
}

void show_rx_buffs(int max, int show_all)
{

  int i;
  unsigned long rx_bd_base, rx_bd_num;

  rx_bd_num =  REG32(ETH_REG_BASE + ETH_RX_BD_NUM);
  rx_bd_base = ETH_BD_BASE + (rx_bd_num << 2);

  for(i=0; i<=max; i++)
  {
    if (!(REG32(rx_bd_base + (i << 3)) & ETH_RX_BD_EMPTY) || show_all)
    {
      uart_print_str("Rx BD No. ");
      uart_print_short(i);
      uart_print_str(" located at ");
      uart_print_long(rx_bd_base + (i << 3));
      uart_print_str("\n");
      show_rx_bd(i, i);
      show_buffer(REG32(rx_bd_base + (i << 3) + 4), REG32(rx_bd_base + (i << 3)) >> 16);
      uart_print_str("\n");
    }
    if (REG32(rx_bd_base + (i << 3)) & ETH_RX_BD_WRAP)
      return;
  }
}



void show_tx_buffs(int max)
{

  int i;

  for(i=0; i<=max; i++)
  {
    if (1)
    {
      uart_print_str("Tx BD No. ");
      uart_print_short(i);
      uart_print_str(" located at ");
      uart_print_long(ETH_BD_BASE + (i << 3));
      uart_print_str("\n");
      show_tx_bd(i, i);
      show_buffer(REG32(ETH_BD_BASE + (i << 3) + 4), REG32(ETH_BD_BASE + (i << 3)) >> 16);
      uart_print_str("\n");
    }
    if (REG32(ETH_BD_BASE + (i << 3)) & ETH_TX_BD_WRAP)
      return;
  }
}




void send_packet (unsigned long len, unsigned long start_data)
{
  unsigned long i, TxBD, data;

  /* Set dest & src address */
  data = dest_mac_addr[0] << 24 |
         dest_mac_addr[1] << 16 |
         dest_mac_addr[2] << 8  |
         dest_mac_addr[3] << 0;
  REG32(ETH_DATA_BASE + 0 + ETH_MAXBUF_LEN * tx_pointer_index) = data;
  data = dest_mac_addr[4] << 24 |
         dest_mac_addr[5] << 16 |
         ETH_MACADDR0     << 8  |
         ETH_MACADDR1     << 0;
  REG32(ETH_DATA_BASE + 4 + ETH_MAXBUF_LEN * tx_pointer_index) = data;
  data = ETH_MACADDR2     << 24 |
         ETH_MACADDR3     << 16 |
         ETH_MACADDR4     << 8  |
         ETH_MACADDR5     << 0;
  REG32(ETH_DATA_BASE + 8 + ETH_MAXBUF_LEN * tx_pointer_index) = data;

  /* Write data to buffer */
  for(i=12; i<len; i+=4){

    data = (i+start_data-12)<<24 | (i+start_data+1-12)<<16 |
    	(i+start_data+2-12)<<8 | (i+start_data+3-12); 
    REG32(ETH_DATA_BASE + i + ETH_MAXBUF_LEN * tx_pointer_index) = data;
  }

  /* Set BD status */
  TxBD = REG32(ETH_BD_BASE + (tx_pointer_index<<3)) & 0xffff; 
  REG32(ETH_BD_BASE + (tx_pointer_index<<3)) = (len<<16) | TxBD | ETH_TX_BD_READY;

  if(TxBD & ETH_TX_BD_WRAP)    // Wrap ?
    tx_pointer_index = 0;
  else
    tx_pointer_index++;
}


void show_mac_regs (void)
{

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_MODER);
  uart_print_str(" MODER: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_MODER));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_INT);
  uart_print_str(" INT: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_INT));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_INT_MASK);
  uart_print_str(" INT_MASK: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_INT_MASK));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_IPGT);
  uart_print_str(" IPGT: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_IPGT));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_IPGR1);
  uart_print_str(" IPGR1: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_IPGR1));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_IPGR2);
  uart_print_str(" IPGR2: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_IPGR2));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_PACKETLEN);
  uart_print_str(" PACKETLEN: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_PACKETLEN));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_COLLCONF);
  uart_print_str(" COLLCONF: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_COLLCONF));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_RX_BD_NUM);
  uart_print_str(" RX_BD_NUM: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_RX_BD_NUM));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_CTRLMODER);
  uart_print_str(" CTRLMODER: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_CTRLMODER));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_MIIMODER);
  uart_print_str(" MIIMODER: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_MIIMODER));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_MIICOMMAND);
  uart_print_str(" MIICOMMAND: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_MIICOMMAND));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_MIIADDRESS);
  uart_print_str(" MIIADDRESS: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_MIIADDRESS));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_MIITX_DATA);
  uart_print_str(" MIITX_DATA: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_MIITX_DATA));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_MIIRX_DATA);
  uart_print_str(" MIIRX_DATA: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_MIIRX_DATA));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_MIISTATUS);
  uart_print_str(" MIISTATUS: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_MIISTATUS));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_MAC_ADDR0);
  uart_print_str(" MAC_ADDR0: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_MAC_ADDR0));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_MAC_ADDR1);
  uart_print_str(" MAC_ADDR1: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_MAC_ADDR1));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_HASH_ADDR0);
  uart_print_str(" ETH_HASH_ADDR0: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_HASH_ADDR0));

  uart_print_str("\n ");
  uart_print_long(ETH_REG_BASE + ETH_HASH_ADDR1);
  uart_print_str(" ETH_HASH_ADDR1: ");
  uart_print_long(REG32(ETH_REG_BASE + ETH_HASH_ADDR1));

  uart_print_str("\n");
}



void show_phy_reg (unsigned long start_addr, unsigned long stop_addr)
{

  unsigned long addr;

  if (start_addr == stop_addr)
  {
    uart_print_str("\nSet MII RGAD ADDRESS to ");
    uart_print_long(start_addr);
    uart_print_str("\nMII Command = Read Status\n");
  }

  for (addr = start_addr; addr <= stop_addr; addr++)
  {
    REG32(ETH_REG_BASE + ETH_MIIADDRESS) = addr<<8;
    REG32(ETH_REG_BASE + ETH_MIICOMMAND) = ETH_MIICOMMAND_RSTAT;

    uart_print_str("\nMII RX_DATA: ");
    uart_print_long(REG32(ETH_REG_BASE + ETH_MIIRX_DATA));

    uart_print_str("\n");
  }
}

void set_phy_reg (unsigned long addr, unsigned long val)
{
  uart_print_str("\nSet MII RGAD ADDRESS to ");
  uart_print_long(addr);

  REG32(ETH_REG_BASE + ETH_MIIADDRESS) = addr<<8;

  uart_print_str("\nMII Command = Write Control Data\n");
  REG32(ETH_REG_BASE + ETH_MIICOMMAND) = ETH_MIICOMMAND_WCTRLDATA;

  REG32(ETH_REG_BASE + ETH_MIITX_DATA) = val;

  show_phy_reg(addr, addr);
}

void testram (unsigned long start_addr, unsigned long stop_addr, unsigned long testno)
{
  unsigned long addr;
  unsigned long err_addr;
  unsigned long err_no = 0;

  /* Test 1: Write locations with their addresses */
  if ((testno == 1) || (testno == 0))
  {
    uart_print_str("\n1. Writing locations with their addresses: ");
    for (addr = start_addr; addr <= stop_addr; addr += 4)
      REG32(addr) = addr;

    /* Verify */
    for (addr = start_addr; addr <= stop_addr; addr += 4)
      if (REG32(addr) != addr)
      {
        err_no++;
        err_addr = addr;
      }
    if (err_no)
    {
      uart_print_short(err_no);
      uart_print_str(" times failed. Last at location ");
      uart_print_long(err_addr);
    } else
      uart_print_str("Passed");
    err_no = 0;
  }

  /* Test 2: Write locations with their inverse address */
  if ((testno == 2) || (testno == 0))
  {
    uart_print_str("\n2. Writing locations with their inverse addresses: "); 
    for (addr = start_addr; addr <= stop_addr; addr += 4)
      REG32(addr) = ~addr;
 
    /* Verify */
    for (addr = start_addr; addr <= stop_addr; addr += 4)
      if (REG32(addr) != ~addr)
      {
        err_no++;
        err_addr = addr;
      }
    if (err_no)
    {
      uart_print_short(err_no);
      uart_print_str(" times failed. Last at location ");
      uart_print_long(err_addr);
    } else
      uart_print_str("Passed");
    err_no = 0;
  }

  /* Test 3: Write locations with walking ones */
  if ((testno == 3) || (testno == 0))
  {
    uart_print_str("\n3. Writing locations with walking ones: ");
    for (addr = start_addr; addr <= stop_addr; addr += 4)
      REG32(addr) = 1 << (addr >> 2);
 
    /* Verify */
    for (addr = start_addr; addr <= stop_addr; addr += 4)
      if (REG32(addr) != (1 << (addr >> 2)))
      {
        err_no++;
        err_addr = addr;
      }
    if (err_no)
    {
      uart_print_short(err_no);
      uart_print_str(" times failed. Last at location ");
      uart_print_long(err_addr);
    } else
      uart_print_str("Passed");
    err_no = 0;
  }

  /* Test 4: Write locations with walking zeros */
  if ((testno == 4) || (testno == 0))
  {
    uart_print_str("\n4. Writing locations with walking zeros: ");
    for (addr = start_addr; addr <= stop_addr; addr += 4)
      REG32(addr) = ~(1 << (addr >> 2));
 
    /* Verify */
    for (addr = start_addr; addr <= stop_addr; addr += 4)
      if (REG32(addr) != ~(1 << (addr >> 2)))
      {
        err_no++;
        err_addr = addr;
      }
    if (err_no)
    {
      uart_print_short(err_no);
      uart_print_str(" times failed. Last at location ");
      uart_print_long(err_addr);
    } else
      uart_print_str("Passed");
    err_no = 0;
  }
}

void eth_int_enable(void)
{
  /* Enable exception recognition, external interrupts */
  lolev_ie();

  /* Enabled IRQs: Tx buffer, Tx error, Rx buffer, Rx error, Rx BD busy */
  REG32(ETH_REG_BASE + ETH_INT_MASK) |= ETH_INT_MASK_TXB | ETH_INT_MASK_TXE | ETH_INT_MASK_RXF | ETH_INT_MASK_RXE | ETH_INT_MASK_BUSY;
}

void crt_enable();
void crt_disable();
void crt_test();
void camera_enable();
void camera_disable();

void mon_command()
{
  char c = '\0';
  char str[1000];
  char *pstr = str;
  char cmd[100];
  char *ptmp;
  char sarg[100];
  unsigned long iarg[5];
  int args = 0;

  /* Show prompt */
#ifdef XESS
  uart_print_str("\norp-xsv> ");
#else
  uart_print_str("\nbender> ");
#endif
  
  /* Get characters from UART */
  c = uart_getc();
  while (c != '\r' && c != '\f' && c != '\n')
  {
    if (c == '\b')
      pstr--;
    else
      *pstr++ = c;
    uart_putc(c);
    c = uart_getc();
  }
  *pstr = '\0';
  uart_print_str("\n");
  
  /* Get command from the string */
  pstr = str;
  ptmp = cmd;
  while (*pstr != '\0' && *pstr != ' ')
    *ptmp++ = *pstr++;
  *ptmp = '\0';

  /* Go to first argument */
  while (*pstr == ' ')
    pstr++;
  
  /* Get argument 1 from the string */
  ptmp = sarg;
  if (*pstr)
    args++;
  while (*pstr != '\0' && *pstr != ' ')
    *ptmp++ = *pstr++;
  *ptmp = '\0';
  
  /* Change argument 1 to unsigned long */
  if (sarg[0])
    iarg[0] = strtoul(sarg);

  /* Go to next argument */
  while (*pstr == ' ')
    pstr++;
  
  /* Get argument 2 from the string */
  ptmp = sarg;
  if (*pstr)
    args++;
  while (*pstr != '\0' && *pstr != ' ')
    *ptmp++ = *pstr++;
  *ptmp = '\0';
  
  /* Change argument 2 to unsigned long */
  if (sarg[0])
    iarg[1] = strtoul(sarg);

  /* Go to next argument */
  while (*pstr == ' ')
    pstr++;
  
  /* Get argument 3 from the string */
  ptmp = sarg;
  if (*pstr)
    args++;
  while (*pstr != '\0' && *pstr != ' ')
    *ptmp++ = *pstr++;
  *ptmp = '\0';
  
  /* Change argument 3 to unsigned long */
  if (sarg[0])
    iarg[2] = strtoul(sarg);

  
  /* Process command and arguments by executing
     specific function. */
  if (strcmp(cmd, "help") == 0)
    {
      uart_print_str("dm <start addr> [<end addr>] ");
      uart_print_str("- display memory location 32-bit\n");
      uart_print_str("pm <addr> [<stop_addr>] <value> ");
      uart_print_str("- patch memory location 32-bit\n");
      uart_print_str("ic_enable - enable instruction cache\n");
      uart_print_str("ic_disable - disable instruction cache\n");
      uart_print_str("dc_enable - enable data cache\n");
      uart_print_str("dc_disable - disable data cache\n");
      uart_print_str("mfspr <spr_addr> - show SPR\n");
      uart_print_str("mtspr <spr_addr> <value> - set SPR\n");
      uart_print_str("eth_init - init ethernet\n");
      uart_print_str("dhry [<num_runs>] - run dhrystone\n");
      uart_print_str("show_txbd [<start BD>] [<max>] ");
      uart_print_str("- show Tx buffer desc\n");
      uart_print_str("show_rxbd [<start BD>] [<max>] ");
      uart_print_str("- show Rx buffer desc\n");
      uart_print_str("send_packet <length> [<start data>]");
      uart_print_str("- create & send packet\n");
      uart_print_str("set_dest_addr <addrhi> <addrmid> <addrlo>");
      uart_print_str("- set destination address (for send_packet)\n");
      uart_print_str("init_txbd_pool <max> ");
      uart_print_str("- initialize Tx buffer descriptors\n");
      uart_print_str("init_rxbd_pool <max> ");
      uart_print_str("- initialize Rx buffer descriptors\n");
      uart_print_str("show_phy_reg [<start_addr>] [<end addr>]");
      uart_print_str("- show PHY registers\n");
      uart_print_str("set_phy_reg <addr> <value>");
      uart_print_str("- set PHY register\n");
      uart_print_str("show_mac_regs ");
      uart_print_str("- show all MAC registers\n");
      uart_print_str("eth_int_enable ");
      uart_print_str("- enable ethernet interrupt\n");
      uart_print_str("show_rx_buffs [<show_all>] ");
      uart_print_str("- show receive buffers (optional arg will also show empty buffers)\n");
      uart_print_str("show_tx_buffs ");
      uart_print_str("- show transmit buffers\n");
      uart_print_str("testram <start_addr> <stop_addr> [<test_no>]");
      uart_print_str("- run a simple RAM test\n"); 
      uart_print_str("crt_enable");
      uart_print_str("- enables CRT\n");
      uart_print_str("crt_disable");
      uart_print_str("- disables CRT\n");
      uart_print_str("crt_test");
      uart_print_str("- enables CRT and displays some test patterns\n");
      uart_print_str("camera_enable");
      uart_print_str("- enables camera\n");
      uart_print_str("camera_disable");
      uart_print_str("- disables camera\n");
    }
  else if (strcmp(cmd, "show_txbd") == 0)
  {
    if (args == 1)
      show_tx_bd(iarg[0], iarg[0]);
    else if (args == 2)
      show_tx_bd(iarg[0], iarg[1]);
    else
      show_tx_bd(0, 63);
  }
  else if (strcmp(cmd, "show_rxbd") == 0)
  {
    if (args == 1)
      show_rx_bd(iarg[0], iarg[0]);
    else if (args == 2)
      show_rx_bd(iarg[0], iarg[1]);
    else
      show_rx_bd(0, 63);
  }
  else if (strcmp(cmd, "dm") == 0)
  {
    if (args == 1)
      show_mem(iarg[0], iarg[0]);
    else if (args == 2)
      show_mem(iarg[0], iarg[1]);
    else
      uart_print_str("missing/wrong parameters\n");
  }
  else if (strcmp(cmd, "pm") == 0)
  {
    if ((args == 3) || (args == 2))
    {
      unsigned long addr = iarg[0];
      unsigned long stop_addr = iarg[1];
      unsigned long value = iarg[2];

      if (args == 2)
      {
        stop_addr = iarg[0];
        value = iarg[1];
      }

      for (; addr <= stop_addr; addr += 4)
        REG32(addr) = value;
      show_mem(iarg[0], stop_addr);
    }
    else
      uart_print_str("pm <addr> [<stop_addr>] <value>\n");
  }
  else if (strcmp(cmd, "mfspr") == 0)
  {
    if (args == 1)
      cmd_mfspr(iarg[0]);
    else
      uart_print_str("missing/wrong parameters\n");
  }
  else if (strcmp(cmd, "dhry") == 0)
  {
    if (args == 1)
      dhry_main(iarg[0]);
    else
      dhry_main(20);
  }
  else if (strcmp(cmd, "mtspr") == 0)
  {
    if (args == 2)
      cmd_mtspr(iarg[0], iarg[1]);
    else
      uart_print_str("missing/wrong parameters\n");
  }
  else if (strcmp(cmd, "eth_init") == 0)
      eth_init();
  else if (strcmp(cmd, "ic_enable") == 0)
      ic_enable();
  else if (strcmp(cmd, "ic_disable") == 0)
      ic_disable();
  else if (strcmp(cmd, "dc_enable") == 0)
      dc_enable();
  else if (strcmp(cmd, "dc_disable") == 0)
      dc_disable();
  else if (strcmp(cmd, "show_mac_regs") == 0)
      show_mac_regs();
  else if (strcmp(cmd, "init_txbd_pool") == 0)
  {
    if (args == 1)
      init_tx_bd_pool(iarg[0]);
    else
      uart_print_str("missing/wrong parameter\n");
  }
  else if (strcmp(cmd, "init_rxbd_pool") == 0)
  {
    if (args == 1)
      init_rx_bd_pool(iarg[0]);
    else
      uart_print_str("missing/wrong parameter\n");
  }
  else if (strcmp(cmd, "send_packet") == 0)
  {
    if (args == 1)
      send_packet(iarg[0], 31);
    else
    if (args == 2)
      send_packet(iarg[0], iarg[1]);
    else
      uart_print_str("missing/wrong parameters\n");
  }
  else if (strcmp(cmd, "show_rx_buffs") == 0)
  {
    if (args == 0)
      show_rx_buffs(63, 0);
    else
    if (args == 1)
      show_rx_buffs(63, 1);
    else
      uart_print_str("missing/wrong parameters\n");
  }
  else if (strcmp(cmd, "show_tx_buffs") == 0)
  {
    if (args == 0)
      show_tx_buffs(63);
    else
      uart_print_str("missing/wrong parameters\n");
  }
  else if (strcmp(cmd, "set_dest_addr") == 0)
  {
    if (args == 3)
    {
      dest_mac_addr[0] = (iarg[0] >> 8) & 0xff;
      dest_mac_addr[1] = (iarg[0] >> 0) & 0xff;
      dest_mac_addr[2] = (iarg[1] >> 8) & 0xff;
      dest_mac_addr[3] = (iarg[1] >> 0) & 0xff;
      dest_mac_addr[4] = (iarg[2] >> 8) & 0xff;
      dest_mac_addr[5] = (iarg[2] >> 0) & 0xff;
    }
    else
      uart_print_str("missing/wrong parameters\n");
  }
  else if (strcmp(cmd, "show_phy_reg") == 0)
  {
    if (args == 1)
      show_phy_reg(iarg[0], iarg[0]);
    else
    if (args == 2)
      show_phy_reg(iarg[0], iarg[1]);
    else
      show_phy_reg(0, 30);
  }
  else if (strcmp(cmd, "testram") == 0)
  {
    if (args == 2)
      testram(iarg[0], iarg[1], 0);
    else
    if (args == 3)
      testram(iarg[0], iarg[1], iarg[2]);
    else
      uart_print_str("missing/wrong parameters\n"); 
  }
  else if (strcmp(cmd, "set_phy_reg") == 0)
  {
    if (args == 2)
      set_phy_reg(iarg[0], iarg[1]);
    else
      uart_print_str("missing/wrong parameters\n");;
  }
  else if (strcmp(cmd, "crt_enable") == 0)
      crt_enable();
  else if (strcmp(cmd, "crt_disable") == 0)
      crt_disable();
  else if (strcmp(cmd, "crt_test") == 0)
      crt_test();
  else if (strcmp(cmd, "camera_enable") == 0)
      camera_enable();
  else if (strcmp(cmd, "camera_disable") == 0)
      camera_disable();
  else if (strcmp(cmd, "") == 0);
  else
    uart_print_str("Unknown command\n");
} 

int main(unsigned long dst, unsigned long src)
{
  int i;
  unsigned long counter=0;

  /* Initialize controller */
  uart_init();

  uart_print_str("Ethernet Monitor (type 'help' for help)\n");

  /* Initialize controller */
/*  eth_init();*/
  uart_print_str("Ethernet not initialized (run eth_init command)\n");
/*  init_rx_bd_pool(0); */
/*  init_tx_bd_pool(3);*/

  while(1)
  {
   mon_command();
  } 
}

void eth_int(void)
{

}
 
__main(void)
{
}

