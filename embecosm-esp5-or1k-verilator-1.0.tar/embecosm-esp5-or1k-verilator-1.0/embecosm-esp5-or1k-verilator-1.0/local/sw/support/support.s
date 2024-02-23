	.file	"support.c"
	.global _excpt_trap
.section .data
	.align 4
	.type	_excpt_trap, @object
	.size	_excpt_trap, 4
_excpt_trap:
	.long	_excpt_dummy
	.global _excpt_break
	.align 4
	.type	_excpt_break, @object
	.size	_excpt_break, 4
_excpt_break:
	.long	_excpt_dummy
	.global _excpt_syscall
	.align 4
	.type	_excpt_syscall, @object
	.size	_excpt_syscall, 4
_excpt_syscall:
	.long	_excpt_dummy
	.global _excpt_range
	.align 4
	.type	_excpt_range, @object
	.size	_excpt_range, 4
_excpt_range:
	.long	_excpt_dummy
	.global _excpt_itlbmiss
	.align 4
	.type	_excpt_itlbmiss, @object
	.size	_excpt_itlbmiss, 4
_excpt_itlbmiss:
	.long	_excpt_dummy
	.global _excpt_dtlbmiss
	.align 4
	.type	_excpt_dtlbmiss, @object
	.size	_excpt_dtlbmiss, 4
_excpt_dtlbmiss:
	.long	_excpt_dummy
	.global _excpt_int
	.align 4
	.type	_excpt_int, @object
	.size	_excpt_int, 4
_excpt_int:
	.long	_int_main
	.global _excpt_illinsn
	.align 4
	.type	_excpt_illinsn, @object
	.size	_excpt_illinsn, 4
_excpt_illinsn:
	.long	_excpt_dummy
	.global _excpt_align
	.align 4
	.type	_excpt_align, @object
	.size	_excpt_align, 4
_excpt_align:
	.long	_excpt_dummy
	.global _excpt_tick
	.align 4
	.type	_excpt_tick, @object
	.size	_excpt_tick, 4
_excpt_tick:
	.long	_excpt_dummy
	.global _excpt_ipfault
	.align 4
	.type	_excpt_ipfault, @object
	.size	_excpt_ipfault, 4
_excpt_ipfault:
	.long	_excpt_dummy
	.global _excpt_dpfault
	.align 4
	.type	_excpt_dpfault, @object
	.size	_excpt_dpfault, 4
_excpt_dpfault:
	.long	_excpt_dummy
	.global _excpt_buserr
	.align 4
	.type	_excpt_buserr, @object
	.size	_excpt_buserr, 4
_excpt_buserr:
	.long	_excpt_dummy
.section .text
	.align 4
.proc _exit
	.global _exit
	.type	_exit, @function
_exit:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.add r3,r0,r3
	l.nop 1
.L2:
	l.j     	.L2
	l.nop			# nop delay slot
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_exit, .-_exit
	.align 4
.proc _reset
	.global _reset
	.type	_reset, @function
_reset:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-8
	l.sw     	4(r1),r2
	l.addi   	r2,r1,8
	l.sw     	0(r1),r9
	l.jal   	_main
	l.nop			# nop delay slot
	l.jal   	_exit	# delay slot filled
	l.ori   	r3,r11,0	 # move reg to reg
	l.lwz    	r9,0(r1)
	l.lwz    	r2,4(r1)
	l.jr  	r9
	l.addi   	r1,r1,8
	.size	_reset, .-_reset
	.align 4
.proc _printf
	.global _printf
	.type	_printf, @function
_printf:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.lwz   	r4,0(r2)	 # SI load
	l.addi  	r3,r2,4
	  l.addi	r3,r4,0
                            l.addi	r4,r3,0
                            l.nop 3
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_printf, .-_printf
	.align 4
.proc _putc
	.global _putc
	.type	_putc, @function
_putc:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.addi	r3,r3,0
	l.nop 4
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_putc, .-_putc
	.align 4
.proc _prints
	.global _prints
	.type	_prints, @function
_prints:

	# gpr_save_area 4 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-12
	l.sw     	4(r1),r2
	l.addi   	r2,r1,12
	l.sw     	0(r1),r9
	l.sw    	8(r1),r10
	l.ori   	r10,r3,0	 # move reg to reg
	l.lbz   	r3,0(r3)	 # zero_extendqisi2
	l.slli  	r3,r3,24
	l.sfeqi	r3,0
	l.bf    	.L13	# delay slot filled
	l.srai  	r3,r3,24
