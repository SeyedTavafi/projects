#
#	Name:		Tavafi,	Seyed
#	Project:	3
#	Due:		11/25/2020
#	Course:		cs-2640-01-f20
#
#	Description:
#		     	An assembly program that constructs and outputs an adjacency matrix for a digraph. The graph will be constructed as a word matrix.
#
			.data
introduction: 	.asciiz "Digraph by S. Tavafi \n\n"
promptVertex:	.asciiz "Enter number of vertices? "
promptEdge:	.asciiz "Enter edge? "
edgeError: 	.asciiz "Invalid edge\n"
inbuf:		.space 0
			.text
main:
			la	$a0, introduction		#display introduction
			li 	$v0, 4 				#print str
			syscall
			la 	$a0, promptVertex 		#display promptVertex
			li 	$v0, 4 				#print str
			syscall

			li 	$v0, 5 				#read integer from user
			syscall

			move 	$s0, $v0 			#register $s0 has matrix of length n

			mul 	$v1, $v0, $v0 			#multiply register $v0 to itself will gives you matrix nxn
			sll 	$v1, $v1, 2 			#it will gives us exact number of bytes we need to allocate on stack

			sub 	$sp, $sp, $v1 			#allocating stack with number of bytes we calucalted
			move 	$s1, $sp 			#move address of matrix in register $s1

			move 	$a0, $s1 			#move the address of matrix to register $a0
			move 	$a1, $v0 			#move number of elements the matrix has to register $a1

			jal 	matrix 				#jump and  link to matrix function

while:
			la 	$a0, promptEdge 		#display promptEdge
			li 	$v0, 4 				#print str
			syscall

			li 	$t2, 'A' 			#assgined 'A' to register $t2

			la 	$a0, inbuf 			#load address of inbuff to register $a0
			li 	$a1, 4 				#assgined 4 to register $a1.size of input can be used by user
			li 	$v0, 8 				#read string from user
			syscall

			lb 	$t0, ($a0) 			#load first character in register $t0
			addiu 	$a0, $a0, 1 			#go to next character of string
			lb 	$t1, ($a0) 			#load the next character in register $t1

			bne 	$t0, 'X', addE 			#if the character is not 'X' branch to addE
			beq 	$t1, '\n', end 			#if second character is new line branch to end
			sub 	$t3, $t0, $t2 			#subtract 65 from $t0, and store result in register $t3
			bge 	$t3, $s0, error 		#if character exceeds n branch to error
addE:
			beq 	$t1, '\n', error 		#if second character is newline branch to error

			sub 	$t0, $t0, $t2 			#subtract 65 from register $t0 and store result in register $t0
			bge 	$t0, $s0, error 		#if character exceeds n branch to error

			sub 	$t1, $t1, $t2			#subtract 65 from register $t1 and store result in register $t1
			bge 	$t1, $s0, error 		#if character exceeds n branch to error

			move 	$a0, $s1 			#move address of matrix in register $a0
			move 	$a1, $s0 			#move n in to register $a1
			move 	$a2, $t0 			#move first vertex in register $a2
			move 	$a3, $t1 			#move second vertex in register $a3

			jal 	addedge 			#jump and link to addedge

			b 	while 				#branch to while
error:
			la 	$a0, edgeError 			#display edgeError
			li 	$v0, 4 				#print str
			syscall

			b 	while 				#branch to while
end:
			li	$a0, '\n'			#print new line
			li	$v0, 11				#print char
			syscall
			move 	$a0, $s1 			#move the address of matrix to register $a0
			move 	$a1, $s0 			#move the length of matrix to register $a1 which is our number of columns of matrix
			move 	$a2, $s0 			#move the length of matrix to register $a2 which is our number of rows of matrix

			jal 	print 				#jump and link to print function

			move 	$t0, $s0 			#move the length of matrix to register $t0
			mul 	$t0, $t0, $t0 			#squares n and stores in $t0
			add 	$sp, $sp, $t0 			#deallocate the stack

			li 	$v0, 10 			#exit
			syscall

#
# matrix($a0,$a1)
#   creats a matrix filled with zeroes
# parameters:
#   $a0: address of matrix 
#   $a1: size of matrix nxn
# return:
#   it does not returning anything
matrix:
			move 	$t0, $a0 			#move the address of matrix to register $t0
			move 	$t1, $a1 			#move the size of matrix to register $t1
			mul 	$t1, $t1, $t1 			#it will calucalte number of elements the matrix has
do:
			sw 	$zero, ($t0) 			#save zero in the matrix
			addiu 	$t0, $t0, 4 			#go to the next element of matrix
			addi 	$t1, $t1, -1 			#register $t1 is our counter which is number of elements and it will decreament it by one
			beqz 	$t1, endDo 			#if we arrive to last element it will jump to endDo function
			b 	do 				#branch to do
