	.file	"dhry.c"
	.global _Reg
.section .data
	.align 4
	.type	_Reg, @object
	.size	_Reg, 4
_Reg:
	.long	0
.section .text
	.align 4
.proc _strcpy
	.global _strcpy
	.type	_strcpy, @function
_strcpy:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.ori   	r11,r3,0	 # move reg to reg
.L2:
	l.lbz   	r5,0(r4)	 # zero_extendqisi2
	l.sb    	0(r3),r5	    # movqi
	l.addi  	r4,r4,1
	l.sfnei	r5,0
	l.bf    	.L2	# delay slot filled
	l.addi  	r3,r3,1
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_strcpy, .-_strcpy
	.align 4
.proc _strcmp
	.global _strcmp
	.type	_strcmp, @function
_strcmp:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
.L6:
	l.lbs   	r6,0(r3)	 # extendqisi2_no_sext_mem
	l.lbz   	r11,0(r3)	 # zero_extendqisi2
	l.sfeqi	r6,0
	l.bf    	.L9	# delay slot filled
	l.addi  	r3,r3,1
	l.lbs   	r5,0(r4)	 # extendqisi2_no_sext_mem
	l.lbz   	r7,0(r4)	 # zero_extendqisi2
	l.sfeqi	r5,0
	l.bf    	.L7	# delay slot filled
	l.addi  	r4,r4,1
	l.sfne 	r6,r5
	l.bnf   	.L6	# delay slot filled
	l.sub   	r11,r11,r7
	l.j     	.L10
	l.nop			# nop delay slot
.L9:
	l.lbz   	r7,0(r4)	 # zero_extendqisi2
.L7:
	l.sub   	r11,r11,r7
.L10:
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_strcmp, .-_strcmp
	.align 4
.proc _test1
	.global _test1
	.type	_test1, @function
_test1:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.add   	r11,r3,r4
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_test1, .-_test1
	.align 4
.proc _Proc_5
	.global _Proc_5
	.type	_Proc_5, @function
_Proc_5:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.movhi 	r3,hi(_Ch_1_Glob)
	l.ori   	r3,r3,lo(_Ch_1_Glob)
	l.addi  	r4,r0,65	 # movqi: move immediate
	l.sb    	0(r3),r4	    # movqi
	l.movhi 	r3,hi(_Bool_Glob)
	l.ori   	r3,r3,lo(_Bool_Glob)
	l.addi  	r4,r0,0	 # move immediate I
	l.sw    	0(r3),r4	 # SI store
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_Proc_5, .-_Proc_5
	.align 4
.proc _Proc_4
	.global _Proc_4
	.type	_Proc_4, @function
_Proc_4:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.movhi 	r3,hi(_Ch_1_Glob)
	l.ori   	r3,r3,lo(_Ch_1_Glob)
	l.movhi 	r6,hi(_Bool_Glob)
	l.ori   	r6,r6,lo(_Bool_Glob)
	l.lbs   	r3,0(r3)	 # extendqisi2_no_sext_mem
	l.lwz   	r4,0(r6)	 # SI load
	l.sfnei	r3,65
	l.bf    	.L14	# delay slot filled
	l.addi  	r5,r0,0	 # move immediate I
	l.addi  	r5,r0,1	 # move immediate I
.L14:
	l.or    	r4,r5,r4
	l.movhi 	r3,hi(_Ch_2_Glob)
	l.ori   	r3,r3,lo(_Ch_2_Glob)
	l.addi  	r5,r0,66	 # movqi: move immediate
	l.sw    	0(r6),r4	 # SI store
	l.sb    	0(r3),r5	    # movqi
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_Proc_4, .-_Proc_4
	.align 4
.proc _Proc_7
	.global _Proc_7
	.type	_Proc_7, @function
_Proc_7:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.addi  	r3,r3,2
	l.add   	r3,r4,r3
	l.sw    	0(r5),r3	 # SI store
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_Proc_7, .-_Proc_7
	.align 4
.proc _Proc_8
	.global _Proc_8
	.type	_Proc_8, @function
_Proc_8:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.addi  	r8,r5,5
	l.slli  	r13,r8,2
	l.addi  	r5,r5,6
	l.ori   	r11,r8,0	 # move reg to reg
	l.add   	r7,r13,r3
	l.sflts 	r5,r8
	l.sw    	4(r7),r6	 # SI store
	l.sw    	120(r7),r8	 # SI store
	l.bf    	.L22	# delay slot filled
	l.sw    	0(r7),r6	 # SI store
	l.addi  	r6,r0,204	 # move immediate I
	l.mul   	r6,r8,r6
	l.add   	r6,r6,r4
.L20:
	l.sw    	0(r6),r8	 # SI store
	l.addi  	r11,r11,1
	l.sflts 	r5,r11
	l.bnf   	.L20	# delay slot filled
	l.addi  	r6,r6,4
