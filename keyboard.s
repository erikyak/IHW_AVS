.data 
	A: .asciz "A"
	B: .asciz "B"


.include "macrolib.s"
.global keyboard
.text
keyboard:
	addi sp sp -16
	sw ra (sp)
	sw s0 4(sp)
	sw s1 8(sp)
	sw s2 12(sp)
	mv s0 a1		# first array(array_a)
	mv s1 a2		# second array(array_b)
	input_n ()		# pass nothing, return a0
	mv s2 a0		# n value
	bnez s2 grater_than_0	# zero check
	zero_case ()		# pass nothing, nothing return(just print)
	j return
	grater_than_0:		# not-zero case
	mv a0 s2
	mv a1 s0
	setup_array_a (a0 a1)	# pass n, first array(array_a), return nothing
	la a1 A
	mv a0 s2
	mv a2 s0
	print_arr_setup(a2 a0 a1) # pass n, array(array_a), array label (A), return nothing
	mv a0 s1
	mv a1 s0
	mv a2 s2
	setup_array_b (a0 a1 a2) # pass second array(array_b), first array(array_a), n, return nothing
	la a1 B
	mv a0 s1
	mv a2 s2
	print_arr_setup(a0 a2 a1) # pass n, array(array_b), array label (B), return nothing
	return:
	lw ra (sp)
	lw s0 4(sp)
	lw s1 8(sp)
	lw s2 12(sp)
	addi sp sp 16
	mv a0 zero
	ret