.L14:
	l.jal   	_putc	# delay slot filled
	l.addi  	r10,r10,1
	l.lbz   	r3,0(r10)	 # zero_extendqisi2
	l.slli  	r3,r3,24
	l.sfnei	r3,0
	l.bf    	.L14	# delay slot filled
	l.srai  	r3,r3,24
.L13:
	l.lwz    	r9,0(r1)
	l.lwz    	r2,4(r1)
	l.lwz    	r10,8(r1)
	l.jr  	r9
	l.addi   	r1,r1,12
	.size	_prints, .-_prints
	.align 4
.proc _top_pow2
	.type	_top_pow2, @function
_top_pow2:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.addi  	r5,r0,0	 # move immediate I
	l.sfles 	r4,r3
	l.bnf   	.L15	# delay slot filled
	l.ori   	r11,r5,0	 # move reg to reg
	l.j     	.L22	# delay slot filled
	l.slli  	r4,r4,1
.L23:
	l.slli  	r4,r4,1
	l.addi  	r5,r5,1
.L22:
	l.sfgts 	r4,r3
	l.bnf   	.L23	# delay slot filled
	l.ori   	r11,r5,0	 # move reg to reg
.L15:
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_top_pow2, .-_top_pow2
	.align 4
.proc _div
	.global _div
	.type	_div, @function
_div:

	# gpr_save_area 12 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-20
	l.sw     	4(r1),r2
	l.addi   	r2,r1,20
	l.sw     	0(r1),r9
	l.sw    	8(r1),r10
	l.sw    	12(r1),r12
	l.sw    	16(r1),r14
	l.ori   	r10,r4,0	 # move reg to reg
	l.ori   	r12,r3,0	 # move reg to reg
	l.sfles 	r4,r3
	l.bnf   	.L24	# delay slot filled
	l.addi  	r11,r0,0	 # move immediate I
	l.sfne 	r4,r3
	l.bnf   	.L24	# delay slot filled
	l.addi  	r11,r0,1	 # move immediate I
	l.jal   	_top_pow2
	l.nop			# nop delay slot
	l.addi  	r3,r0,1	 # move immediate I
	l.sll   	r5,r10,r11
	l.sll   	r14,r3,r11
	l.ori   	r4,r10,0	 # move reg to reg
	l.jal   	_div	# delay slot filled
	l.sub   	r3,r12,r5
	l.add   	r11,r14,r11
.L24:
	l.lwz    	r9,0(r1)
	l.lwz    	r2,4(r1)
	l.lwz    	r10,8(r1)
	l.lwz    	r12,12(r1)
	l.lwz    	r14,16(r1)
	l.jr  	r9
	l.addi   	r1,r1,20
	.size	_div, .-_div
	.align 4
.proc _mod
	.global _mod
	.type	_mod, @function
_mod:

	# gpr_save_area 8 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-16
	l.sw     	4(r1),r2
	l.addi   	r2,r1,16
	l.sw     	0(r1),r9
	l.sw    	8(r1),r10
	l.sw    	12(r1),r12
	l.ori   	r12,r3,0	 # move reg to reg
	l.j     	.L31	# delay slot filled
	l.ori   	r10,r4,0	 # move reg to reg
.L33:
	l.sfne 	r10,r12
	l.bnf   	.L32
	l.nop			# nop delay slot
	l.jal   	_top_pow2
	l.nop			# nop delay slot
	l.sll   	r3,r10,r11
	l.sub   	r12,r12,r3
.L31:
	l.ori   	r3,r12,0	 # move reg to reg
	l.sfles 	r10,r12
	l.bf    	.L33	# delay slot filled
	l.ori   	r4,r10,0	 # move reg to reg
	l.j     	.L34	# delay slot filled
	l.ori   	r11,r3,0	 # move reg to reg
.L32:
	l.addi  	r3,r0,0	 # move immediate I
	l.ori   	r11,r3,0	 # move reg to reg
.L34:
	l.lwz    	r9,0(r1)
	l.lwz    	r2,4(r1)
	l.lwz    	r10,8(r1)
	l.lwz    	r12,12(r1)
	l.jr  	r9
	l.addi   	r1,r1,16
	.size	_mod, .-_mod
	.align 4
.proc _llu_power2
	.global _llu_power2
	.type	_llu_power2, @function
