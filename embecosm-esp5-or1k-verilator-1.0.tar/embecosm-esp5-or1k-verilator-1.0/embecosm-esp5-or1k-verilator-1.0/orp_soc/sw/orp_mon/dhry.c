/*
 ****************************************************************************
 *
 *                   "DHRYSTONE" Benchmark Program
 *                   -----------------------------
 *                                                                            
 *  Version:    C, Version 2.1
 *                                                                            
 *  File:       dhry_1.c (part 2 of 3)
 *
 *  Date:       May 25, 1988
 *
 *  Author:     Reinhold P. Weicker
 *
 ****************************************************************************
 */
#include "dhry.h"
#include "spr_defs.h"
#include "board.h"

#define DLX_FREQ 200  /* in MHz */
#define PROC_6 0
#define printf

#ifndef strcpy
char *strcpy (char *dst0, char *src0)
{
  char *s = dst0;

  while ((*dst0++ = *src0++));

  return s;	
}
#endif

#ifndef strcmp
/*
int strcmp (const char *s1, const char *s2)
{
  while (*s1 && *s2 && *s1 == *s2) {
    s1++;
    s2++;
  }
  return (*(unsigned char *) s1) - (*(unsigned char *) s2);
}
*/
#endif

#define DETECTNULL(X) (((X) - 0x01010101) & ~(X) & 0x80808080)
#define UNALIGNED(X, Y) \
  (((long)X & (sizeof (long) - 1)) | ((long)Y & (sizeof (long) - 1)))


void start_timer()
{
	unsigned long val;

	val = SPR_TTMR_SR | 0x0fffffff; 
	asm("l.mtspr	r0,%0,%1": : "r" (val), "i" (SPR_TTMR));
	val = 0;
	asm("l.mtspr    r0,%0,%1": : "r" (val), "i" (SPR_TTCR));
}

unsigned long read_timer()
{
	unsigned long val;

	asm("l.mfspr	%0,r0,%1": "=r" (val) : "i" (SPR_TTCR));
	return val;
}

/* Global Variables: */

Rec_Pointer     Ptr_Glob,
                Next_Ptr_Glob;
int             Int_Glob;
Boolean         Bool_Glob;
char            Ch_1_Glob,
                Ch_2_Glob;
int             Arr_1_Glob [50];
int             Arr_2_Glob [50] [50];


  /* forward declaration necessary since Enumeration may not simply be int */

#ifndef REG
        Boolean Reg = false;
#define REG
        /* REG becomes defined as empty */
        /* i.e. no register variables   */
#else
        Boolean Reg = true;
#endif

/* variables for time measurement: */

#if DLX || OR1K
#define Too_Small_Time DLX_FREQ
#else
#define Too_Small_Time 1
#endif

#define TIMER0 0
#define TIMER1 1





unsigned int	Begin_Time,
                End_Time,
                User_Time,
		Microseconds,
		Dhrystones_Per_Second;

/* end of variables for time measurement */


void Proc_1(REG Rec_Pointer Ptr_Val_Par);
void Proc_2(One_Fifty      *Int_Par_Ref);
void Proc_3(Rec_Pointer    *Ptr_Ref_Par);
void Proc_4();
void Proc_5();
void Proc_6(
    Enumeration     Enum_Val_Par,
    Enumeration    *Enum_Ref_Par);
void Proc_7(
    One_Fifty       Int_1_Par_Val,
    One_Fifty       Int_2_Par_Val,
    One_Fifty      *Int_Par_Ref);
void Proc_8(
    Arr_1_Dim       Arr_1_Par_Ref,
    Arr_2_Dim       Arr_2_Par_Ref,
    int             Int_1_Par_Val,
    int             Int_2_Par_Val);
Enumeration Func_1(Capital_Letter Ch_1_Par_Val,
                   Capital_Letter Ch_2_Par_Val);
Boolean Func_2(Str_30 Str_1_Par_Ref, Str_30 Str_2_Par_Ref);
Boolean Func_3(Enumeration     Enum_Par_Val);

