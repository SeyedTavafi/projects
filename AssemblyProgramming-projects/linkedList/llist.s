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
		li	$v0, 8			#read_string
		syscall
		
		lb	$t1, ($a0)		#loads first character to register $t1
		beq	$t1, '\n',end_d0	#if content of register $t1 is equal to new line go to end_d0 function

		jal	strdup			#jump and link to strdup function
		move	$a0, $v0		#move duplicated string in register $a0
		lw	$a1, llist		#load the string in register $a1

		jal	addnode			#jump and link to addnode function
		sw	$v0, llist		#save the address of the top node in the llist
		b	do			#branch to do

end_d0:
		la	$a0, newLine		#print new line
		li	$v0, 4
		syscall
		lw	$a0, llist		#restore head of the llist to register $a0
		la	$a1, print		#load the address of the print fucntion into register $a1
		jal	traverse		#jump and link to traverse function
		li	$v0, 10			#end main function
		syscall		

#
# print($a0)
#   print a string      
# parameters:
#   $a0: address of string that printed
# return:
#   it does not returning anything
print:
		li	$v0, 4			#print string
		syscall
		jr	$ra			#end function


#
# addnode($a0, $a1)
#   add the node(string) to the llist
# parameters:
#   $a0: address of current node
#   $a1: address of next node
# return:
#   $v0: addres of new node
addnode:
		move	$t0, $a0		#move content of register $a0 to reigtser $t0
		move	$t1, $a1 		#move content of register $a1 to register $t1
		li	$a0, 8			#assgining 8 bytes on the heap. 4 bytes for the data and 4 bytes for the address of next node.
		li	$v0, 9			#load address of the newly allocated space.
		syscall
		sw	$t0, ($v0)		#store the address of the string in the register $t0
		sw	$t1, 4($v0)		#store the address of the next node in the register $t1
		jr	$ra			#end addnode function

#
# traverse($a0, $a1)
#   traverses the list and calls proc passing the data of the node visit.
# parameters:
#   $a0: head of the llist
#   $a1: address of print function
# return:
#   it is not returning anything
traverse:
		addiu	$sp, $sp, -12		#allocate stack
		sw	$a0, ($sp)		#save the address of the node (string) in Mem[sp]
		sw	$a1, 4($sp)		#save the print function in Mem[sp+4]
		sw	$ra, 8($sp)		#save return address in Mem[sp+8]
		lw	$a0, 4($a0)		#address of next node
		beqz	$a0, else		#if the address of the next node is zero, go to else function
		jal	traverse		#jump and link to traverse

else:
		lw	$a0, ($sp)		#restore the address of the node from the Mem[sp]
		lw	$a0, ($a0)		#restore content of $a0 to register $a0
		lw	$a1, 4($sp)		#load the address of the function
		jalr	$a1			#load the PC with the address in $a1
		lw	$ra, 8($sp)		#load the return address
		addiu	$sp, $sp, 12		#deallocate the stack

		jr	$ra			#end function

#
# strdup($a0)
#   will return a pointer to a new string, which is a duplicate of the string pointed to by s.
# parameters:
#   $a0: address of the string that needs to be duplicate
# return:
#   $v0: address of the string duplicated
strdup:
		addiu	$sp, $sp, -8		#allocates space on stack
		sw	$ra, ($sp)		#save return address at Mem[sp]
		sw	$a0, 4($sp)		#save content of $a0 at Mem[sp+4]

		jal	strlen			#call strlen subprogram	
		move	$a0, $v0		#content of register $v0 to register $a0
		addi	$a0, $a0, 1		#adding 1 because we need one more space for '\0' character.

		jal 	malloc			#call malloc

		lw	$ra, ($sp) 		#restores $ra from stack
		lw	$a0, 4($sp)		#restores register $a0 from stack
		addiu	$sp, $sp, 8		#deallocate stack

		move	$t0, $a0		#move address of string to register $t0
		move	$t2, $v0		#move the content of register $v0 to register $t2

loop2:
		lb	$t3, ($t0)		#loads current character to register $t3
		sb	$t3, ($t2)		#saves current character to register $t2
		addi	$t0, $t0, 1		#go to next character
		addi	$t2, $t2, 1		#go to next chracter on register $t2
		bnez	$t3, loop2		#if register $t3 is not equal 0 branch to loop2
		jr	$ra			#end function

#
# malloc($a0)
#   allocate dynamic memory on the heap  
# parameters:
#   $a0: number of the bytes
#return:
#   $v0: address of the newly allocated space. 
malloc:					
		addi	$a0, $a0, 3
		andi	$a0, $a0, 0xfffc	#register $a0 needs to be multiple of 4 ((n + 3) & 0xffffffffc).
		li	$v0, 9
		syscall
		jr	$ra			#end function


#
# strlen($a0)
#   compute the length of a string
# parameters
#   $a0: points to the source of a string
# return:
#   $v0: the length of the string
strlen:
		li 	$t0, 0 			#count the number of character in string
		move 	$t1, $a0 		#move address of string into register $t1

loop1:
		lb 	$t2, ($t1) 		#loads current character into register $t2
		beqz 	$t2, endLoop1 		#if $t2 equal to 0 branch to endloop1
		addi 	$t1, $t1, 1 		#add 1 to register $t1 to go to next character
		addi 	$t0, $t0, 1		#increment counter by 1
		b 	loop1			#branch to loop

endLoop1:
		move	$v0, $t0 		#move number of characters to register $v0 
		jr 	$ra 			#end function