.L22:
	l.addi  	r5,r0,204	 # move immediate I
	l.add   	r3,r13,r3
	l.mul   	r5,r8,r5
	l.add   	r4,r5,r4
	l.addi  	r6,r4,-4
	l.lwz   	r5,0(r6)	 # SI load
	l.addi  	r5,r5,1
	l.sw    	0(r6),r5	 # SI store
	l.lwz   	r3,0(r3)	 # SI load
	l.sw    	4000(r4),r3	 # SI store
	l.addi  	r4,r0,5	 # move immediate I
	l.movhi 	r3,hi(_Int_Glob)
	l.ori   	r3,r3,lo(_Int_Glob)
	l.sw    	0(r3),r4	 # SI store
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_Proc_8, .-_Proc_8
	.align 4
.proc _Func_1
	.global _Func_1
	.type	_Func_1, @function
_Func_1:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.slli  	r3,r3,24
	l.slli  	r4,r4,24
	l.addi  	r11,r0,0	 # move immediate I
	l.sfeq 	r4,r3
	l.bnf   	.L23	# delay slot filled
	l.srai  	r5,r3,24
	l.movhi 	r3,hi(_Ch_1_Glob)
	l.ori   	r3,r3,lo(_Ch_1_Glob)
	l.addi  	r11,r0,1	 # move immediate I
	l.sb    	0(r3),r5	    # movqi
.L23:
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_Func_1, .-_Func_1
	.align 4
.proc _Func_2
	.global _Func_2
	.type	_Func_2, @function
_Func_2:

	# gpr_save_area 20 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-28
	l.sw     	4(r1),r2
	l.addi   	r2,r1,28
	l.sw     	0(r1),r9
	l.sw    	8(r1),r10
	l.sw    	12(r1),r12
	l.sw    	16(r1),r14
	l.sw    	20(r1),r16
	l.sw    	24(r1),r18
	l.ori   	r18,r4,0	 # move reg to reg
	l.ori   	r14,r3,0	 # move reg to reg
	l.addi  	r16,r0,0	 # move immediate I
	l.addi  	r12,r0,2	 # move immediate I
	l.addi  	r10,r4,3
	l.add   	r3,r14,r12
.L39:
	l.lbs   	r4,0(r10)	 # extendqisi2_no_sext_mem
	l.jal   	_Func_1	# delay slot filled
	l.lbs   	r3,0(r3)	 # extendqisi2_no_sext_mem
	l.sfnei	r11,0
	l.bf    	.L38	# delay slot filled
	l.sfgtsi	r12,2
	l.addi  	r10,r10,1
	l.addi  	r16,r0,65	 # move immediate I
	l.addi  	r12,r12,1
	l.sfgtsi	r12,2
.L38:
	l.bnf   	.L39	# delay slot filled
	l.add   	r3,r14,r12
	l.addi  	r3,r16,-87
	l.sfgtui	r3,2
	l.bf    	.L40	# delay slot filled
	l.sfnei	r16,82
	l.addi  	r12,r0,7	 # move immediate I
.L40:
	l.bnf   	.L26	# delay slot filled
	l.addi  	r4,r0,1	 # move immediate I
	l.ori   	r4,r18,0	 # move reg to reg
	l.jal   	_strcmp	# delay slot filled
	l.ori   	r3,r14,0	 # move reg to reg
	l.sflesi	r11,0
	l.bf    	.L26	# delay slot filled
	l.addi  	r4,r0,0	 # move immediate I
	l.addi  	r12,r12,7
	l.movhi 	r3,hi(_Int_Glob)
	l.ori   	r3,r3,lo(_Int_Glob)
	l.addi  	r4,r0,1	 # move immediate I
	l.sw    	0(r3),r12	 # SI store
.L26:
	l.ori   	r11,r4,0	 # move reg to reg
	l.lwz    	r9,0(r1)
	l.lwz    	r2,4(r1)
	l.lwz    	r10,8(r1)
	l.lwz    	r12,12(r1)
	l.lwz    	r14,16(r1)
	l.lwz    	r16,20(r1)
	l.lwz    	r18,24(r1)
	l.jr  	r9
	l.addi   	r1,r1,28
	.size	_Func_2, .-_Func_2
	.align 4
.proc _Proc_2
	.global _Proc_2
	.type	_Proc_2, @function
_Proc_2:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.lwz   	r5,0(r3)	 # SI load
	l.movhi 	r4,hi(_Ch_1_Glob)
	l.ori   	r4,r4,lo(_Ch_1_Glob)
	l.lbs   	r4,0(r4)	 # extendqisi2_no_sext_mem
	l.sfnei	r4,65
	l.bf    	.L44	# delay slot filled
	l.addi  	r5,r5,9
	l.movhi 	r4,hi(_Int_Glob)
	l.ori   	r4,r4,lo(_Int_Glob)
	l.lwz   	r4,0(r4)	 # SI load
	l.sub   	r4,r5,r4
	l.sw    	0(r3),r4	 # SI store