_llu_power2:

	# gpr_save_area 0 vars 8 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-12
	l.sw     	0(r1),r2
	l.addi   	r2,r1,12
	l.addi  	r5,r0,1	 # move immediate I
	l.addi  	r8,r0,0	 # move immediate I
	l.sfgesi	r4,0
	l.bnf   	.L41	# delay slot filled
	l.addi  	r7,r2,-8
	l.sfgtsi	r4,31
	l.bf    	.L37	# delay slot filled
	l.sfgtsi	r4,63
	l.sll   	r5,r5,r4
.L38:
	l.sw    	0(r7),r5	 # SI store
	l.sw    	4(r7),r8	 # SI store
		l.lwz   	r4, -8(r2)
		l.lwz   	r5, -8+4(r2)
	l.j     	.L40
	l.nop			# nop delay slot
.L37:
	l.bf    	.L38	# delay slot filled
	l.addi  	r6,r4,-32
	l.sll   	r8,r5,r6
	l.j     	.L38	# delay slot filled
	l.addi  	r5,r0,0	 # move immediate I
.L41:
		l.or    	r4, r0, r0
		l.movhi 	r5, hi(1)
		l.ori   	r5, r5, lo(1)
.L40:
		l.sw    	0(r3), r4
		l.sw    	4(r3), r5
	l.ori   	r11,r3,0	 # move reg to reg
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,12
	.size	_llu_power2, .-_llu_power2
	.align 4
.proc _llu_sll1
	.global _llu_sll1
	.type	_llu_sll1, @function
_llu_sll1:

	# gpr_save_area 0 vars 8 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-12
	l.sw     	0(r1),r2
	l.addi   	r2,r1,12
		l.sw    	0(r3), r5
		l.sw    	4(r3), r6
	l.ori   	r11,r3,0	 # move reg to reg
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,12
	.size	_llu_sll1, .-_llu_sll1
	.align 4
.proc _llu_sll
	.global _llu_sll
	.type	_llu_sll, @function
_llu_sll:

	# gpr_save_area 12 vars 8 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-28
	l.sw     	4(r1),r2
	l.addi   	r2,r1,28
	l.sw     	0(r1),r9
	l.sw    	8(r1),r10
	l.sw    	12(r1),r12
	l.sw    	16(r1),r14
	l.ori   	r10,r7,0	 # move reg to reg
	l.sflesi	r7,0
	l.bf    	.L46	# delay slot filled
	l.ori   	r14,r3,0	 # move reg to reg
	l.sfgtui	r5,0
	l.bnf   	.L54	# delay slot filled
	l.sfnei	r5,0
	l.addi  	r12,r2,-8
.L53:
	l.ori   	r3,r12,0	 # move reg to reg
.L55:
	l.jal   	_llu_sll1	# delay slot filled
	l.addi  	r10,r10,-1
	l.sflesi	r10,0
		l.lwz   	r5, -8(r2)
		l.lwz   	r6, -8+4(r2)
	l.bf    	.L46	# delay slot filled
	l.sfgtui	r5,0
	l.bf    	.L55	# delay slot filled
	l.ori   	r3,r12,0	 # move reg to reg
	l.sfnei	r5,0
	l.bf    	.L46	# delay slot filled
	l.sfgtui	r6,0
	l.bf    	.L53
	l.nop			# nop delay slot
	l.j     	.L46
	l.nop			# nop delay slot
.L54:
	l.bf    	.L46	# delay slot filled
	l.sfgtui	r6,0
	l.bf    	.L53	# delay slot filled
	l.addi  	r12,r2,-8
.L46:
		l.sw    	0(r14), r5
		l.sw    	4(r14), r6
	l.ori   	r11,r14,0	 # move reg to reg
	l.lwz    	r9,0(r1)
	l.lwz    	r2,4(r1)
	l.lwz    	r10,8(r1)
	l.lwz    	r12,12(r1)
	l.lwz    	r14,16(r1)
	l.jr  	r9
	l.addi   	r1,r1,28
	.size	_llu_sll, .-_llu_sll
	.align 4
.proc _printn
	.global _printn
	.type	_printn, @function
_printn:

	# gpr_save_area 12 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-20
	l.sw     	4(r1),r2
	l.addi   	r2,r1,20
	l.sw     	0(r1),r9
	l.sw    	8(r1),r10
	l.sw    	12(r1),r12
	l.sw    	16(r1),r14
	l.ori   	r10,r3,0	 # move reg to reg
	l.ori   	r14,r4,0	 # move reg to reg
	l.sfgesi	r10,0
	l.bnf   	.L63	# delay slot filled
	l.addi  	r3,r0,45	 # move immediate I
	l.sflts 	r10,r14
