.data
	new_line:			.asciz "\n"
	input_prompt:		.asciz "Enter two integers: "
	m_buffer:			.space 4
	n_buffer:			.space 4
	input_specifier:	.asciz "%d %d"
	output_specifier:	.asciz "%d"

.global main

.text

main:
	# print input message
	ldr x0, =input_prompt
	bl printf

	# load inputs
	ldr x0, =input_specifier
	# load m
	ldr x1, =m_buffer
	# load n
	ldr x2, =n_buffer
	bl scanf

	# load m into x19
	ldr x19, =m_buffer
	ldur x19, [x19]
	# load n into x20
	ldr x20, =n_buffer
	ldur x20, [x20]

	# if m is zero, gcd(m,n) = n
	cbz w19, return_n
	# if n is zero, gcd(n,m) = m
	cbz w20, return_m

	# check if m is negative
	cmp w19, #0
	bmi abs_m

n_negative_check:
	# check if n is negative
	cmp w20, #0
	bmi abs_n

compare_magnitudes:
	# if m < n, swap m and n
	subs w1, w19, w20
	blt swap

run_algorithm:
	# run gcd algorithm
	bl gcd

	# print result calculated by gcd function
	bl printf

	# flush buffer
	ldr x0, =new_line
	bl printf

exit:
	mov x0, #93
	mov x8, #93
	svc #0

abs_m:
	# m = -m
	neg w19, w19

	b n_negative_check

abs_n:
	# n = -n
	neg w20, w20

	b compare_magnitudes

gcd:
	# allocate space for return address
	sub sp, sp, #16
	str x30, [sp, #0]

	# if m modulo n is 0, gcd(m,n) = n
	bl m_mod_n
	cbnz w21, recurse

	# if above branch condition not met, then base case condition met
	base:
		# move current value of n to print
		ldr x0, =output_specifier
		mov w1, w20

		# load previously stored return address
		ldr x30, [sp, #0]

		# return back up the call chain
		br x30

	# else gcd(m,n) = gcd(n,m % n)
	recurse:
		# allocate space for return address
		sub sp, sp, #16
		str x30, [sp, #0]

		# before recursive call, move n into m and m mod n into n
		bl m_mod_n
		mov w19, w20
		mov w20, w21

		# recursively call function
		bl gcd

		# load previously stored return address
		ldr x30, [sp, #0]
		add sp, sp, #16

		# go up the call chain
		br x30

m_mod_n:
	sdiv w21, w19, w20
	mul w21, w21, w20
	sub w21, w19, w21
	br x30

swap:
	mov w2, w19
	mov w19, w20
	mov w20, w2

	b run_algorithm

return_m:
	# print m if n is 0
	ldr x0, =output_specifier
	mov w1, w19
	bl printf

	# flush buffer
	ldr x0, =new_line
	bl printf

	b exit

return_n:
	# print n if m is 0
	ldr x0, =output_specifier
	mov w1, w20
	bl printf

	# flush buffer
	ldr x0, =new_line
	bl printf

	b exit