int dhry_main (int num_runs)
/*****/

  /* main program, corresponds to procedures        */
  /* Main and Proc_0 in the Ada version             */
{
        One_Fifty       Int_1_Loc;
  REG   One_Fifty       Int_2_Loc;
        One_Fifty       Int_3_Loc;
  REG   char            Ch_Index;
        Enumeration     Enum_Loc;
        Str_30          Str_1_Loc;
        Str_30          Str_2_Loc;
  REG   int             Run_Index;
  REG   int             Number_Of_Runs;
  Rec_Type		x, y;

  /* Initializations */

  Next_Ptr_Glob = (Rec_Pointer) &x;
  Ptr_Glob = (Rec_Pointer) &y;

  Ptr_Glob->Ptr_Comp                    = Next_Ptr_Glob;
  Ptr_Glob->Discr                       = Ident_1;
  Ptr_Glob->variant.var_1.Enum_Comp     = Ident_3;
  Ptr_Glob->variant.var_1.Int_Comp      = 40;
  strcpy (Ptr_Glob->variant.var_1.Str_Comp, 
          "DHRYSTONE PROGRAM, SOME STRING");
  strcpy (Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");

  Arr_2_Glob [8][7] = 10;
        /* Was missing in published program. Without this statement,    */
        /* Arr_2_Glob [8][7] would have an undefined value.             */
        /* Warning: With 16-Bit processors and Number_Of_Runs > 32000,  */
        /* overflow may occur for this array element.                   */

/* Initalize Data and Instruction Cache */


/*  printf ("\n");
  printf ("Dhrystone Benchmark, Version 2.1 (Language: C)\n");
  printf ("\n");
  if (Reg)
  {
    printf ("Program compiled with 'register' attribute\n");
    printf ("\n");
  }
  else
  {
    printf ("Program compiled without 'register' attribute\n");
    printf ("\n");
  }
  printf ("Please give the number of runs through the benchmark: ");
 */
  {
    int n;
    /* scanf ("%d", &n);
 */
    n = num_runs;
    Number_Of_Runs = n;
  }
  printf ("\n");

  printf ("Execution starts, %d runs through Dhrystone\n", Number_Of_Runs);
 

  /***************/
  /* Start timer */
  /***************/
 
/*  printf("%d", my_test2(Number_Of_Runs));*/
	start_timer(TIMER0);
	Begin_Time = read_timer(TIMER0);

  for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
  {

    Proc_5();
    Proc_4();
      /* Ch_1_Glob == 'A', Ch_2_Glob == 'B', Bool_Glob == true */
    Int_1_Loc = 2;
    Int_2_Loc = 3;
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
    Enum_Loc = Ident_2;
    
    Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
      /* Bool_Glob == 1 */
    while (Int_1_Loc < Int_2_Loc)  /* loop body executed once */
    {
      Int_3_Loc = 5 * Int_1_Loc - Int_2_Loc;
        /* Int_3_Loc == 7 */
      Proc_7 (Int_1_Loc, Int_2_Loc, &Int_3_Loc);
        /* Int_3_Loc == 7 */
      Int_1_Loc += 1;
    } /* while */
      /* Int_1_Loc == 3, Int_2_Loc == 3, Int_3_Loc == 7 */
#if DBG
      printf("a) Int_1_Loc: %x\n", Int_1_Loc);
      printf("a) Int_2_Loc: %x\n", Int_2_Loc);
      printf("a) Int_3_Loc: %x\n\n", Int_3_Loc);
#endif
    Proc_8 (Arr_1_Glob, Arr_2_Glob, Int_1_Loc, Int_3_Loc);
      /* Int_Glob == 5 */
#if DBG
      printf("b) Int_1_Loc: %x\n", Int_1_Loc);
      printf("b) Int_2_Loc: %x\n", Int_2_Loc);
      printf("b) Int_3_Loc: %x\n\n", Int_3_Loc);
#endif

    Proc_1 (Ptr_Glob);
#if DBG
      printf("c) Int_1_Loc: %x\n", Int_1_Loc);
      printf("c) Int_2_Loc: %x\n", Int_2_Loc);
      printf("c) Int_3_Loc: %x\n\n", Int_3_Loc);
#endif

    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
                             /* loop body executed twice */
    {
      if (Enum_Loc == Func_1 (Ch_Index, 'C'))
          /* then, not executed */
        {
        Proc_6 (Ident_1, &Enum_Loc);
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
        Int_2_Loc = Run_Index;
        Int_Glob = Run_Index;
#if DBG
      printf("d) Int_1_Loc: %x\n", Int_1_Loc);
      printf("d) Int_2_Loc: %x\n", Int_2_Loc);
      printf("d) Int_3_Loc: %x\n\n", Int_3_Loc);
#endif
        }
    }

      /* Int_1_Loc == 3, Int_2_Loc == 3, Int_3_Loc == 7 */
#if DBG
      printf("e) Int_1_Loc: %x\n", Int_1_Loc);
      printf("e) Int_2_Loc: %x\n", Int_2_Loc);
      printf("e) Int_3_Loc: %x\n", Int_3_Loc);
      printf("e) Ch_1_Glob: %c\n\n", Ch_1_Glob);
#endif
    Int_2_Loc = Int_2_Loc * Int_1_Loc;
    Int_1_Loc = Int_2_Loc * Int_3_Loc;
    Int_2_Loc = 7 * (Int_2_Loc - Int_3_Loc) - Int_1_Loc;
      /* Int_1_Loc == 1, Int_2_Loc == 13, Int_3_Loc == 7 */
    Proc_2 (&Int_1_Loc);

      /* Int_1_Loc == 5 */
#if DBG
      printf("f) Int_1_Loc: %x\n", Int_1_Loc);
      printf("f) Int_2_Loc: %x\n", Int_2_Loc);
      printf("f) Int_3_Loc: %x\n\n", Int_3_Loc);
#endif

  } /* loop "for Run_Index" */

  /**************/
  /* Stop timer */
  /**************/
  
  End_Time = read_timer(TIMER0);

/*  printf ("Execution ends\n");
  printf ("\n");
  printf ("Final values of the variables used in the benchmark:\n");
  printf ("\n");
  printf ("Int_Glob:            %d\n", Int_Glob);
  printf ("        should be:   %d\n", 5);
  printf ("Bool_Glob:           %d\n", Bool_Glob);
  printf ("        should be:   %d\n", 1);
  printf ("Ch_1_Glob:           %c\n", Ch_1_Glob);
  printf ("        should be:   %c\n", 'A');
  printf ("Ch_2_Glob:           %c\n", Ch_2_Glob);
  printf ("        should be:   %c\n", 'B');
  printf ("Arr_1_Glob[8]:       %d\n", Arr_1_Glob[8]);
  printf ("        should be:   %d\n", 7);
  printf ("Arr_2_Glob[8][7]:    %d\n", Arr_2_Glob[8][7]);
  printf ("        should be:   Number_Of_Runs + 10\n");
  printf ("Ptr_Glob->\n");
  printf ("  Ptr_Comp:          %d\n", (int) Ptr_Glob->Ptr_Comp);
  printf ("        should be:   (implementation-dependent)\n");
  printf ("  Discr:             %d\n", Ptr_Glob->Discr);
  printf ("        should be:   %d\n", 0);
  printf ("  Enum_Comp:         %d\n", Ptr_Glob->variant.var_1.Enum_Comp);
  printf ("        should be:   %d\n", 2);
  printf ("  Int_Comp:          %d\n", Ptr_Glob->variant.var_1.Int_Comp);
  printf ("        should be:   %d\n", 17);
  printf ("  Str_Comp:          %s\n", Ptr_Glob->variant.var_1.Str_Comp);
  printf ("        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
  printf ("Next_Ptr_Glob->\n");
  printf ("  Ptr_Comp:          %d\n", (int) Next_Ptr_Glob->Ptr_Comp);
  printf ("        should be:   (implementation-dependent), same as above\n");
  printf ("  Discr:             %d\n", Next_Ptr_Glob->Discr);
  printf ("        should be:   %d\n", 0);
  printf ("  Enum_Comp:         %d\n", Next_Ptr_Glob->variant.var_1.Enum_Comp);
  printf ("        should be:   %d\n", 1);
  printf ("  Int_Comp:          %d\n", Next_Ptr_Glob->variant.var_1.Int_Comp);
  printf ("        should be:   %d\n", 18);
  printf ("  Str_Comp:          %s\n",
                                Next_Ptr_Glob->variant.var_1.Str_Comp);
  printf ("        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
  printf ("Int_1_Loc:           %d\n", Int_1_Loc);
  printf ("        should be:   %d\n", 5);
  printf ("Int_2_Loc:           %d\n", Int_2_Loc);
  printf ("        should be:   %d\n", 13);
  printf ("Int_3_Loc:           %d\n", Int_3_Loc);
  printf ("        should be:   %d\n", 7);
  printf ("Enum_Loc:            %d\n", Enum_Loc);
  printf ("        should be:   %d\n", 1);
  printf ("Str_1_Loc:           %s\n", Str_1_Loc);
  printf ("        should be:   DHRYSTONE PROGRAM, 1'ST STRING\n");
  printf ("Str_2_Loc:           %s\n", Str_2_Loc);
  printf ("        should be:   DHRYSTONE PROGRAM, 2'ND STRING\n");

*/


  User_Time = End_Time - Begin_Time;
 /* microseconds */

  printf("Begin Time = %d\n",Begin_Time);
  printf("End Time   = %d\n",End_Time);

  uart_print_str("\nNumber of Runs ");
  uart_print_short(num_runs);
  uart_print_str("\nBegin Time ");
  uart_print_short(Begin_Time);
  uart_print_str("\nEnd Time ");
  uart_print_short(End_Time);  
  uart_print_str("\n");

  if (User_Time < Too_Small_Time)
  {
    printf ("Measured time too small to obtain meaningful results\n");
    printf ("Please increase number of runs\n");
    printf ("\n");
  }
  else
  {
#if DLX || OR1K
//    User_Time /= DLX_FREQ;
#if DLX
    printf("DLX ");
#else
#if OR1K
    printf("OR1K ");
#else
    printf("Unknown CPU ");
#endif
#endif
    printf("at %u MHz  ", DLX_FREQ);
    if (PROC_6)
	    printf("(+PROC_6)");
    printf("\n");
#endif
//    Microseconds = User_Time / Number_Of_Runs;
//    Dhrystones_Per_Second = Number_Of_Runs * 1000 / User_Time;
    printf ("Microseconds for one run through Dhrystone: ");
    printf ("%d us / %d runs\n", User_Time,Number_Of_Runs);
    printf ("Dhrystones per Second:                      ");
    printf ("%d \n", Dhrystones_Per_Second);
  }
  return 0;
}


void Proc_1(Ptr_Val_Par)
/******************/

	REG Rec_Pointer Ptr_Val_Par;
 /* executed once */
{
	REG Rec_Pointer Next_Record = Ptr_Val_Par->Ptr_Comp;
	/* == Ptr_Glob_Next */
	/* Local variable, initialized with Ptr_Val_Par->Ptr_Comp,    */
	/* corresponds to "rename" in Ada, "with" in Pascal           */

	
	structassign(*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob);
	Ptr_Val_Par->variant.var_1.Int_Comp = 5;
	Next_Record->variant.var_1.Int_Comp
	= Ptr_Val_Par->variant.var_1.Int_Comp;
	Next_Record->Ptr_Comp = Ptr_Val_Par->Ptr_Comp;
	Proc_3(&Next_Record->Ptr_Comp);
	/*
	 * Ptr_Val_Par->Ptr_Comp->Ptr_Comp == Ptr_Glob->Ptr_Comp
	 */
	if (Next_Record->Discr == Ident_1)
	/* then, executed */
	{
	Next_Record->variant.var_1.Int_Comp = 6;
	Proc_6(Ptr_Val_Par->variant.var_1.Enum_Comp,
		   &Next_Record->variant.var_1.Enum_Comp);
	Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
	Proc_7(Next_Record->variant.var_1.Int_Comp, 10,
		   &Next_Record->variant.var_1.Int_Comp);
	} else          /* not executed */
	structassign(*Ptr_Val_Par, *Ptr_Val_Par->Ptr_Comp);

}               /* Proc_1 */


void
  Proc_2(Int_Par_Ref)
/******************/
 /* executed once */
 /* *Int_Par_Ref == 1, becomes 4 */

	One_Fifty      *Int_Par_Ref;
{
	One_Fifty       Int_Loc;
	Enumeration     Enum_Loc = 0;


	Int_Loc = *Int_Par_Ref + 10;
	do              /* executed once */
	if (Ch_1_Glob == 'A')
		/* then, executed */
	{
		Int_Loc -= 1;
		*Int_Par_Ref = Int_Loc - Int_Glob;
		Enum_Loc = Ident_1;
	}           /* if */
	while (Enum_Loc != Ident_1);/* true */
}               /* Proc_2 */


void
  Proc_3(Ptr_Ref_Par)
/******************/
 /* executed once */
 /* Ptr_Ref_Par becomes Ptr_Glob */

	Rec_Pointer    *Ptr_Ref_Par;

{

	if (Ptr_Glob != Null)
	/* then, executed */
	*Ptr_Ref_Par = Ptr_Glob->Ptr_Comp;
	Proc_7(10, Int_Glob, &Ptr_Glob->variant.var_1.Int_Comp);
}               /* Proc_3 */


void
  Proc_4()
{               /* without parameters */
	/*******/
	/* executed once */
	Boolean         Bool_Loc;


	Bool_Loc = Ch_1_Glob == 'A';
	Bool_Glob = Bool_Loc | Bool_Glob;
	Ch_2_Glob = 'B';
}               /* Proc_4 */


void
  Proc_5()
{               /* without parameters */
	/*******/
	/* executed once */

	Ch_1_Glob = 'A';
	Bool_Glob = false;
}               /* Proc_5 */

/* @(#)dhry_2.c	1.2 92/05/28 14:44:54, AMD */
/*
 ****************************************************************************
 *
 *                   "DHRYSTONE" Benchmark Program
 *                   -----------------------------
 *
 *  Version:    C, Version 2.1
 *
 *  File:       dhry_2.c (part 3 of 3)
 *
 *  Date:       May 25, 1988
 *
 *  Author:     Reinhold P. Weicker
 *
 ****************************************************************************
 */

#ifndef REG
#define REG
 /* REG becomes defined as empty */
 /* i.e. no register variables   */
#ifdef _AM29K
#undef REG
#define REG register	/* Define REG; saves room on 127-char MS-DOS cmd line */
#endif
#endif


void
  Proc_6(Enum_Val_Par, Enum_Ref_Par)
/*********************************/
 /* executed once */
 /* Enum_Val_Par == Ident_3, Enum_Ref_Par becomes Ident_2 */

    Enumeration     Enum_Val_Par;
    Enumeration    *Enum_Ref_Par;
{
#if PROC_6

    *Enum_Ref_Par = Enum_Val_Par;
    if (!Func_3(Enum_Val_Par))
	/* then, not executed */
	*Enum_Ref_Par = Ident_4;
    switch (Enum_Val_Par) {
    case Ident_1:
	*Enum_Ref_Par = Ident_1;
	break;
    case Ident_2:
	if (Int_Glob > 100)
	    /* then */
	    *Enum_Ref_Par = Ident_1;
	else
	    *Enum_Ref_Par = Ident_4;
	break;
    case Ident_3:		/* executed */
	*Enum_Ref_Par = Ident_2;
	break;
    case Ident_4:
	break;
    case Ident_5:
	*Enum_Ref_Par = Ident_3;
	break;
    }				/* switch */
#endif
    return;
}				/* Proc_6 */


void
  Proc_7(Int_1_Par_Val, Int_2_Par_Val, Int_Par_Ref)
/**********************************************/
 /* executed three times                                      */
 /* first call:      Int_1_Par_Val == 2, Int_2_Par_Val == 3,  */
 /* Int_Par_Ref becomes 7                    */
 /* second call:     Int_1_Par_Val == 10, Int_2_Par_Val == 5, */
 /* Int_Par_Ref becomes 17                   */
 /* third call:      Int_1_Par_Val == 6, Int_2_Par_Val == 10, */
 /* Int_Par_Ref becomes 18                   */
    One_Fifty       Int_1_Par_Val;
    One_Fifty       Int_2_Par_Val;
    One_Fifty      *Int_Par_Ref;
{
    One_Fifty       Int_Loc;


    Int_Loc = Int_1_Par_Val + 2;
    *Int_Par_Ref = Int_2_Par_Val + Int_Loc;
}				/* Proc_7 */


void
  Proc_8(Arr_1_Par_Ref, Arr_2_Par_Ref, Int_1_Par_Val, Int_2_Par_Val)
/*********************************************************************/
 /* executed once      */
 /* Int_Par_Val_1 == 3 */
 /* Int_Par_Val_2 == 7 */
    Arr_1_Dim       Arr_1_Par_Ref;
    Arr_2_Dim       Arr_2_Par_Ref;
    int             Int_1_Par_Val;
    int             Int_2_Par_Val;
{
    REG One_Fifty   Int_Index;
    REG One_Fifty   Int_Loc;

#if DBG
      printf("X) Int_1_Par_Val: %x\n", Int_1_Par_Val);
      printf("X) Int_2_Par_Val: %x\n", Int_2_Par_Val);
#endif


    Int_Loc = Int_1_Par_Val + 5;
    Arr_1_Par_Ref[Int_Loc] = Int_2_Par_Val;
    Arr_1_Par_Ref[Int_Loc + 1] = Arr_1_Par_Ref[Int_Loc];
    Arr_1_Par_Ref[Int_Loc + 30] = Int_Loc;
    for (Int_Index = Int_Loc; Int_Index <= Int_Loc + 1; ++Int_Index)
	Arr_2_Par_Ref[Int_Loc][Int_Index] = Int_Loc;
    Arr_2_Par_Ref[Int_Loc][Int_Loc - 1] += 1;
    Arr_2_Par_Ref[Int_Loc + 20][Int_Loc] = Arr_1_Par_Ref[Int_Loc];
    Int_Glob = 5;

#if DBG
      printf("Y) Int_1_Par_Val: %x\n", Int_1_Par_Val);
      printf("Y) Int_2_Par_Val: %x\n", Int_2_Par_Val);
#endif

}				/* Proc_8 */


Enumeration 
  Func_1(Ch_1_Par_Val, Ch_2_Par_Val)
/*************************************************/
 /* executed three times                                         */
 /* first call:      Ch_1_Par_Val == 'H', Ch_2_Par_Val == 'R'    */
 /* second call:     Ch_1_Par_Val == 'A', Ch_2_Par_Val == 'C'    */
 /* third call:      Ch_1_Par_Val == 'B', Ch_2_Par_Val == 'C'    */

    Capital_Letter  Ch_1_Par_Val;
    Capital_Letter  Ch_2_Par_Val;
{
    Capital_Letter  Ch_1_Loc;
    Capital_Letter  Ch_2_Loc;


    Ch_1_Loc = Ch_1_Par_Val;
    Ch_2_Loc = Ch_1_Loc;
    if (Ch_2_Loc != Ch_2_Par_Val)
	/* then, executed */
	return (Ident_1);
    else {			/* not executed */
	Ch_1_Glob = Ch_1_Loc;
	return (Ident_2);
    }
}				/* Func_1 */


Boolean 
  Func_2(Str_1_Par_Ref, Str_2_Par_Ref)
/*************************************************/
 /* executed once */
 /* Str_1_Par_Ref == "DHRYSTONE PROGRAM, 1'ST STRING" */
 /* Str_2_Par_Ref == "DHRYSTONE PROGRAM, 2'ND STRING" */

    Str_30          Str_1_Par_Ref;
    Str_30          Str_2_Par_Ref;
{
    REG One_Thirty  Int_Loc;
    Capital_Letter  Ch_Loc = 0;


    Int_Loc = 2;
    while (Int_Loc <= 2)	/* loop body executed once */
	if (Func_1(Str_1_Par_Ref[Int_Loc],
		   Str_2_Par_Ref[Int_Loc + 1]) == Ident_1)
	    /* then, executed */
	{
	    Ch_Loc = 'A';
	    Int_Loc += 1;
	}			/* if, while */

    if (Ch_Loc >= 'W' && Ch_Loc < 'Z')
	/* then, not executed */
	Int_Loc = 7;
    if (Ch_Loc == 'R')
	/* then, not executed */
	return (true);
    else {			/* executed */
	if (strcmp(Str_1_Par_Ref, Str_2_Par_Ref) > 0)
	    /* then, not executed */
	{
	    Int_Loc += 7;
	    Int_Glob = Int_Loc;
	    return (true);
	} else			/* executed */
	    return (false);
    }				/* if Ch_Loc */
}				/* Func_2 */


Boolean 
  Func_3(Enum_Par_Val)
/***************************/
 /* executed once        */
 /* Enum_Par_Val == Ident_3 */
    Enumeration     Enum_Par_Val;
{
    Enumeration     Enum_Loc;

    Enum_Loc = Enum_Par_Val;
    if (Enum_Loc == Ident_3)
	/* then, executed */
	return (true);
    else			/* not executed */
	return (false);
}				/* Func_3 */
