/* Support file for c based tests */
#include "spr_defs.h"
#include "board.h"
#include "mc.h"

        .section .stack
        .space 0x10000
_stack:

        .section .reset, "ax"

        .org    0x100
_reset_vector:
        l.nop
        l.nop
        l.addi  r2,r0,0x0
        l.addi  r3,r0,0x0
        l.addi  r4,r0,0x0
        l.addi  r5,r0,0x0
        l.addi  r6,r0,0x0
        l.addi  r7,r0,0x0
        l.addi  r8,r0,0x0
        l.addi  r9,r0,0x0
        l.addi  r10,r0,0x0
        l.addi  r11,r0,0x0
        l.addi  r12,r0,0x0
        l.addi  r13,r0,0x0
        l.addi  r14,r0,0x0
        l.addi  r15,r0,0x0
        l.addi  r16,r0,0x0
        l.addi  r17,r0,0x0
        l.addi  r18,r0,0x0
        l.addi  r19,r0,0x0
        l.addi  r20,r0,0x0
        l.addi  r21,r0,0x0
        l.addi  r22,r0,0x0
        l.addi  r23,r0,0x0
        l.addi  r24,r0,0x0
        l.addi  r25,r0,0x0
        l.addi  r26,r0,0x0
        l.addi  r27,r0,0x0
        l.addi  r28,r0,0x0
        l.addi  r29,r0,0x0
        l.addi  r30,r0,0x0
        l.addi  r31,r0,0x0

        l.movhi r3,hi(MC_BASE_ADDR)
        l.ori   r3,r3,MC_BA_MASK
        l.addi  r5,r0,0x00
        l.sw    0(r3),r5
        l.movhi r3,hi(_start)
        l.ori   r3,r3,lo(_start)
        l.jr    r3
        l.nop

        .section .text

_start:
        l.jal   _init_mc
        l.nop

.if IC | DC
        /* Flush IC and/or DC */
        l.addi  r10,r0,0   
        l.addi  r11,r0,0   
        l.addi  r12,r0,0   
.if IC
        l.addi  r11,r0,IC_SIZE
.endif
.if DC
	l.addi	r12,r0,DC_SIZE
.endif
	l.sfleu	r12,r11
	l.bf	loop
	l.nop
	l.add	r11,r0,r12
loop:
.if IC
        l.mtspr r0,r10,SPR_ICBIR
.endif
.if DC
        l.mtspr r0,r10,SPR_DCBIR
.endif
        l.sfne  r10,r11
        l.bf    loop   
        l.addi  r10,r10,16

        /* Enable IC and/or DC */
        l.addi  r10,r0,(SPR_SR_SM)
.if IC
        l.ori	r10,r10,(SPR_SR_ICE)
.endif
.if DC
        l.ori	r10,r10,(SPR_SR_DCE)
.endif
        l.mtspr r0,r10,SPR_SR
        l.nop
        l.nop
        l.nop
        l.nop
        l.nop
.endif

        /* Wait for SDRAM */
        l.addi  r3,r0,0x1	/* 0x1000 */
1:      l.sfeqi r3,0
        l.bnf   1b
        l.addi  r3,r3,-1

        /* Copy from flash to sram */
        l.movhi r3,hi(_src_beg)
        l.ori   r3,r3,lo(_src_beg)
        l.movhi r4,hi(_icm_start)
        l.ori   r4,r4,lo(_icm_start)
        l.movhi r5,hi(_icm_end)
        l.ori   r5,r5,lo(_icm_end)
        l.sub   r5,r5,r4
        l.sfeqi r5,0
        l.bf    20f
        l.nop
10:     l.lwz   r6,0(r3)
        l.sw    0(r4),r6
        l.addi  r3,r3,4
        l.addi  r4,r4,4
        l.addi  r5,r5,-4
        l.sfgtsi r5,0
        l.bf    10b
        l.nop
20:

        /* Copy from flash to sram */
        l.movhi r3,hi(_src_beg)
        l.ori   r3,r3,lo(_src_beg)
        l.movhi r4,hi(_vec_start)
        l.ori   r4,r4,lo(_vec_start)
        l.movhi r5,hi(_vec_end)
        l.ori   r5,r5,lo(_vec_end)
        l.sub   r5,r5,r4
        l.sfeqi r5,0
        l.bf    2f
        l.nop
1:      l.lwz   r6,0(r3)
        l.sw    0(r4),r6
        l.addi  r3,r3,4
        l.addi  r4,r4,4
        l.addi  r5,r5,-4
        l.sfgtsi r5,0
        l.bf    1b
        l.nop
2:
        l.movhi r4,hi(_dst_beg)
        l.ori   r4,r4,lo(_dst_beg)
        l.movhi r5,hi(_dst_end)
        l.ori   r5,r5,lo(_dst_end)
1:      l.sfgeu r4,r5
        l.bf    1f
        l.nop
        l.lwz   r8,0(r3)
        l.sw    0(r4),r8
        l.addi  r3,r3,4
        l.bnf   1b
        l.addi  r4,r4,4
1:
        l.addi  r3,r0,0
        l.addi  r4,r0,0
3:
	/* Set stack pointer */
        l.movhi r1,hi(_stack)
        l.ori   r1,r1,lo(_stack)

	/* Jump to main */
        l.movhi r2,hi(_reset)
        l.ori   r2,r2,lo(_reset)
        l.jr    r2
        l.nop

_init_mc:
 
        l.movhi r3,hi(MC_BASE_ADDR)
        l.ori   r3,r3,lo(MC_BASE_ADDR)
 
        l.addi  r4,r3,MC_CSC(0)
        l.movhi r5,hi(FLASH_BASE_ADDR)
        l.srai  r5,r5,6
        l.ori   r5,r5,0x0025
        l.sw    0(r4),r5
 
        l.addi  r4,r3,MC_TMS(0)
        l.movhi r5,hi(FLASH_TMS_VAL)
        l.ori   r5,r5,lo(FLASH_TMS_VAL)
        l.sw    0(r4),r5
 
        l.addi  r4,r3,MC_BA_MASK
        l.addi  r5,r0,MC_MASK_VAL
        l.sw    0(r4),r5
 
        l.addi  r4,r3,MC_CSR
        l.movhi r5,hi(MC_CSR_VAL)
        l.ori   r5,r5,lo(MC_CSR_VAL)
        l.sw    0(r4),r5
 
        l.addi  r4,r3,MC_TMS(1)
        l.movhi r5,hi(SDRAM_TMS_VAL)
        l.ori   r5,r5,lo(SDRAM_TMS_VAL)
        l.sw    0(r4),r5
 
        l.addi  r4,r3,MC_CSC(1)
        l.movhi r5,hi(SDRAM_BASE_ADDR)
        l.srai  r5,r5,6
        l.ori   r5,r5,0x0411
        l.sw    0(r4),r5

        l.addi  r4,r3,MC_TMS(2)
        l.movhi r5,hi(SDRAM_TMS_VAL)
        l.ori   r5,r5,lo(SDRAM_TMS_VAL)
        l.sw    0(r4),r5
 
        l.addi  r4,r3,MC_CSC(2)
        l.movhi r5,hi(0x00800000)
        l.srai  r5,r5,6
        l.ori   r5,r5,0x0411
        l.sw    0(r4),r5
 
        l.jr    r9
        l.nop

