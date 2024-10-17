.data 
	read_n: .asciz "Enter N amount of numbers in A(max 10): "
	
	n_more_than_10: .asciz "N is more than 10, enter again: "
	n_less_than_0: .asciz "N is less than 0, enter again: "
	
	enter: .asciz "Enter "
	number: .asciz " number: "
	
	comma: .asciz ", "
	bracket_open: .asciz " = {"
	bracket_close: .asciz "}\n"
	
	zero_case_text: .asciz "You entered N equals zero, there is no calculations"
	
	correct_answer_text: .asciz "Correct answer:    "

.macro zero_case ()			# Pass nothing, nothing return(just print)
	la a0 zero_case_text
	li a7 4
	ecall
.end_macro 


.macro input_n ()			# Pass nothing, return a0
	li t1 11
	la a0 read_n
	li a7 4
	ecall
	more_than_10:			# Check if n is grater than 10
	li a7 5
	ecall
	blt a0 t1 less_than_10
	li a7 4
	la a0 n_more_than_10
	ecall
	j more_than_10			# Check if n is less than 0
	less_than_10:
	bgez a0 more_than_0
	li a7 4
	la a0 n_less_than_0
	ecall
	j more_than_10
	more_than_0:
.end_macro 


.macro setup_array_a (%n %array_a_link) # Pass n, filled array, return nothing
	addi sp sp -12
	sw s0 8(sp)
	sw s1 4(sp)
	sw s2 (sp)
	mv s0 %n
	li s1 1
	mv s2 %array_a_link
create_array_a:
	li a7 4
	la a0 enter
	ecall
	li a7 1
	mv a0 s1
	ecall
	li a7 4
	la a0 number
	ecall
	li a7 5
	ecall
	sw a0 (s2)			# Save a0 in filled array
	addi s2 s2 4
	addi s1 s1 1
	ble s1 s0 create_array_a
done_array_a:
	lw s0 8(sp)
	lw s1 4(sp)
	lw s2 (sp)
	addi sp sp 12
.end_macro 


.macro setup_array_b (%array_b_link %array_a_link %n)	# Pass result array, original array, n, return nothing
	addi sp sp -4
	sw s0 (sp)
	mv t0 %array_b_link
	mv t5 %array_a_link
	mv s0 %n
create_array_b:
	li t1 1
	li t2 1
	li t3 1
	li t4 1
	lw a0 (t5)
	loop:						# Calculate factorial
		addi t3 t3 -1
		inner_loop:
			bltz t3 end_inner_loop
			add t1 t1 t2
			blt t1 t2 overflow
			addi t3 t3 -1
			j inner_loop
		end_inner_loop:
		bge t4 a0 without_overflow
		mv t2 t1
		addi t4 t4 1
		mv t3 t4
		j loop
	
		
overflow:
	beq a0 t4 without_overflow
	li t2 0
without_overflow:
	sw t2 (t0)					# Save a0 in result array
	addi t0 t0 4
	addi t5 t5 4
	addi s0 s0 -1
	bgtz s0 create_array_b
done_array_b:
	lw s0 (sp)
	addi sp sp 4
.end_macro


.macro print_arr_setup (%array_link %n %label)	# pass n, printed array, array label, return nothing
	addi sp sp -8
	sw s0 4(sp)
	sw s1 (sp)
	mv s1 %array_link
	mv s0 %n
	mv a0 %label
	li a7 4
	ecall
	la a0 bracket_open
	li a7 4
	ecall
print_arr:
	li a7 1
	lw a0 (s1)
	ecall
	addi s1 s1 4
	addi s0 s0 -1
	blez s0 done_print
	li a7 4
	la a0 comma
	ecall
	j print_arr
done_print:
	la a0 bracket_close
	li a7 4
	ecall
	lw s0 4(sp)
	lw s1 (sp)
	addi sp sp 8
	mv a0 zero
.end_macro 


.macro correct_answer_print (%answer_link) # Pass array with correct answers(prints only one string), return new link to correct answers
	li a7 4
	la a0 correct_answer_text
	ecall
	mv a1 %answer_link
	print_string:
    		lb a0, (a1)
    		beqz a0, end_print
    		li a7, 11
    		ecall
    		addi a1, a1, 1
    		j print_string
	end_print:
	addi a1, a1, 1
	li a7 11
	li a0 '\n'
	ecall
	mv %answer_link a1		# Save new link in a1
.end_macro 