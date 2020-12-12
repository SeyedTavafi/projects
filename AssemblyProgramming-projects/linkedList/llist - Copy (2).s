#
#	Name:		Tavafi,	Seyed
#	Project:	2
#	Due:		11/13/2020
#	Course:		cs-2640-01-f20
#
#	Description:
#		     	An assembly program that implements a link list to store input lines of text. The program will then print the link list constructed.
#

			.data
introduction:		.asciiz	"Link List by S. Tavafi\n\n"
enter:			.asciiz	"Enter text? "
llist: 			.word	0
inbuf: 			.space	82
newLine:		.asciiz	"\n"	
			.text
main:
		la	$a0, introduction	#display introduction
		li	$v0, 4
		syscall

do:
		la	$a0, enter		#prompt for string
		li	$v0, 4
		syscall
		
		la	$a0, inbuf		#load address of inbuf in register $a0
		li	$a1, 80			#maximum length of string that can be accepted from user
		li	$v0, 8			# read_string
		syscall
		
		lb	$t1, ($a0)		#loads first character to register $t1
		beq	$t1, '\n',end_d0	#if content of register $t1 is equal to new line go to done function
		
		jal	strdup			#jump and link to strdup function 
		move	$a0, $v0		#move duplicate string in register $a0
		lw	$a1, llist		#load the node in register $a1 

		jal	addnode			#jump to addnode function 
		sw	$v0, llist		#we save the address of our top most node back into llist
		b	do			#branch to do

end_d0:
		la	$a0, newLine		#print new line
		li	$v0, 4
		syscall
		lw	$a0, llist		#head of the list
		la	$a1, output		#load the address of the output fucntion
		jal	traverse
		li	$v0, 10			#end main function
		syscall		

output:
		li	$v0, 4			#print string
		syscall
		jr	$ra			#end function

addnode:
		move	$t0, $a0		#move content of register $a0 to reigtser $t0
		move	$t1, $a1 		#move content of register $a1 to $t1
		li	$a0, 8			#assgining 8 bytes on the heap. 4 bytes for the data and 4 bytes for the address of next node.
		li	$v0, 9			#call sbrk	
		syscall			
		sw	$t0, ($v0)		#store the address of the string in the register $t0
		sw	$t1, 4($v0)		#store the address of the next node in the register $t1
		jr	$ra			#end addnode function 

traverse:
		addiu	$sp, $sp, -12		#allocate stack
		sw	$a0, ($sp)		#save the address of our node (technically address of string) onto stack.
		sw	$a1, 4($sp)		#save the output function onto the stack as well
		sw	$ra, 8($sp)		#save return address in stacks
		lw	$a0, 4($a0)		#address of next node
		beqz	$a0, else		#if the address of the next node is zero, go to end function.
		jal	traverse		#jump and link to traverse	

else:	
		lw	$a0, ($sp)		#restore the address of the node from the stack 
		lw	$a0, ($a0)
		lw	$a1, 4($sp)		#load the address of the function
		jal	output			#jump and link to output function
		lw	$ra, 8($sp)		#load the return address
		addiu	$sp, $sp, 12		#deallocate the stack
	
		jr	$ra			#end function

strdup:
		addiu	$sp, $sp, -8		#allocates space on stack
		sw	$ra, ($sp)		#save return address at Mem[sp]
		sw	$a0, 4($sp)		#save content of $a0 at Mem[sp+4]

		jal	strlen			#call strlen subprogram 	
		move	$a0, $v0		#content of register $v0 to register $a0
		addi	$a0, $a0, 1		#adding 1 because we need one more space for '\0' character.

		jal 	malloc			#call malloc

		lw	$ra, ($sp) 		#restores $ra from strack
		lw	$a0, 4($sp)		#restores register $a0 from strack
		addiu	$sp, $sp, 8		#deallocate stack

		move	$t0, $a0		#move address of string to register $t0
		move	$t2, $v0		#move the content of register $v0 to register $t2

loop2:
		lb	$t3, ($t0)		#loads current character to register $t3
		sb	$t3, ($t2)		#saves current character to register $t2
		addi	$t0, $t0, 1		#go to next character
		addi	$t2, $t2, 1		#go to next chracter on register $t2
		bnez	$t3, loop2		#if register $t3 not equal 0 branch to loop2
		jr	$ra			#end function

malloc:						#allocate dynamic memory on the heap			
		addi	$a0, $a0, 3
		andi	$a0, $a0, 0xfffc	#register $a0 needs to be multiple of 4 ((n + 3) & 0xffffffffc).
		li	$v0, 9	
		syscall
		jr	$ra


strlen:						#find the length of the string
		li 	$s0, 0 			#count the number of character in string
		la 	$t1, ($a0) 		#loads address of string into register $t1

loop1:
		lb 	$t2, ($t1) 		#loads current character into register $t2
		beqz 	$t2, endLoop1 		#if $t2 equal to 0 branch to endloop1
		addi 	$t1, $t1, 1 		#add 1 to register $t1 to go to next character
		addi 	$s0, $s0, 1		#increment counter by 1
		b 	loop1			#branch to loop1

endLoop1:
		move	$v0, $s0 		#move number of characters to register $v0 
		jr 	$ra 			#end function
