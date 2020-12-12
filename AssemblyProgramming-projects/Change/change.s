#
#	Name:		Tavafi,	Seyed
#	Project:	1
#	Due:		10/07/2020
#	Course:		cs-2640-01-f20
#
#	Description:
#		     	An assembly program that tells what coins to give out for any amount of change from 1 cent to 99 cents.
#
			.data
introduction:		.asciiz "Change by S. Tavafi\n"
newline:		.asciiz "\n"
enter:			.asciiz	"Enter the change? "
displayQuarter:		.asciiz	"Quarter: "
displayDime:		.asciiz	"Dime: "
displayNickel:		.asciiz	"Nickel: "
displayPenny:		.asciiz	"Penny: "
			.text
main:
			la		$a0, introduction		#display introduction
			li		$v0, 4				#prompt str
			syscall
			la		$a0, newline			#output newline
			li		$v0, 4				#print char
			syscall

			la		$a0, enter			#prompt for change
			li		$v0, 4				#print str
			syscall

			li		$v0, 5				#read integer from user
			syscall
			move 		$t0, $v0
			la		$a0, newline			#output newline
			li		$v0, 4				#print char
			syscall
			li		$t1, 25				#store 25 to register t1
			li		$t2, 10				#store 10 to register t2
			li		$t3, 5				#store 5 to register t3
			li		$t4, 1				#store 1 to register t4
			li		$t5, 0				#store 0 to register t5

			div		$t0, $t1			#divide change by 25
			mflo		$s0				#quotient of division
			mfhi		$s1				#remainder of division
			jal		checkQuarter			#call checkQuarter function

			div		$s1, $t2			#divide remainder change by 10
			mflo		$s2				#quotient of division
			mfhi		$s3				#remainder of division
			jal		checkDime			#call checkDime function

			div		$s3, $t3			#divide remainder change by 5
			mflo		$s4				#quotient of division
			mfhi		$s5				#remainder of division
			jal		checkNickel

			div		$s5, $t4			#divide remainder change by 1
			mflo		$s6				#quotient of division
			mfhi		$s7				#remainder of division
			jal		checkPenny

end:
			li		$v0, 10				#exit
			syscall

checkQuarter:
			bgt		$s0, $t5, quarter		#check if register s0 is bigger than register t5
			jr		$ra				#end function

quarter:
			la		$a0, displayQuarter		#display quarter prompt
			li		$v0, 4				#print str
			syscall
			move		$a0, $s0
			li		$v0, 1				#print number of quarter
			syscall
			la		$a0, newline			#output newline
			li		$v0, 4				#print char
			syscall
			jr		$ra				#end function

checkDime:								#check if register s2 is bigger than register t5
			bgt		$s2, $t5, dime
			jr		$ra				#end function

dime:
			la		$a0, displayDime		#display dime prompt
			li		$v0, 4				#print str
			syscall
			move		$a0, $s2
			li		$v0, 1				#print number of dime
			syscall
			la		$a0, newline			#output newline
			li		$v0, 4				#print char
			syscall
			jr 		$ra				#end function

checkNickel:								#check if register s4 is bigger than register t5
			bgt		$s4, $t5, nickel
			jr		$ra 				#end function


nickel:			la		$a0, displayNickel		#display nickel prompt
			li		$v0, 4				#print str
			syscall
			move		$a0, $s4
			li		$v0, 1				#print number of nickel
			syscall
			la		$a0, newline			#output newline
			li		$v0, 4				#print char
			syscall
			jr 		$ra				#end function

checkPenny:								#check if register s6 is bigger than register t5
			bgt		$s6, $t5, penny
			jr		$ra				#end function

penny:			la		$a0, displayPenny		#display penny prompt
			li		$v0, 4				#print str
			syscall
			move		$a0, $s6
			li		$v0, 1				#print number of penny
			syscall
			la		$a0, newline			#output newline
			li		$v0, 4				#print char
			syscall
			jr		$ra				#end function

