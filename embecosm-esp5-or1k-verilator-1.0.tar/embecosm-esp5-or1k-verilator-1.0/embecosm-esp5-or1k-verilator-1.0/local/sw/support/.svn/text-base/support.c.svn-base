/* Support */

#ifndef OR1K
#include <sys/time.h>
#endif

#include "spr_defs.h"
#include "support.h"
#include "int.h"

#if OR1K
void excpt_dummy();
void int_main();

unsigned long excpt_buserr = (unsigned long) excpt_dummy;
unsigned long excpt_dpfault = (unsigned long) excpt_dummy;
unsigned long excpt_ipfault = (unsigned long) excpt_dummy;
unsigned long excpt_tick = (unsigned long) excpt_dummy;
unsigned long excpt_align = (unsigned long) excpt_dummy;
unsigned long excpt_illinsn = (unsigned long) excpt_dummy;
unsigned long excpt_int = (unsigned long) int_main;
unsigned long excpt_dtlbmiss = (unsigned long) excpt_dummy;
unsigned long excpt_itlbmiss = (unsigned long) excpt_dummy;
unsigned long excpt_range = (unsigned long) excpt_dummy;
unsigned long excpt_syscall = (unsigned long) excpt_dummy;
unsigned long excpt_break = (unsigned long) excpt_dummy;
unsigned long excpt_trap = (unsigned long) excpt_dummy;


/* Start function, called by reset exception handler.  */
void reset ()
{
  int i = main();
  exit (i);  
}

/* return value by making a syscall */
void exit (int i)
{
  asm("l.add r3,r0,%0": : "r" (i));
  asm("l.nop %0": :"K" (NOP_EXIT));
  while (1);
}

/* activate printf support in simulator */
void printf(const char *fmt, ...)
{
  va_list args;
  va_start(args, fmt);
  __asm__ __volatile__ ("  l.addi\tr3,%1,0\n \
                           l.addi\tr4,%2,0\n \
                           l.nop %0": :"K" (NOP_PRINTF), "r" (fmt), "r"  (args));
}

/* JPB: print string */
void prints (char *s)
{
  while (*s != 0)
    {
      putc ((int)(*s));
      s++;
    }
}	/* prints () */

/* What is the largest power of 2 by which we can multiply b and still be
   less than or equal to a?. Return 0 if b > a. */
static int top_pow2 (int  a,
		     int  b)
{
  int  pow  = 0;		/* The power to raise to */
  int  exp  = 1 << pow;		/* The value of 2^pow */
  int  bpow = b * exp;		/* b * exp */

  if (b > a)
    {
      return 0;
    }

  /* Stop when the next power would be too big */
  while (bpow << 1 <= a)
    {
      bpow = bpow << 1;
      exp  = exp  << 1;
      pow++;
    }

  return pow;

}	/* top_pow2 () */

/* Do division by binary chop here */
int div (int  a,
	 int  b)
{
  int  pow;

  if (b > a)
    {
      return 0;
    }

  if (b == a)
    {
      return 1;
    }

  pow = top_pow2 (a, b);
  return (1 << pow) + div (a - (b << pow), b);

}	/* div () */


/* Do modulo by binary chop here */
int mod (int a,
	 int b)
{
  int pow;

  if (b > a)
    {
      return a;
    }

  if (b == a)
    {
      return 0;
    }

  pow = top_pow2 (a, b);
  return mod (a - (b << pow), b);

}	/* mod() */


/* Unsigned long long version. What is the largest power of 2 by which we can
   multiply b and still be less than or equal to a?. Return 0 if b > a. */
static int llu_top_pow2 (unsigned long long int  a,
			 unsigned long long int  b)
{
  int                     pow  = 0;		/* The power to raise to */
  unsigned long long int  exp  = 1 << pow;	/* The value of 2^pow */
  unsigned long long int  bpow = b * exp;	/* b * exp */

  if (b > a)
    {
      return 0;
    }

  /* Stop when the next power would be too big */
  while (bpow << 1 <= a)
    {
      bpow = bpow << 1;
      exp  = exp  << 1;
      pow++;
    }

  return pow;

}	/* llu_top_pow2 () */

/* Return a power of 2 for LLU, but shifting 1. Values outside the range
   0-63 are treated as zero. */
