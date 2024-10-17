.data
array_a: .space 40
end_array_a:
array_b: .space 40
end_array_b:


option: .asciz "If you want to run tests enter 1, else if you want input from keyboard, enter 0: "

.global main

.text
main:
	li a7 4
	la a0 option
	ecall
	li a7 5
	ecall
	la a2 array_b
	beqz a0 keyboard_input
	jal tests_setup			# Pass register a2 (array_b), return nothing
	j tests_input
	keyboard_input:
	la a1 array_a
	jal keyboard			# Pass register a1 (array_a) and a2 (array_b), return nothing
	tests_input:
	li a7 10
	ecall