.L44:
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_Proc_2, .-_Proc_2
	.align 4
.proc _Proc_3
	.global _Proc_3
	.type	_Proc_3, @function
_Proc_3:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-8
	l.sw     	4(r1),r2
	l.addi   	r2,r1,8
	l.sw     	0(r1),r9
	l.movhi 	r7,hi(_Ptr_Glob)
	l.ori   	r7,r7,lo(_Ptr_Glob)
	l.movhi 	r4,hi(_Int_Glob)
	l.ori   	r4,r4,lo(_Int_Glob)
	l.ori   	r6,r3,0	 # move reg to reg
	l.lwz   	r5,0(r7)	 # SI load
	l.lwz   	r4,0(r4)	 # SI load
	l.sfeqi	r5,0
	l.bf    	.L47	# delay slot filled
	l.addi  	r3,r0,10	 # move immediate I
	l.lwz   	r5,0(r5)	 # SI load
	l.sw    	0(r6),r5	 # SI store
	l.lwz   	r5,0(r7)	 # SI load
.L47:
	l.jal   	_Proc_7	# delay slot filled
	l.addi  	r5,r5,12
	l.lwz    	r9,0(r1)
	l.lwz    	r2,4(r1)
	l.jr  	r9
	l.addi   	r1,r1,8
	.size	_Proc_3, .-_Proc_3
	.align 4
.proc _Func_3
	.global _Func_3
	.type	_Func_3, @function
_Func_3:

	# gpr_save_area 0 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-4
	l.sw     	0(r1),r2
	l.addi   	r2,r1,4
	l.xori  	r3,r3,2
	l.addi  	r11,r0,1	 # move immediate I
	l.sub   	r4,r0,r3
	l.or    	r3,r4,r3
	l.srli  	r3,r3,31
	l.sub   	r11,r11,r3
	l.lwz    	r2,0(r1)
	l.jr  	r9
	l.addi   	r1,r1,4
	.size	_Func_3, .-_Func_3
	.align 4
.proc _Proc_6
	.global _Proc_6
	.type	_Proc_6, @function
_Proc_6:

	# gpr_save_area 8 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-16
	l.sw     	4(r1),r2
	l.addi   	r2,r1,16
	l.sw     	0(r1),r9
	l.sw    	8(r1),r10
	l.sw    	12(r1),r12
	l.ori   	r10,r3,0	 # move reg to reg
	l.jal   	_Func_3	# delay slot filled
	l.ori   	r12,r4,0	 # move reg to reg
	l.sfnei	r11,0
	l.bf    	.L52	# delay slot filled
	l.ori   	r3,r10,0	 # move reg to reg
	l.addi  	r3,r0,3	 # move immediate I
.L52:
	l.sfeqi	r10,1
	l.bf    	.L55	# delay slot filled
	l.sfltui	r10,1
	l.bf    	.L62	# delay slot filled
	l.sfeqi	r10,2
	l.bf    	.L58	# delay slot filled
	l.sfeqi	r10,4
	l.bnf   	.L61
	l.nop			# nop delay slot
	l.j     	.L61	# delay slot filled
	l.addi  	r3,r0,2	 # move immediate I
.L55:
	l.movhi 	r3,hi(_Int_Glob)
	l.ori   	r3,r3,lo(_Int_Glob)
	l.lwz   	r3,0(r3)	 # SI load
	l.sflesi	r3,100
	l.bf    	.L56
	l.nop			# nop delay slot
.L62:
	l.j     	.L61	# delay slot filled
	l.addi  	r3,r0,0	 # move immediate I
.L56:
	l.j     	.L61	# delay slot filled
	l.addi  	r3,r0,3	 # move immediate I
.L58:
	l.addi  	r3,r0,1	 # move immediate I
.L61:
	l.sw    	0(r12),r3	 # SI store
	l.lwz    	r9,0(r1)
	l.lwz    	r2,4(r1)
	l.lwz    	r10,8(r1)
	l.lwz    	r12,12(r1)
	l.jr  	r9
	l.addi   	r1,r1,16
	.size	_Proc_6, .-_Proc_6
	.align 4
.proc _Proc_1
	.global _Proc_1
	.type	_Proc_1, @function
