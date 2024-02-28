/*
 * main.S
 *
 *  Created on: Feb 18, 2022
 *      Author: User
 */
 .include "../src/GPIO.S"
 .include "../src/calculator.S"

 .global main

 .data

 .text

 main:

 	@ This example assumes the top pins of PMODB should be inputs
 	@ unsigned int inout == r1, unsigned int row == r2
	MOV r1, #1   	@ r1 == inout = 0
	MOV r2, #0  	@ r2 == row = 0
	BL setupPMODB	@ setupPMODB(0, 0);

	@ This example assumes the bottom pins of PMODB should be outputs
 	@ unsigned int inout == r1, unsigned int row == r2
	MOV r1, #0		@ r1 == inout = 1
	MOV r2, #1		@ r2 == row = 1
	BL setupPMODB 	@ setupPMODB(1, 1);

	# initializing some variables
	MOV r10, #0
	MOV r11, #0

 	whileOne:

		# setting up seven segment display
		BL setupSVNSEG

		# This displays the first digit pressed and moves it to correct register for calculator
		BL display_keypad
		MOV r2, r0

		# this display the second digit pressed and stores it correctly
		BL display_keypad
		MOV r3, r0

		# Gets switches states for the calculator
		BL get_switches
		MOV r1, r0

		MOV r4, #0

		# wait for a button press and release to get the solution from calculator
		while5:
		BL get_buttons
		CMP r0, r4
		BEQ while5

		while6:
		BL get_buttons
		CMP r0, #0
		BNE while6

		# branch to calculator and output to solution and move the solution to stored
		# this is done in the calculator.S file
		BL calculator
		MOV r11, r10


 	B whileOne

 .end
