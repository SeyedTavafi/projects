#
#	Name:		Tavafi,	Seyed
#	Project:	4
#	Due:		12/02/2020
#	Course:		cs-2640-01-f20
#
#	Description:
#		     	An assembly QuadraticEquation program that prompts the user for coefficients a, b, and c of a quadratic equation and prints out the solutions.
#
			.data
introduction:		.asciiz "Quadratic Equation Solver by S. Tavafi\n\n"
promptForA:		.asciiz "Enter values for a? "
promptForB:		.asciiz	"Enter values for b? "
promptForC:		.asciiz "Enter values for c? "
notQuadratic:		.asciiz "Not a quadratic equation."
imaginary:		.asciiz	"Roots are imaginary."
root1:			.asciiz	"x1 = "
root2:			.asciiz	"x2 = "
oneRoot:		.asciiz	"x = "	
			.text
main:
			addiu	$sp, $sp, -24			#allocate space on stack because for reentrant subprogram we should save all locall variable on stack.
			la	$a0, introduction		#display introduction
			li	$v0, 4				#print str
			syscall
			
			la	$a0, promptForA			#Ask user to insert value for a
			li	$v0, 4				#print str
			syscall
			li	$v0, 6				#read float number from user for value of a
			syscall
			s.s	$f0,0($sp)			#store value of 'a' into the stack
			
			la	$a0, promptForB			#Ask user to insert value for b
			li	$v0, 4				#print str
			syscall
			li	$v0, 6				#read float number from user for value of b
			syscall
			s.s	$f0,4($sp)			#store value of 'b' into the stack
			
			
			la	$a0, promptForC			#Ask user to insert value for c
			li	$v0, 4				#print str
			syscall
			li	$v0, 6				#read float number from user for value of c
			syscall
			s.s	$f0,8($sp)			#store value of 'c' into the stack
			
			li	$a0,'\n'			#print new line
			li	$v0, 11
			syscall
			
			jal	solveqe				#call solveqe function
			
			lw	$v0, 20($sp)			#restore the return status from stack to the register $v0
			li	$t0,-1				# $t0=-1
			bne	$v0, $t0,checkNotQuadratic	# if $v0 is not -1, it will go to checkNotQuadratic
			la	$a0, imaginary
			li	$v0, 4
			syscall
			b 	end				#end function

checkNotQuadratic:
			bnez	$v0, checkOneRoot		#if return address is not zero go checkOneRoot
			la	$a0, notQuadratic		#Display notQuadratic
			li	$v0, 4				#print str
			syscall
			b	end				#branch to end

checkOneRoot:
			li	$t1, 1				#$t1=1
			bne	$v0, $t1, checkTwoRoots		#if return status is not 1, go to checkTwoRoots
			la	$a0, oneRoot			#display oneRoot
			li	$v0, 4				#print str
			syscall
			l.s	$f12, 12($sp)			#restore root value to register $f12
			li	$v0, 2
			syscall
			b	end				#branch to end

checkTwoRoots:
			la	$a0, root1			#display root1
			li	$v0, 4				#print str
			syscall
			
			l.s	$f12, 12($sp)			#restore root1 value to register $f12
			li	$v0, 2				#print float
			syscall
			
			li	$a0, '\n'			#print new line
			li	$v0, 11
			syscall
			
			la	$a0, root2			#display root2
			li	$v0, 4				#print str
			syscall
			
			l.s	$f12, 16($sp)			#restore root2 value to register $f12
			li	$v0, 2				#print float		
			syscall	
			b	end

#
# solveqe($f12,$f13,$f14)
#   solve for solutions
# parameters:
#   $f12: value of a entry
#   $f13: value of b entry
#   $f14: value of c entry
# return:
#   return status in $v0
solveqe:
			l.s	$f12, 0($sp)			#restore value of a from stack to register $f12.($f12=a)
			l.s	$f13, 4($sp)			#restore value of b from stack to register $f13.($f13=b)
			l.s	$f14, 8($sp)			#restore value of c from stack to register $f14.($f14=c)
			
			li.s	$f4,0.0				#load zero in register $f4,($f4=0)
			c.eq.s	$f12, $f4			#compare value of a with zero
			bc1f	discriminant			#if value of a is not equal to zero go to discriminant
			
			c.eq.s	$f13, $f4			#compare value of b with zero
			bc1f	findSingleRoot			#if the value of a is zero but value of b is not equal to zero go to findSingleRoot
			
			li	$v0, 0				#if a=0 and b=0, then return status is zero, we save return status in $v0 which is 0
			sw	$v0,20($sp)			#store the return status in stack
			jr	$ra				#end function

findSingleRoot:
			neg.s	$f14, $f14			#it changes the sign of the value of c to -c
			div.s	$f0, $f14, $f13			#it calucaltes x=-c/b and sace the value in register $f0
			li	$v0, 1				#when the equation has only one root it will return status 1.($v0=1)
			sw	$v0, 20($sp)			#store the return status in stack
			s.s	$f0, 12($sp)			#store return value(value of root) into the stack
			jr	$ra				#end function

discriminant:
			mul.s	$f4, $f13, $f13			#calucalte b*b save the value in register $f4
			li.s	$f5, 4.0			#assgined 4 to $f5($f5=4)
			mul.s	$f5, $f5, $f12			#calculates 4*a save value in register $f5
			mul.s	$f5, $f5, $f14			#calucaltes (4*a)*c and save the value in register $f5
			
			sub.s	$f4, $f4, $f5			#calculates b^2-(4*a*c)
			
			li.s	$f5,0.0				#$f5=0.0
			
			c.lt.s	$f4,$f5				#if discriminant is less than 0, condition is true
			bc1f	findTwoRoots			#if discriminant is bigger than  or equal to zero go to findTwoRoots
			li	$v0, -1
			sw	$v0, 20($sp)			#store the return status in stack
			jr	$ra				#end function

findTwoRoots:
			li.s	$f5, 2.0			#$f5=2.0
			mul.s	$f5, $f5, $f12			#calculates 2*a and save the result in register $f5
			mov.s	$f6, $f13			#move the value of b to register $f6
			
			neg.s	$f6, $f6			#change the sign of the value of b to -b
			
			sqrt.s	$f4, $f4 			#calucaltes the square root of discriminant
			
			add.s	$f0, $f6, $f4			#calucaltes -b+sqrt(b^2-4*a*c)
			div.s	$f0, $f0, $f5			#calucaltes first root of equation ((-b+sqrt(b^2-4*a*c)/2*a)) and save it in $f0
			
			sub.s	$f1, $f6, $f4			#calucaltes -b-sqrt(b^2-4*a*c)
			div.s	$f1, $f1, $f5			#calucaltes second root of equation ((-b-sqrt(b^2-4*a*c)/2*a)) and save it in $f1
			
			li	$v0, 2
			sw	$v0, 20($sp)			#store the return status in stack
			s.s	$f0, 12($sp)			#store the value of first root in stack
			s.s	$f1, 16($sp)			#store the valuse of the second root in stack
			jr	$ra				#end function
			
end:
			addiu	$sp, $sp, 24			#deallocate stack
			li	$v0, 10				#exit
			syscall