_Proc_1:

	# gpr_save_area 12 vars 0 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-20
	l.sw     	4(r1),r2
	l.addi   	r2,r1,20
	l.sw     	0(r1),r9
	l.sw    	8(r1),r10
	l.sw    	12(r1),r12
	l.sw    	16(r1),r14
	l.movhi 	r14,hi(_Ptr_Glob)
	l.ori   	r14,r14,lo(_Ptr_Glob)
	l.lwz   	r10,0(r3)	 # SI load
	l.lwz   	r4,0(r14)	 # SI load
	l.ori   	r12,r3,0	 # move reg to reg
	l.addi  	r6,r0,5	 # move immediate I
	l.lwz   	r3,0(r4)	 # SI load
	l.sw    	0(r10),r3	 # SI store
	l.lwz   	r5,4(r4)	 # SI load
	l.ori   	r3,r10,0	 # move reg to reg
	l.sw    	4(r10),r5	 # SI store
	l.lwz   	r5,8(r4)	 # SI load
	l.sw    	8(r10),r5	 # SI store
	l.lwz   	r5,12(r4)	 # SI load
	l.sw    	12(r10),r5	 # SI store
	l.lwz   	r5,16(r4)	 # SI load
	l.sw    	16(r10),r5	 # SI store
	l.lwz   	r5,20(r4)	 # SI load
	l.sw    	20(r10),r5	 # SI store
	l.lwz   	r5,24(r4)	 # SI load
	l.sw    	24(r10),r5	 # SI store
	l.lwz   	r5,28(r4)	 # SI load
	l.sw    	28(r10),r5	 # SI store
	l.lwz   	r5,32(r4)	 # SI load
	l.sw    	32(r10),r5	 # SI store
	l.lwz   	r5,36(r4)	 # SI load
	l.sw    	36(r10),r5	 # SI store
	l.lwz   	r5,40(r4)	 # SI load
	l.sw    	40(r10),r5	 # SI store
	l.lwz   	r4,44(r4)	 # SI load
	l.sw    	44(r10),r4	 # SI store
	l.sw    	12(r12),r6	 # SI store
	l.lwz   	r4,0(r12)	 # SI load
	l.sw    	12(r10),r6	 # SI store
	l.jal   	_Proc_3	# delay slot filled
	l.sw    	0(r10),r4	 # SI store
	l.lwz   	r3,4(r10)	 # SI load
	l.sfnei	r3,0
	l.bnf   	.L66	# delay slot filled
	l.addi  	r4,r10,8
	l.lwz   	r3,0(r12)	 # SI load
	l.lwz   	r4,0(r3)	 # SI load
	l.sw    	0(r12),r4	 # SI store
	l.lwz   	r4,4(r3)	 # SI load
	l.sw    	4(r12),r4	 # SI store
	l.lwz   	r4,8(r3)	 # SI load
	l.sw    	8(r12),r4	 # SI store
	l.lwz   	r4,12(r3)	 # SI load
	l.sw    	12(r12),r4	 # SI store
	l.lwz   	r4,16(r3)	 # SI load
	l.sw    	16(r12),r4	 # SI store
	l.lwz   	r4,20(r3)	 # SI load
	l.sw    	20(r12),r4	 # SI store
	l.lwz   	r4,24(r3)	 # SI load
	l.sw    	24(r12),r4	 # SI store
	l.lwz   	r4,28(r3)	 # SI load
	l.sw    	28(r12),r4	 # SI store
	l.lwz   	r4,32(r3)	 # SI load
	l.sw    	32(r12),r4	 # SI store
	l.lwz   	r4,36(r3)	 # SI load
	l.sw    	36(r12),r4	 # SI store
	l.lwz   	r4,40(r3)	 # SI load
	l.sw    	40(r12),r4	 # SI store
	l.lwz   	r3,44(r3)	 # SI load
	l.j     	.L63	# delay slot filled
	l.sw    	44(r12),r3	 # SI store
.L66:
	l.addi  	r3,r0,6	 # move immediate I
	l.sw    	12(r10),r3	 # SI store
	l.jal   	_Proc_6	# delay slot filled
	l.lwz   	r3,8(r12)	 # SI load
	l.lwz   	r3,0(r14)	 # SI load
	l.addi  	r5,r10,12
	l.lwz   	r4,0(r3)	 # SI load
	l.sw    	0(r10),r4	 # SI store
	l.lwz   	r3,12(r10)	 # SI load
	l.jal   	_Proc_7	# delay slot filled
	l.addi  	r4,r0,10	 # move immediate I
.L63:
	l.lwz    	r9,0(r1)
	l.lwz    	r2,4(r1)
	l.lwz    	r10,8(r1)
	l.lwz    	r12,12(r1)
	l.lwz    	r14,16(r1)
	l.jr  	r9
	l.addi   	r1,r1,20
	.size	_Proc_1, .-_Proc_1
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Execution starts, "
.LC1:
	.string	" runs through Dhrystone\n"
.LC2:
	.string	"Begin Time = "
.LC3:
	.string	"\n"
.LC4:
	.string	"End Time   = "
.LC5:
	.string	"Measured time too small to obtain meaningful results\n"
.LC6:
	.string	"Please increase number of runs\n"
.LC7:
	.string	"OR1K at "
.LC8:
	.string	" MHz  "
.LC9:
	.string	"(+PROC_6)"
.LC10:
	.string	"Microseconds for one run through Dhrystone: "
.LC11:
	.string	"us / "
.LC12:
	.string	" runs\n"
.LC13:
	.string	"Dhrystones per Second:                      "
.LC14:
	.string	" \n"
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC15:
	.long	1145590361
	.align 4