.L66:
	l.bnf   	.L64	# delay slot filled
	l.ori   	r4,r14,0	 # move reg to reg
	l.div   	r12,r10,r14
	l.mul   	r3,r12,r14
.L65:
	l.sub   	r10,r10,r3
	l.sfgtsi	r10,9
	l.bnf   	.L61	# delay slot filled
	l.addi  	r3,r10,48
	l.j     	.L61	# delay slot filled
	l.addi  	r3,r10,97
.L64:
	l.div   	r12,r10,r14
	l.jal   	_printn	# delay slot filled
	l.ori   	r3,r12,0	 # move reg to reg
	l.j     	.L65	# delay slot filled
	l.mul   	r3,r12,r14
.L63:
	l.jal   	_putc	# delay slot filled
	l.sub   	r10,r0,r10
	l.j     	.L66	# delay slot filled
	l.sflts 	r10,r14
.L61:
	l.jal   	_putc
	l.nop			# nop delay slot
	l.lwz    	r9,0(r1)
	l.lwz    	r2,4(r1)
	l.lwz    	r10,8(r1)
	l.lwz    	r12,12(r1)
	l.lwz    	r14,16(r1)
	l.jr  	r9
	l.addi   	r1,r1,20
	.size	_printn, .-_printn
	.align 4
.proc _report
	.global _report
	.type	_report, @function
_report:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.addi	r3,r3,0
	l.nop 2
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_report, .-_report
	.align 4
.proc ___main
	.global ___main
	.type	___main, @function
___main:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	___main, .-___main
	.align 4
.proc _mtspr
	.global _mtspr
	.type	_mtspr, @function
_mtspr:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.mtspr		r3,r4,0
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_mtspr, .-_mtspr
	.align 4
.proc _start_timer
	.global _start_timer
	.type	_start_timer, @function
_start_timer:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-8
	l.sw     	4(r1),r2
	l.addi   	r2,r1,8
	l.sw     	0(r1),r9
	l.movhi 	r4,hi(-805371904)	 # move immediate M
	l.addi  	r3,r0,20480	 # move immediate I
	l.jal   	_mtspr	# delay slot filled
	l.ori   	r4,r4,65535
	l.addi  	r3,r0,20481	 # move immediate I
	l.jal   	_mtspr	# delay slot filled
	l.addi  	r4,r0,0	 # move immediate I
	l.lwz    	r9,0(r1)
	l.lwz    	r2,4(r1)
	l.jr  	r9
	l.addi   	r1,r1,8
	.size	_start_timer, .-_start_timer
	.align 4
.proc _mfspr
	.global _mfspr
	.type	_mfspr, @function
_mfspr:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.mfspr		r11,r3,0
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_mfspr, .-_mfspr
	.align 4
.proc _read_timer
	.global _read_timer
	.type	_read_timer, @function
_read_timer:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-8
	l.sw     	4(r1),r2
	l.addi   	r2,r1,8
	l.sw     	0(r1),r9
	l.jal   	_mfspr	# delay slot filled
	l.addi  	r3,r0,20481	 # move immediate I
	l.ori   	r3,r11,0	 # move reg to reg
	l.jal   	_div	# delay slot filled
	l.addi  	r4,r0,10	 # move immediate I
	l.lwz    	r9,0(r1)
	l.lwz    	r2,4(r1)
	l.jr  	r9
	l.addi   	r1,r1,8
	.size	_read_timer, .-_read_timer
	.align 4
.proc _memcpy
	.global _memcpy
	.type	_memcpy, @function
_memcpy:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.j     	.L79	# delay slot filled
	l.addi  	r5,r5,-1
.L80:
	l.lbz   	r6,0(r4)	 # zero_extendqisi2
	l.addi  	r5,r5,-1
	l.sb    	0(r3),r6	    # movqi
	l.addi  	r4,r4,1
	l.addi  	r3,r3,1
.L79:
	l.sfeqi	r5,-1
	l.bnf   	.L80	# delay slot filled
	l.ori   	r11,r3,0	 # move reg to reg
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_memcpy, .-_memcpy
	.align 4
.proc _excpt_dummy
	.global _excpt_dummy
	.type	_excpt_dummy, @function
_excpt_dummy:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_excpt_dummy, .-_excpt_dummy
	.ident	"GCC: (GNU) 3.4.4"
