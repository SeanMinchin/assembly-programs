.data
	new_line:			.asciz "\n"
	input_message:		.asciz "Input a string: "
	input_buffer:		.space 256
	string_specifier:	.asciz "%[^\n]"

.global main

.text

main:
	# print input message
	ldr x0, =input_message
	bl printf

	# scan string input
	ldr x0, =string_specifier
	ldr x1, =input_buffer
	bl scanf

	# load string buffer into x0 for subroutine to get length
	ldr x0, =input_buffer
	# strength length will be in x19
	bl get_string_length

	# load string buffer into x0
	ldr x0, =input_buffer
	bl get_vowels

	# print string after loop
	ldr x0, =input_buffer
	bl printf

	# flush buffer
	ldr x0, =new_line
	bl printf

exit:
	mov x0, #93
	mov x8, #93
	svc #0

get_string_length:
	# put string size counter in x1
	# initialize at 0
	mov x1, #0

	string_length_loop:
		# x0 is the address of the string's start
		ldrb w2, [x0, x1]

		# if current character is null, exit
		cbz w2, string_length_exit

		# else increment counter
		add x1, x1, #1
		# return to the start of this subroutine
		b string_length_loop

	string_length_exit:
		# put string length into x19
		mov x19, x1

		br x30

get_vowels:
	# put string counter in x1
	# initialized at 0
	mov x1, #0

	vowel_loop:
		# if strength length is down to 0, end the loop
		cbz x19, vowel_loop_exit
		# decrement the streng length
		sub x19, x19, #1

		# load x1 index of x0 into x2
		ldrb w2, [x0, x1]

		# compare to 'A'
		sub x3, x2, #65
		cbz x3, is_vowel

		# compare to 'E'
		sub x3, x2, #69
		cbz x3, is_vowel

		# compare to 'I'
		sub x3, x2, #73
		cbz x3, is_vowel

		# compare to 'O'
		sub x3, x2, #79
		cbz x3, is_vowel

		# compare to 'U'
		sub x3, x2, #85
		cbz x3, is_vowel

		# compare to 'a'
		sub x3, x2, #97
		cbz x3, is_vowel

		# compare to 'e'
		sub x3, x2, #101
		cbz x3, is_vowel

		# compare to 'i'
		sub x3, x2, #105
		cbz x3, is_vowel

		# compare to 'o'
		sub x3, x2, #111
		cbz x3, is_vowel

		# compare to 'u'
		sub x3, x2, #117
		cbz x3, is_vowel

		# increment counter
		add x1, x1, #1

		# return to loop start if character is not a vowel
		b vowel_loop
	
		is_vowel:
			# put 'x' into x4
			mov x4, #120
			# store 'x' into x1 index of buffer
			strb w4, [x0, x1]

			# increment counter
			add x1, x1, #1

			# return to loop start
			b vowel_loop

		vowel_loop_exit:
			br x30