.LC16:
	.long	1159745618
	.align 4
.LC17:
	.long	1330074177
	.align 4
.LC18:
	.long	1398035017
	.align 4
.LC19:
	.long	659702816
.section .text
	.align 4
.proc _main
	.global _main
	.type	_main, @function
_main:

	# gpr_save_area 44 vars 172 current_function_outgoing_args_size 0
	l.addi   	r1,r1,-224
	l.sw     	4(r1),r2
	l.addi   	r2,r1,224
	l.sw     	0(r1),r9
	l.sw    	8(r1),r10
	l.sw    	12(r1),r12
	l.sw    	16(r1),r14
	l.sw    	20(r1),r16
	l.sw    	24(r1),r18
	l.sw    	28(r1),r20
	l.sw    	32(r1),r22
	l.sw    	36(r1),r24
	l.sw    	40(r1),r26
	l.sw    	44(r1),r28
	l.sw    	48(r1),r30
	l.addi  	r7,r2,-112
	l.addi  	r4,r2,-160
	l.movhi 	r5,hi(_Next_Ptr_Glob)
	l.ori   	r5,r5,lo(_Next_Ptr_Glob)
	l.sw    	0(r4),r7	 # SI store
	l.movhi 	r3,hi(1145569280)	 # move immediate M
	l.sw    	0(r5),r7	 # SI store
	l.ori   	r12,r3,21081
	l.addi  	r5,r0,2	 # move immediate I
	l.movhi 	r3,hi(1159725056)	 # move immediate M
	l.sw    	-152(r2),r5	 # SI store
	l.ori   	r18,r3,20562
	l.addi  	r5,r0,40	 # move immediate I
	l.movhi 	r22,hi(1294729216)	 # move immediate M
	l.sw    	-148(r2),r5	 # SI store
	l.movhi 	r3,hi(1330053120)	 # move immediate M
	l.movhi 	r5,hi(1330446336)	 # move immediate M
	l.ori   	r6,r22,8275
	l.ori   	r5,r5,17696
	l.ori   	r20,r3,21057
	l.sw    	-124(r2),r5	 # SI store
	l.sw    	-128(r2),r6	 # SI store
	l.movhi 	r5,hi(659750912)	 # move immediate M
	l.addi  	r3,r0,10	 # move immediate I
	l.ori   	r5,r5,21536
	l.movhi 	r16,hi(1398013952)	 # move immediate M
	l.sw    	-12(r2),r5	 # SI store
	l.ori   	r8,r16,21065
	l.movhi 	r5,hi(_Arr_2_Glob)
	l.ori   	r5,r5,lo(_Arr_2_Glob)
	l.ori   	r11,r16,20302
	l.sw    	1628(r5),r3	 # SI store
	l.ori   	r10,r22,8241
	l.movhi 	r3,hi(_Ptr_Glob)
	l.ori   	r3,r3,lo(_Ptr_Glob)
	l.addi  	r5,r0,20039	 # movhi: move immediate
	l.sw    	0(r3),r4	 # SI store
	l.sw    	-28(r2),r11	 # SI store
	l.addi  	r3,r0,0	 # movqi: move immediate
	l.addi  	r4,r0,0	 # move immediate I
	l.sb    	-114(r2),r3	    # movqi
	l.sb    	-2(r2),r3	    # movqi
	l.sw    	-140(r2),r11	 # SI store
	l.sw    	-120(r2),r8	 # SI store
	l.sh    	-116(r2),r5	 # movhi
	l.sw    	-8(r2),r8	 # SI store
	l.sh    	-4(r2),r5	 # movhi
	l.sw    	-156(r2),r4	 # SI store
	l.movhi 	r3,hi(.LC0)
	l.ori   	r3,r3,lo(.LC0)
	l.sw    	-16(r2),r10	 # SI store
	l.sw    	-144(r2),r12	 # SI store
	l.sw    	-136(r2),r18	 # SI store
	l.sw    	-132(r2),r20	 # SI store
	l.sw    	-32(r2),r12	 # SI store
	l.sw    	-24(r2),r18	 # SI store
	l.sw    	-20(r2),r20	 # SI store
	l.jal   	_prints	# delay slot filled
	l.addi  	r14,r0,1	 # move immediate I
	l.addi  	r3,r0,10	 # move immediate I
	l.movhi 	r16,hi(_Ch_2_Glob)
	l.ori   	r16,r16,lo(_Ch_2_Glob)
	l.ori   	r4,r3,0	 # move reg to reg
	l.jal   	_printn	# delay slot filled
	l.ori   	r30,r14,0	 # move reg to reg
	l.movhi 	r3,hi(.LC1)
	l.ori   	r3,r3,lo(.LC1)
	l.jal   	_prints
	l.nop			# nop delay slot
	l.jal   	_start_timer	# delay slot filled
	l.addi  	r3,r0,0	 # move immediate I
	l.jal   	_read_timer	# delay slot filled
	l.addi  	r3,r0,0	 # move immediate I
	l.movhi 	r4,hi(_Begin_Time)
	l.ori   	r4,r4,lo(_Begin_Time)
	l.sw    	0(r4),r11	 # SI store