endDo:
			jr 	$ra 				#end function

#
# addedge($a0,$a1,$a2,$a3)
#    add an edge to the matrix, input will be row and col as indices
# parameters:
#   $a0: address of matrix
#   $a1: number of column of matrix
#   $a2: from the vertex
#   $a3: to the ending vertex
# return:
#   it does not returning anything
addedge:
			addiu 	$sp, $sp, -4 			#allocate space on stack
			sw 	$ra, ($sp) 			#save return address in $sp

			jal 	getae 				#jump and link to getae

			li 	$t0, 1 				#assgined 1 to register $t0
			sw 	$t0, ($v0) 			#store one to the effective address we find from getae register $v0

			lw 	$ra, ($sp) 			#restore return address from stack
			addiu 	$sp, $sp, 4 			#deallocate stack

			jr 	$ra 				#end function


#
# getae($a0,$a1,$a2,$a3)
#   compute the effective address of mat[row][col]
# parameters:
#   $a0: address of matrix
#   $a1: number of column of matrix
#   $a2: row index
#   $a3: column index
# return:
#   returns effective address of the edge
getae:
			move 	$t0, $a0 			#move the address of matrix to register $t0
			move 	$t1, $a1 			#move the number of column of matrix to register $t1
			move 	$t2, $a2 			#move the row index to the register $t2
			move 	$t3, $a3 			#move the column index to the register $t3

			mul 	$t4, $t2, $t1 			#save row*number of columns to the register $t4
			add 	$t4, $t4, $t3 			#adds number of column to register $t4 and stores in register $t4
			sll 	$t4, $t4, 2 			#shift register $t4 to the left by 2
			add 	$v0, $t0, $t4 			#add register $t0 to register $t4 to find effective address and save it to register $v0
			jr 	$ra 				#end function

#
# print($a0,$a1,$a2)
#   print the matrix
# parameters:
#   $a0: address of matrix
#   $a1: number of row of matrix
#   $a2: number of column of matrix
# return:
#   it does not returning anything
print:
			move	$t0, $a0 			#move the addres of matrix to register $t0
			move	$t1, $a1 			#move the number of the row of matrix to register $t1
			move	$t2, $a2 			#move the number of the column of matrix to register $t2
			mul	$t3, $t1, $t2 			#it gives us the total elements of matrix, and save it in register $t3
			li	$t4, 0 				#assgined zero to register $t4, $t4 is counter of number of columns

			li	$t5, 'A' 			#assgined 'A' to register $t5
			li	$t6, 'A' 			#assgined 'A' to register $t6
			add	$t6, $t6, $a2 			#add register $t6 to register $a2 and save it in register $t6

			li	$a0, '*' 			#print '*'
			li	$v0, 11 			#print char
			syscall

			li	$a0, ' ' 			#print space
			li	$v0, 11 			#print char
			syscall
loop:
			move	$a0, $t5 			#print the each vertex
			li	$v0, 11 			#print char
			syscall

			li	$a0, ' ' 			#print space
			li	$v0, 11 			#print char
			syscall

			addi	$t5, $t5, 1 			#add 1 to register $t5 to go to next character
			beq	$t5, $t6, else 			#if content of register $t5 is equal to content of register $t6, go to the else

			b	loop 				#branch to loop
else:
			li	$a0, '\n' 			#print newline
			li	$v0, 11 			#print char
			syscall

			li	$t5, 'A' 			#assgined 'A' to register $t5

			move	$a0, $t5 			#print character
			li	$v0, 11				#print char
			syscall

			li	$a0, ' ' 			#print space
			li	$v0, 11 			#print char
			syscall
for:
			lw	$a0, ($t0) 			#load the element of matrix to register $a0
			li	$v0, 1 				#print int
			syscall

			li	$a0, ' ' 			#print space
			li	$v0, 11 			#print char
			syscall
			addiu	$t0, $t0, 4 			#go to next element
			addi	$t4, $t4, 1 			#increament the column by 1
			beq	$t4, $t2, newline 		#if the column counter reach to last column go to the line

			addi	$t3, $t3, -1 			#decrement the counter by 1

			b	for				#branch to for
newline:
			li	$a0,'\n' 			#print newline
			li	$v0, 11 			#print char
			syscall

			addi	$t3, $t3, -1 			#decrement the counter by 1
			li	$t4, 0		 		#reset column counter

			beqz	$t3, end1 			#if number of elements is equal to zero go to the end1

			addi	$t5, $t5,1 			#add one to register $t5 to go the next vertex

			move	$a0, $t5 			#print character
			li	$v0, 11 			#print char
			syscall

			li	$a0, ' ' 			#print space
			li	$v0, 11 			#print char
			syscall

			b	for	  			#branch to for
end1:
			jr 	$ra 				#end function