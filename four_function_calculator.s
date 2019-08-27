.data
		input_message:	.asciz "Enter two decimal integers then [+,-,*,/]:\n"
		first_num_buffer:	.space 4
		second_num_buffer:	.space 4
		op_buffer:	.space 1
		input_specifier:	.asciz "%d %d %c"
		new_line:	.asciz "\n"
		dbz_message:	.asciz "Error: cannot divide by zero\n"
		invalid_op_message: .asciz "Error: invalid operator\n"
		result_num:	.asciz "%d\n"

.global main

.text

main:
		# Print input message
		ldr x0, =input_message
		bl printf

		# Load each input component into three different registers
		# A in x1, B in x2, operator in x3
		ldr x0, =input_specifier
		# First number
		ldr x1, =first_num_buffer
		# Second number
		ldr x2, =second_num_buffer
		# Operation
		ldr x3, =op_buffer
		bl scanf

		bl op_check

		# Load decimal format and result, then print
		ldr x0, =result_num
		mov w1, w19
		bl printf

exit:
		mov x0, #0
		mov x8, #93
		svc #0

op_check:
		mov x26, x29
		mov x27, x30

		ldr x20, =first_num_buffer
		ldur x20, [x20]
		ldr x21, =second_num_buffer
		ldur x21, [x21]

		ldr x3, =op_buffer
		ldrb w3, [x3, xzr]

		add_check:
					# check for addition
					sub x4, x3, #43
					cbnz x4, sub_check
					bl ADD
					b exit_op_check

		sub_check:
					# check for subtraction
					sub x4, x3, #45
					cbnz x4, mult_check
					bl SUB
					b exit_op_check

		mult_check:
					# check for multiplication
					sub x4, x3, #42
					cbnz x4, div_check
					bl MUL
					b exit_op_check

		div_check:
					# check for division
					sub x4, x3, #47
					cbnz x4, invalid_op_path
					bl DIV
					b exit_op_check

		invalid_op_path:
						# error if operation is none of the above
						b op_error

		exit_op_check:
						# operator is determined, return to main
						mov x29, x26
						mov x30, x27
						br x30

dbz_error:
			ldr x0, =dbz_message
			bl printf
			b exit

op_error:
			ldr x0, =invalid_op_message
			bl printf
			b exit

ADD:
		add w19, w20, w21
		br x30

SUB:
		sub w19, w20, w21
		br x30


MUL:
		mul w19, w20, w21
		br x30

DIV:
		# check if input B is 0
		cbz w21, dbz_error
		sdiv w19, w20, w21
		br x30