.L80:
	l.jal   	_Proc_5	# delay slot filled
	l.addi  	r12,r0,3	 # move immediate I
	l.jal   	_Proc_4
	l.nop			# nop delay slot
	l.movhi 	r3,hi(1398013952)	 # move immediate M
	l.addi  	r5,r0,2	 # move immediate I
	l.ori   	r4,r3,20302
	l.sw    	-172(r2),r5	 # SI store
	l.movhi 	r3,hi(1145569280)	 # move immediate M
	l.sw    	-60(r2),r4	 # SI store
	l.ori   	r3,r3,21081
	l.movhi 	r4,hi(1294729216)	 # move immediate M
	l.sw    	-64(r2),r3	 # SI store
	l.ori   	r4,r4,8242
	l.movhi 	r3,hi(1159725056)	 # move immediate M
	l.sw    	-48(r2),r4	 # SI store
	l.ori   	r3,r3,20562
	l.addi  	r4,r0,0	 # movqi: move immediate
	l.sw    	-56(r2),r3	 # SI store
	l.movhi 	r5,hi(1398013952)	 # move immediate M
	l.movhi 	r3,hi(1330053120)	 # move immediate M
	l.ori   	r5,r5,21065
	l.ori   	r3,r3,21057
	l.sb    	-34(r2),r4	    # movqi
	l.sw    	-52(r2),r3	 # SI store
	l.sw    	-40(r2),r5	 # SI store
	l.movhi 	r3,hi(659423232)	 # move immediate M
	l.sw    	-168(r2),r30	 # SI store
	l.ori   	r3,r3,17440
	l.addi  	r4,r2,-64
	l.sw    	-44(r2),r3	 # SI store
	l.addi  	r3,r0,20039	 # movhi: move immediate
	l.sh    	-36(r2),r3	 # movhi
	l.jal   	_Func_2	# delay slot filled
	l.addi  	r3,r2,-32
	l.sfnei	r11,0
	l.bf    	.L71	# delay slot filled
	l.addi  	r3,r0,0	 # move immediate I
	l.ori   	r3,r30,0	 # move reg to reg
.L71:
	l.lwz   	r5,-172(r2)	 # SI load
	l.movhi 	r4,hi(_Bool_Glob)
	l.ori   	r4,r4,lo(_Bool_Glob)
	l.sfgesi	r5,3
	l.bf    	.L87	# delay slot filled
	l.sw    	0(r4),r3	 # SI store
.L92:
	l.slli  	r6,r5,2
	l.ori   	r3,r5,0	 # move reg to reg
	l.addi  	r4,r0,3	 # move immediate I
	l.add   	r6,r6,r5
	l.addi  	r6,r6,-3
	l.addi  	r5,r2,-164
	l.jal   	_Proc_7	# delay slot filled
	l.sw    	-164(r2),r6	 # SI store
	l.lwz   	r3,-172(r2)	 # SI load
	l.addi  	r5,r3,1
	l.sfgesi	r5,3
	l.bnf   	.L92	# delay slot filled
	l.sw    	-172(r2),r5	 # SI store
.L87:
	l.movhi 	r3,hi(_Arr_1_Glob)
	l.ori   	r3,r3,lo(_Arr_1_Glob)
	l.movhi 	r4,hi(_Arr_2_Glob)
	l.ori   	r4,r4,lo(_Arr_2_Glob)
	l.lwz   	r6,-164(r2)	 # SI load
	l.jal   	_Proc_8	# delay slot filled
	l.addi  	r10,r0,65	 # move immediate I
	l.movhi 	r5,hi(_Ptr_Glob)
	l.ori   	r5,r5,lo(_Ptr_Glob)
	l.jal   	_Proc_1	# delay slot filled
	l.lwz   	r3,0(r5)	 # SI load
	l.lbs   	r3,0(r16)	 # extendqisi2_no_sext_mem
	l.sfltsi	r3,65
	l.bf    	.L93	# delay slot filled
	l.lwz   	r3,-172(r2)	 # SI load
	l.movhi 	r3,hi(.LC15)
	l.ori   	r3,r3,lo(.LC15)
	l.movhi 	r4,hi(.LC16)
	l.ori   	r4,r4,lo(.LC16)
	l.lwz   	r28,0(r3)	 # SI load
	l.movhi 	r5,hi(.LC17)
	l.ori   	r5,r5,lo(.LC17)
	l.movhi 	r3,hi(.LC18)
	l.ori   	r3,r3,lo(.LC18)
	l.movhi 	r26,hi(1398013952)	 # move immediate M
	l.lwz   	r24,0(r4)	 # SI load
	l.lwz   	r22,0(r5)	 # SI load
	l.lwz   	r20,0(r3)	 # SI load
	l.movhi 	r4,hi(.LC19)
	l.ori   	r4,r4,lo(.LC19)
	l.j     	.L79	# delay slot filled
	l.lwz   	r18,0(r4)	 # SI load