unsigned long long int  llu_power2 (int  pow)
{
  unsigned long int       ms = 0;
  unsigned long int       ls = 1;
  unsigned long long int  res;
  unsigned long int      *pul = (unsigned long int *)(&res);

  if (pow < 0) {
    return 1LLU;
  }

  if (pow < 32) {
    ms = 0;
    ls = 1 << pow;
  }
  else if (pow < 64) {
    ms = 1 << (pow - 32);
    ls = 0;
  }

  *pul       = ls;
  *(pul + 1) = ms;

  return res;

}	/* llu_power2() */

/* Shift a 64 bit value 1 to the left */
unsigned long long int llu_sll1 (unsigned long long int val)
{
  unsigned long int      *pul = (unsigned long int *)(&val);
  unsigned long int       ls = *pul;
  unsigned long int       ms = *(pul + 1);

  ms = ms << 1 | (((ls & 0x80000000) == 0x80000000) ? 1 : 0);
  ls = ls << 1;

  *pul       = ls;
  *(pul + 1) = ms;

  return val;

}	/* llu_ssl1() */

/* Shift a 64 bit value to the left */
unsigned long long int  llu_sll (unsigned long long int val,
				 int                    s)
{
  while ((s > 0) && (val > 0)) {
    val = llu_sll1 (val);
    s--;
  }
  
  return val;

}	/* llu_ssl() */

/* Unsigned long long version. Do division by binary chop here */
static unsigned long long int llu_div (unsigned long long int  a,
				       unsigned long long int  b)
{
  int  pow;

  if (b > a)
    {
      return 0;
    }

  if (b == a)
    {
      return 1;
    }

  pow = llu_top_pow2 (a, b);
  return llu_power2 (pow) + llu_div (a - llu_sll(b, pow), b);

}	/* llu_div () */


/* JPB: print number in radix */
void printn (int n, int r)
{
  if (n < 0)				// Any sign
    {
      putc ('-');
      n = -n;
    }

  if (n >= r)				// Higher order digits
    {
      printn (n / r, r);
    }

  n = n % r;				// Bottom digit
  putc (n <= 9 ? '0' + n : 'a' + n);

}	/* printn ()


/* JPB: print single char */
void putc(int value)
{
  asm("l.addi\tr3,%0,0": :"r" (value));
  asm("l.nop %0": :"K" (NOP_PUTC));
}

/* print long */
void report(unsigned long value)
{
  asm("l.addi\tr3,%0,0": :"r" (value));
  asm("l.nop %0": :"K" (NOP_REPORT));
}

/* just to satisfy linker */
void __main()
{
}

/* start_TIMER. Set the tick timer to zero and continuous (no interrupt mode) */
void start_timer(int x)
{
  unsigned long int  ttmr  = (10 << 11) + 0;	// TTMR SPR
  unsigned long int  ttcr  = (10 << 11) + 1;	// TTCR SPR
  unsigned long int  value;

  mtspr (ttmr, 0xcfffffffUL);			// Continuous timer
  mtspr (ttcr, 0UL);				// Restart count

}

/* read_TIMER                    */
/*  Returns the number of cycles. */
unsigned int read_timer(int x)
{
  unsigned long int  ttcr  = (10 << 11) + 1;	// TTCR SPR
  unsigned long int  count = mfspr (ttcr);

  // Turn it into uS (assume cycle time of 100ns)

  return div (count, 10);
}

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

#else
void report(unsigned long value)
{
  printf("report(0x%x);\n", (unsigned) value);
}

/* start_TIMER                    */
void start_timer(int tmrnum)
{
}

/* read_TIMER                    */
/*  Returns a value since started in uS */
/* unsigned int read_timer(int tmrnum) */
/* { */
/*   struct timeval tv; */
/*   struct timezone tz; */

/*   gettimeofday(&tv, &tz); */
	
/*   return(tv.tv_sec*1000000+tv.tv_usec); */
/* } */

#endif

void *memcpy (void *__restrict dstvoid,
              __const void *__restrict srcvoid, size_t length)
{
  char *dst = dstvoid;
  const char *src = (const char *) srcvoid;

  while (length--)
    *dst++ = *src++;
  return dst;
}

void excpt_dummy() {}
