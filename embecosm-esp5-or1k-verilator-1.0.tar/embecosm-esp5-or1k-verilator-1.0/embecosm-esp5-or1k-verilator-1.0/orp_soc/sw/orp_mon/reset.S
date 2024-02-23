#include "spr_defs.h"
#include "board.h"
#include "mc.h"



        .extern _reset_support
        .extern _eth_int
        .extern _src_beg
        .extern _dst_beg
        .extern _dst_end        
        .extern _c_reset
        .extern _int_main
 
        .global _lolev_ie
        .global _lolev_idis

        .section .reset

        .org 0x100
_reset:
.if MC_ENABLED
	l.nop
        l.movhi r3,hi(MC_BASE_ADD)
        l.ori   r3,r3,MC_BA_MASK
        l.addi  r5,r0,0x00
        l.sw    0(r3),r5
.endif
	l.movhi r3,hi(_start)
        l.ori   r3,r3,lo(_start)
        l.jr    r3
        l.nop

        .section .vectors

        l.nop
        l.nop
        l.j     _int_wrapper
        l.nop

        .section .text

_start:
.if MC_ENABLED
        l.jal   init_mc
        l.nop

        /* Wait for SDRAM */
        l.addi  r3,r0,0x0000  /* igor zmanjsal iz 0x7fff na 0x0000 */
1:      l.sfeqi r3,0
        l.bnf   1b
        l.addi  r3,r3,-1
.endif        
      	/* Copy form flash to sram */
.if 0
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
        l.bf   	1b
        l.nop
2:

.if 0
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
.endif
        l.addi  r3,r0,0
        l.addi  r4,r0,0
3:
.endif

.if IC_ENABLE
        /* Flush IC */
        l.addi  r10,r0,0
        l.addi  r11,r0,8192
loop:
        l.mtspr r0,r10,SPR_ICBIR
        l.sfne  r10,r11
        l.bf    loop
        l.addi  r10,r10,16

        /* Enable IC */
        l.addi  r10,r0,(SPR_SR_ICE|SPR_SR_SM)
        l.mtspr r0,r10,SPR_SR
        l.nop
        l.nop
        l.nop
        l.nop
        l.nop
.endif

        l.movhi r1,hi(0x00010000)
        l.addi  r1,r1,lo(0x00010000)
        l.addi  r1,r1,-4
 
        l.movhi r2,hi(_main)
        l.ori   r2,r2,lo(_main)
        l.jr    r2
        l.addi  r2,r0,0

init_mc:

        l.movhi r3,hi(MC_BASE_ADD)
        l.ori   r3,r3,lo(MC_BASE_ADD)
 
        l.addi  r4,r3,MC_CSC(0)
        l.movhi r5,hi(FLASH_BASE_ADD)
        l.srai  r5,r5,5
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
        l.movhi r5,hi(SDRAM_BASE_ADD)
        l.srai  r5,r5,5
        l.ori   r5,r5,0x0411
        l.sw    0(r4),r5
 
        l.jr    r9
        l.nop

_int_wrapper:
        l.addi  r1,r1,-128

        l.sw    0x4(r1),r2
        l.sw    0x8(r1),r4
        l.sw    0xc(r1),r5
        l.sw    0x10(r1),r6
        l.sw    0x14(r1),r7
        l.sw    0x18(r1),r8
        l.sw    0x1c(r1),r9
        l.sw    0x20(r1),r10
        l.sw    0x24(r1),r11
        l.sw    0x28(r1),r12
        l.sw    0x2c(r1),r13
        l.sw    0x30(r1),r14
        l.sw    0x34(r1),r15
        l.sw    0x38(r1),r16
        l.sw    0x3c(r1),r17
        l.sw    0x40(r1),r18
        l.sw    0x44(r1),r19
        l.sw    0x48(r1),r20
        l.sw    0x4c(r1),r21
        l.sw    0x50(r1),r22
        l.sw    0x54(r1),r23
        l.sw    0x58(r1),r24
        l.sw    0x5c(r1),r25
        l.sw    0x60(r1),r26
        l.sw    0x64(r1),r27
        l.sw    0x68(r1),r28
        l.sw    0x6c(r1),r29
        l.sw    0x70(r1),r30
        l.sw    0x74(r1),r31
        l.sw    0x78(r1),r3

        l.movhi r3,hi(_eth_int)
        l.ori   r3,r3,lo(_eth_int)
        l.jalr  r3
        l.nop

        l.lwz   r2,0x4(r1)
        l.lwz   r4,0x8(r1)
        l.lwz   r5,0xc(r1)
        l.lwz   r6,0x10(r1)
        l.lwz   r7,0x14(r1)
        l.lwz   r8,0x18(r1)
        l.lwz   r9,0x1c(r1)
        l.lwz   r10,0x20(r1)
        l.lwz   r11,0x24(r1)
        l.lwz   r12,0x28(r1)
        l.lwz   r13,0x2c(r1)
        l.lwz   r14,0x30(r1)
        l.lwz   r15,0x34(r1)
        l.lwz   r16,0x38(r1)
        l.lwz   r17,0x3c(r1)
        l.lwz   r18,0x40(r1)
        l.lwz   r19,0x44(r1)
        l.lwz   r20,0x48(r1)
        l.lwz   r21,0x4c(r1)
        l.lwz   r22,0x50(r1)
        l.lwz   r23,0x54(r1)
        l.lwz   r24,0x58(r1)
        l.lwz   r25,0x5c(r1)
        l.lwz   r26,0x60(r1)
        l.lwz   r27,0x64(r1)
        l.lwz   r28,0x68(r1)
        l.lwz   r29,0x6c(r1)
        l.lwz   r30,0x70(r1)
        l.lwz   r31,0x74(r1)
#        l.lwz   r3,0x78(r1)

        l.mtspr r0,r0,SPR_PICSR

        l.mfspr r3,r0,SPR_ESR_BASE
        l.ori   r3,r3,SPR_SR_IEE
        l.mtspr r0,r3,SPR_ESR_BASE

        l.lwz   r3,0x78(r1)

        l.addi  r1,r1,128
        l.rfe
        l.nop

        .section .text
_lolev_ie:
        l.mfspr r3,r0,SPR_SR
        l.ori   r3,r3,SPR_SR_IEE
        l.mtspr r0,r3,SPR_SR
        l.movhi	r3,hi(ETH0_INT)
	l.ori	r3,r3,lo(ETH0_INT)
        l.mtspr r0,r3,SPR_PICMR

        l.jr    r9
        l.nop

_lolev_idis:
        l.mtspr r0,r0,SPR_PICMR

        l.jr    r9
        l.nop
