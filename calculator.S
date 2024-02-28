.ifndef CALCULATOR_S_
.set CALCULATOR_S_, 1

 .include "../src/GPIO.S"

.data
# jump table for all our operations
operations: .word addition, subtract, revsubtract, multiplication, multiply_accumulate, test_equivalence, shift_left_by_n, shift_right_by_n, bitwise_and, bitwise_or, bitwise_xor, bitwise_clear, not, count_leading_0s, store_solution, load_solution


.text

# unsigned int perform_calculation(unsigned int operand1, unsigned int operand2);
# outputs: result == r0
# inputs: operation == r1
#		  operand1 == r2
#         operand2 == r3
#         stored   == r11

# Basically this is my calculator switch statements and overall operation
# Which takes the input from switches and puts it into operation
# then takes the operand 1 and 2 from display_keypad function, then using
# the jump table and the switches input it finds the correct operation. Then
# outputs that to the seven segment display

calculator:

	PUSH {r1, LR}
	#check to see if we have a valid operation
	# check if operation is < 16
	CMP r1, #16
	BGE default_case

	# handle to the beginning of my jump table
	LDR r0, =operations

	# r4 = memory at address of r0 + r4*r1
	LDR r4, [r0, r1, LSL #2]

	# B r4
	BX r4

	# All my switch cases below for each type

	addition:
		ADD r0, r2, r3
		B endCase

	subtract:
		SUB r0, r2, r3
		B endCase

	revsubtract:
		RSB r0, r2, r3
		B endCase

	multiplication:
		MUL r0, r2, r3
		B endCase

	multiply_accumulate:
		MLA r0, r2, r3, r11
		B endCase

	test_equivalence:
		CMP r2, r3
		MOVEQ r0, #1
		MOVNE r0, #0
		B endCase

	shift_left_by_n:
		MOV r0, r2, LSL r3
		B endCase

	shift_right_by_n:
		MOV r0, r2, LSR r3
		B endCase

	bitwise_and:
		AND r0, r2, r3
		B endCase

	bitwise_or:
		ORR r0, r2, r3
		B endCase

	bitwise_xor:
		EOR r0, r2, r3
		B endCase

	bitwise_clear:
		BIC r0, r2, r3
		B endCase

	not:
		MVN r0, r2
		B endCase

	count_leading_0s:
		CLZ r0, r2
		B endCase

	store_solution:
		MOV r11, r10

	load_solution:
		MOV r0, r11

	# edge case
	default_case:
		MOV r0, #0


	# then I push it to write seven seg
	endCase:
	MOV r1, r0
	MOV r10, r0
	BL writeSVNSEG
	POP {r1, LR}
	BX LR

.endif