.L77:
	l.addi  	r3,r10,1
	l.lbs   	r4,0(r16)	 # extendqisi2_no_sext_mem
	l.slli  	r3,r3,24
	l.srai  	r10,r3,24
	l.sflts 	r4,r10
	l.bf    	.L93	# delay slot filled
	l.lwz   	r3,-172(r2)	 # SI load
.L79:
	l.ori   	r3,r10,0	 # move reg to reg
	l.jal   	_Func_1	# delay slot filled
	l.addi  	r4,r0,67	 # move immediate I
	l.lwz   	r5,-168(r2)	 # SI load
	l.addi  	r3,r0,0	 # move immediate I
	l.sfne 	r11,r5
	l.bf    	.L77	# delay slot filled
	l.addi  	r4,r2,-168
	l.jal   	_Proc_6	# delay slot filled
	l.ori   	r12,r14,0	 # move reg to reg
	l.ori   	r3,r26,20302
	l.addi  	r4,r0,0	 # movqi: move immediate
	l.sw    	-60(r2),r3	 # SI store
	l.movhi 	r5,hi(1294729216)	 # move immediate M
	l.movhi 	r3,hi(_Int_Glob)
	l.ori   	r3,r3,lo(_Int_Glob)
	l.sb    	-34(r2),r4	    # movqi
	l.sw    	0(r3),r14	 # SI store
	l.ori   	r5,r5,8243
	l.addi  	r3,r0,20039	 # movhi: move immediate
	l.lbs   	r4,0(r16)	 # extendqisi2_no_sext_mem
	l.sw    	-64(r2),r28	 # SI store
	l.sh    	-36(r2),r3	 # movhi
	l.sw    	-56(r2),r24	 # SI store
	l.addi  	r3,r10,1
	l.sw    	-52(r2),r22	 # SI store
	l.slli  	r3,r3,24
	l.sw    	-48(r2),r5	 # SI store
	l.sw    	-44(r2),r18	 # SI store
	l.srai  	r10,r3,24
	l.sflts 	r4,r10
	l.bnf   	.L79	# delay slot filled
	l.sw    	-40(r2),r20	 # SI store
	l.lwz   	r3,-172(r2)	 # SI load
.L93:
	l.lwz   	r4,-164(r2)	 # SI load
	l.mul   	r12,r12,r3
	l.addi  	r14,r14,1
	l.div   	r4,r12,r4
	l.addi  	r3,r2,-172
	l.jal   	_Proc_2	# delay slot filled
	l.sw    	-172(r2),r4	 # SI store
	l.sfgtsi	r14,10
	l.bnf   	.L80
	l.nop			# nop delay slot
	l.movhi 	r10,hi(_User_Time)
	l.ori   	r10,r10,lo(_User_Time)
	l.jal   	_read_timer	# delay slot filled
	l.addi  	r3,r0,0	 # move immediate I
	l.movhi 	r5,hi(_Begin_Time)
	l.ori   	r5,r5,lo(_Begin_Time)
	l.movhi 	r12,hi(_End_Time)
	l.ori   	r12,r12,lo(_End_Time)
	l.lwz   	r3,0(r5)	 # SI load
	l.sw    	0(r12),r11	 # SI store
	l.sub   	r3,r11,r3
	l.sw    	0(r10),r3	 # SI store
	l.movhi 	r3,hi(.LC2)
	l.ori   	r3,r3,lo(.LC2)
	l.jal   	_prints
	l.nop			# nop delay slot
	l.movhi 	r4,hi(_Begin_Time)
	l.ori   	r4,r4,lo(_Begin_Time)
	l.lwz   	r3,0(r4)	 # SI load
	l.jal   	_printn	# delay slot filled
	l.addi  	r4,r0,10	 # move immediate I
	l.movhi 	r3,hi(.LC3)
	l.ori   	r3,r3,lo(.LC3)
	l.jal   	_prints
	l.nop			# nop delay slot
	l.movhi 	r3,hi(.LC4)
	l.ori   	r3,r3,lo(.LC4)
	l.jal   	_prints
	l.nop			# nop delay slot
	l.lwz   	r3,0(r12)	 # SI load
	l.jal   	_printn	# delay slot filled
	l.addi  	r4,r0,10	 # move immediate I
	l.movhi 	r3,hi(.LC3)
	l.ori   	r3,r3,lo(.LC3)
	l.jal   	_prints
	l.nop			# nop delay slot
	l.lwz   	r3,0(r10)	 # SI load
	l.sfnei	r3,0
	l.bf    	.L81
	l.nop			# nop delay slot
	l.movhi 	r3,hi(.LC5)
	l.ori   	r3,r3,lo(.LC5)
	l.jal   	_prints
	l.nop			# nop delay slot
	l.movhi 	r3,hi(.LC6)
	l.ori   	r3,r3,lo(.LC6)
	l.jal   	_prints
	l.nop			# nop delay slot
	l.movhi 	r3,hi(.LC3)
	l.ori   	r3,r3,lo(.LC3)
	l.j     	.L91
	l.nop			# nop delay slot
