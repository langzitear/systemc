#include "spr_defs.h"

/* Camera and CRT test.
   Draws gray cross across the screen, few color boxes at top left and moves around camera captured screen left/right
   in the middle. */
   
#define CAMERA_BASE     0x88000000
#define CRT_BASE        0xc0000000
#define VIDEO_RAM_START 0xa8000000      /* till including a83ffffc */

#define SCREEN_X        640
#define SCREEN_Y        480

#define CAMERA_X        352
#define CAMERA_Y        288

#define CAMERA_BUF(idx) (VIDEO_RAM_START + (idx) * CAMERA_X * CAMERA_Y)
#define FRAME_BUF       (CAMERA_BUF(2))

#define CAMERA_POS      (camera_pos_x + ((SCREEN_Y - CAMERA_Y) / 2) * SCREEN_X)

#define MIN(x,y)        ((x) < (y) ? (x) : (y))

#define set_mem32(addr,val)  (*((unsigned long *) (addr)) = (val))
#define get_mem32(addr)  (*((unsigned long *) (addr)))
#define set_palette(idx,r,g,b) set_mem32 (CRT_BASE + 0x400 + (idx) * 4, (((r) >> 3) << 11) | (((g) >> 2) << 5) | (((b) >> 3) << 0))
#define put_pixel(xx,yy,idx)   (*(unsigned char *)(FRAME_BUF + (xx) + (yy) * SCREEN_X) = (idx))


/* For writing into SPR. */
void mtspr(unsigned long spr, unsigned long value)
{	
  asm("l.mtspr\t\t%0,%1,0": : "r" (spr), "r" (value));
}

/* For reading SPR. */
unsigned long mfspr(unsigned long spr)
{	
  unsigned long value;
  asm("l.mfspr\t\t%0,%1,0" : "=r" (value) : "r" (spr));
  return value;
}

int camera_pos_x;
int camera_move_speed = 1;
int current_buf;

void int_main ()
{
  /* Change base addresse of camera */
  set_mem32 (CAMERA_BASE, CAMERA_BUF(current_buf)); /* Set address to store to */
  
  /* Change base addresse of crt */
  set_mem32 (CRT_BASE + 8, CAMERA_BUF(1 - current_buf)); /* Tell CRT when camera buffer is */
  uart_print_str("\n ");
  uart_print_long(CAMERA_BUF(current_buf));
  uart_print_str("\n ");
 
  current_buf = 1 - current_buf;
  
  /* move the camera screen around */
  camera_pos_x += camera_move_speed;
  if (camera_pos_x >= SCREEN_X - CAMERA_X || camera_pos_x <= 0)
    camera_move_speed = -camera_move_speed;
  mtspr(SPR_PICSR, 0);
}

void crt_enable ()
{
  int i, x, y;
  /* Init CRT */
  set_mem32 (CRT_BASE + 4, FRAME_BUF); /* Frame buffer start */
  set_mem32 (CRT_BASE, get_mem32 (CRT_BASE) | 1);          /* Enable CRT only */
  
  /* Init palette */
  for (i = 0; i < 32; i++) {
    set_palette (8 * i + 0, 0x00, 0x00, 0x00); /* black */
    set_palette (8 * i + 1, 0xff, 0xff, 0xff); /* white */
    set_palette (8 * i + 2, 0x7f, 0x7f, 0x7f); /* gray */
    set_palette (8 * i + 3, 0xff, 0x00, 0x00); /* red */
    set_palette (8 * i + 4, 0x00, 0xff, 0x00); /* green */
    set_palette (8 * i + 5, 0x00, 0x00, 0xff); /* blue */
    set_palette (8 * i + 6, 0x00, 0xff, 0xff); /* cyan */
    set_palette (8 * i + 7, 0xff, 0x00, 0xff); /* purple */
  }
  for (x = 0; x < SCREEN_X; x++)
    for (y = 0; y < SCREEN_Y; y++)
      put_pixel(x, y, 3);
}

void crt_test ()
{
  int i, x, y;
  for (x = 0; x < SCREEN_X; x++)
    for (y = 0; y < SCREEN_Y; y++)
      put_pixel(x, y, 0);
 /* Draw gray X */
  for (i = 0; i < SCREEN_Y; i++) {
    put_pixel (i, i, 2);
    put_pixel (SCREEN_X - i - 1, i, 1);
  }
  
  /* Draw color boxes */
  for (y = 0; y < 50; y++)
    for (x = 0; x < 50; x++) 
        for (i = 0; i < 8; i++)
          put_pixel (i * 50 + x, y, i);
}

void crt_disable ()
{
  set_mem32 (CRT_BASE, get_mem32 (CRT_BASE) & ~1);             /* Disable CRT */
}

void camera_enable ()
{
  /* Init Camera */
  set_mem32 (CAMERA_BASE, CAMERA_BUF(current_buf = 0)); /* Set address to store to */
  set_mem32 (CAMERA_BASE + 4, 1);         /* Enable it */

  /* Init CRT to display camera */
  set_mem32 (CRT_BASE + 8, CAMERA_BUF(1 - current_buf)); /* Tell CRT when camera buffer is */
  camera_pos_x = 0;
  set_mem32 (CRT_BASE + 0xc, CAMERA_POS);
  set_mem32 (CRT_BASE, get_mem32 (CRT_BASE) | 2);         /* Enable camera overlay */
  
  /* Enable interrupts */
  mtspr (SPR_SR, mfspr(SPR_SR) | SPR_SR_IEE);
  mtspr (SPR_PICMR, mfspr(SPR_PICSR) | (1 << 13));
}

void camera_disable ()
{ 
  /* Disable interrupts */
  mtspr (SPR_SR, mfspr(SPR_SR) & ~SPR_SR_IEE);
  mtspr (SPR_PICMR, mfspr(SPR_PICSR) & ~(1 << 13)); 
  
  /* Disable Camera */
  set_mem32 (CAMERA_BASE + 4, 1);         /* Enable it */
  set_mem32 (CRT_BASE, get_mem32 (CRT_BASE) & ~2);                           /* Disable camera overlay */
}
