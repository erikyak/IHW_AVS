.data 
	test_n: 10	3	4	6	0
	test_n_end:
	test_a: 1 2 3 4 5 6 7 8 9 10	4 5 6	12 13 14 7	0 1 2 3 5 2000
	test_a_end:
	correct_answers: .asciz "B = {1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800}" "B = {24, 120, 720}"
			"B = {479001600, 0, 0, 5040}" "B = {1, 1, 2, 6, 120, 0}" "You entered N equals zero, there is no calculations"
	correct_answer_end:
	entered_text: .asciz "Entered array: "
	calculated_text: .asciz "Calculated answer: "

	A: .asciz "A"
	B: .asciz "B"
	
.include "macrolib.s"
.global tests_setup
.text
tests_setup:
	addi sp sp -24
	sw s4 20(sp)
	sw s3 16(sp)
	sw s2 12(sp)
	sw s1 8(sp)
	sw s0 4(sp)
	sw ra (sp)
	mv s2 a2			# original array(array_b)
	la s0 test_n			# test n values
	la s1 test_a			# test a arrays
	la s3 correct_answers		# test correct answers
	la s4 test_n_end
tests:
	lw a3 (s0)
	lw a4 (s1)
	la a0 entered_text
	li a7 4
	ecall
	bnez a3 grater_than_0_test	# zero check
	li a7 11
	li a0 '\n'
	ecall
	la a0 calculated_text
	li a7 4
	ecall
	zero_case ()			# pass nothing, nothing return(just print)
	li a7 11
	li a0 '\n'
	ecall
	j return_test
	grater_than_0_test:
	la a1 A
	mv a0 s1
	mv a2 a3
	print_arr_setup(a0 a2 a1)	# pass test_n, test_a(they different for each iterations), array label (A), return nothing
	mv a1 s1
	mv a2 a3
	setup_array_b (s2 a1 a2)	# pass second array(array_b), first array(test_a)(different for each iterations), n, return nothing
	la a0 calculated_text
	li a7 4
	ecall
	la a1 B
	mv a2 a3
	print_arr_setup (s2 a2 a1)	# pass test_n(different for each iterations), array(array_b), array label (B), return nothing
	return_test:
	mv a1 s3
	correct_answer_print (a1)	# pass correct_answer(different for each iterations), return nothing
	mv s3 a1
	li a7 11
	li a0 '\n'
	ecall
	li a4 4
	mul a3 a3 a4
	addi s0 s0 4
	add s1 s1 a3
	bne s4 s0 tests
tests_done:
	lw s4 20(sp)
	lw s3 16(sp)
	lw s1 12(sp)
	lw s1 8(sp)
	lw s0 4(sp)
	lw ra (sp)
	addi sp sp 24
	mv a0 zero
	ret