.L81:
	l.movhi 	r3,hi(.LC7)
	l.ori   	r3,r3,lo(.LC7)
	l.movhi 	r12,hi(_Microseconds)
	l.ori   	r12,r12,lo(_Microseconds)
	l.jal   	_prints
	l.nop			# nop delay slot
	l.addi  	r3,r0,10	 # move immediate I
	l.movhi 	r14,hi(_Dhrystones_Per_Second)
	l.ori   	r14,r14,lo(_Dhrystones_Per_Second)
	l.jal   	_printn	# delay slot filled
	l.ori   	r4,r3,0	 # move reg to reg
	l.movhi 	r3,hi(.LC8)
	l.ori   	r3,r3,lo(.LC8)
	l.jal   	_prints
	l.nop			# nop delay slot
	l.movhi 	r3,hi(.LC9)
	l.ori   	r3,r3,lo(.LC9)
	l.jal   	_prints
	l.nop			# nop delay slot
	l.movhi 	r3,hi(.LC3)
	l.ori   	r3,r3,lo(.LC3)
	l.jal   	_prints
	l.nop			# nop delay slot
	l.lwz   	r7,0(r10)	 # SI load
	l.addi  	r5,r0,10	 # move immediate I
	l.movhi 	r3,hi(.LC10)
	l.ori   	r3,r3,lo(.LC10)
	l.divu  	r6,r7,r5
	l.movhi 	r5,hi(983040)	 # move immediate M
	l.sw    	0(r12),r6	 # SI store
	l.ori   	r4,r5,16960
	l.addi  	r5,r0,10	 # move immediate I
	l.mul   	r4,r5,r4
	l.divu  	r4,r4,r7
	l.jal   	_prints	# delay slot filled
	l.sw    	0(r14),r4	 # SI store
	l.addi  	r4,r0,10	 # move immediate I
	l.jal   	_printn	# delay slot filled
	l.lwz   	r3,0(r12)	 # SI load
	l.movhi 	r3,hi(.LC11)
	l.ori   	r3,r3,lo(.LC11)
	l.jal   	_prints
	l.nop			# nop delay slot
	l.addi  	r3,r0,10	 # move immediate I
	l.jal   	_printn	# delay slot filled
	l.ori   	r4,r3,0	 # move reg to reg
	l.movhi 	r3,hi(.LC12)
	l.ori   	r3,r3,lo(.LC12)
	l.jal   	_prints
	l.nop			# nop delay slot
	l.movhi 	r3,hi(.LC13)
	l.ori   	r3,r3,lo(.LC13)
	l.jal   	_prints
	l.nop			# nop delay slot
	l.lwz   	r3,0(r14)	 # SI load
	l.jal   	_printn	# delay slot filled
	l.addi  	r4,r0,10	 # move immediate I
	l.movhi 	r3,hi(.LC14)
	l.ori   	r3,r3,lo(.LC14)
.L91:
	l.jal   	_prints
	l.nop			# nop delay slot
	l.movhi 	r3,hi(-559087616)	 # move immediate M
	l.jal   	_report	# delay slot filled
	l.ori   	r3,r3,57005
	l.addi  	r11,r0,0	 # move immediate I
	l.lwz    	r9,0(r1)
	l.lwz    	r2,4(r1)
	l.lwz    	r10,8(r1)
	l.lwz    	r12,12(r1)
	l.lwz    	r14,16(r1)
	l.lwz    	r16,20(r1)
	l.lwz    	r18,24(r1)
	l.lwz    	r20,28(r1)
	l.lwz    	r22,32(r1)
	l.lwz    	r24,36(r1)
	l.lwz    	r26,40(r1)
	l.lwz    	r28,44(r1)
	l.lwz    	r30,48(r1)
	l.jr  	r9
	l.addi   	r1,r1,224
	.size	_main, .-_main
	.comm	_Ptr_Glob,4,4
	.comm	_Next_Ptr_Glob,4,4
	.comm	_Int_Glob,4,4
	.comm	_Bool_Glob,4,4
	.comm	_Ch_1_Glob,1,1
	.comm	_Ch_2_Glob,1,1
	.comm	_Arr_1_Glob,200,4
	.comm	_Arr_2_Glob,10000,4
	.comm	_Begin_Time,4,4
	.comm	_End_Time,4,4
	.comm	_User_Time,4,4
	.comm	_Microseconds,4,4
	.comm	_Dhrystones_Per_Second,4,4
	.ident	"GCC: (GNU) 3.4.4"
