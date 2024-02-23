/* Support file for or32 tests.  This file should is included
   in each test. It calls main() function and add support for
   basic functions */

#ifndef SUPPORT_H
#define SUPPORT_H

#include <stdarg.h>
#include <stddef.h>
#include <limits.h>

#if OR1K

/* Register access macros */
#define REG8(add) *((volatile unsigned char *)(add))
#define REG16(add) *((volatile unsigned short *)(add))
#define REG32(add) *((volatile unsigned long *)(add))

void printf(const char *fmt, ...);

/* For writing into SPR. */
void mtspr(unsigned long spr, unsigned long value);

/* For reading SPR. */
unsigned long mfspr(unsigned long spr);

#else /* OR1K */

#include <stdio.h>

#endif /* OR1K */

/* Do division by binary chop */
int div (int  a,
	 int  b);

/* Do modulo by binary chop */
int mod (int a,
	 int b);

/* Function to be called at entry point - not defined here.  */
int main ();

/* JPB: Prints out a char */
void putc(int value);

/* JPB: Prints out a string */
void prints(char *s);

/* JPB: Prints out a number to radix */
void printn(int n, int r);

/* Prints out a value */
void report(unsigned long value);

/* return value by making a syscall */
extern void exit (int i) __attribute__ ((__noreturn__));

/* memcpy clone */
extern void *memcpy (void *__restrict __dest,
                     __const void *__restrict __src, size_t __n);

/* Timer functions */
extern void start_timer(int);
extern unsigned int read_timer(int);

extern unsigned long excpt_buserr;
extern unsigned long excpt_dpfault;
extern unsigned long excpt_ipfault;
extern unsigned long excpt_tick;
extern unsigned long excpt_align;
extern unsigned long excpt_illinsn;
extern unsigned long excpt_int;
extern unsigned long excpt_dtlbmiss;
extern unsigned long excpt_itlbmiss;
extern unsigned long excpt_range;
extern unsigned long excpt_syscall;
extern unsigned long excpt_break;
extern unsigned long excpt_trap;

#endif
