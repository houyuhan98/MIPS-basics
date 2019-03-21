
.data
num_x:	.word 0	 #first number
num_k:	.word 0	 #second number
num_n:     .word 0  #third number
prompt1:    .asciiz "Enter the first integer x: "
prompt2:    .asciiz "Enter the second integer k: "
prompt3:    .asciiz "Enter the third integer n: "
str:    .asciiz "The result of x^k mod n = "

.text
.globl main
main:   
		                #output enter promt 
	li $v0, 4           # syscall 4 (print_str)
      la $a0, prompt1     # argument: string
      syscall             # print the string
		                #read x
	li $v0, 5            # syscall 5 (read_int)
      syscall
      sw $v0, num_x         #save x
		
		                 #output enter promt 
	li $v0, 4           # syscall 4 (print_str)
      la $a0, prompt2     # argument: string
      syscall             # print the string
		               #read k
	li $v0, 5            # syscall 5 (read_int)
      syscall
    sw $v0, num_k          #save k
		
		                #output enter promt 
		li $v0, 4       # syscall 4 (print_str)
        la $a0, prompt3     # argument: string
        syscall             # print the string
		                 #read n
		li $v0, 5        # syscall 5 (read_int)
        syscall
		sw $v0, num_n    #return value in $v0
					
		                  #output result
		li $v0, 4        # syscall 4 (print_str)
        la $a0, str    # argument: string
        syscall            # print the string
		
		                   #compute (x^k) mod n
		lw $a0, num_x
		lw $a1, num_k
		lw $a2, num_n
		jal fme
		move $a0, $v0
		
		                    #print result
		li $v0, 1          # syscall 1 (print_int)        
           syscall              # print the string
		                 #return
       	li $v0, 10     #syscall 10 exit 
		syscall
		
#   $a0 -  x
#   $a1 -  k
#   $a2 -  n
fme:
addiu $sp, $sp, -24   #allocate stack space -- default of 24 here
	sw $fp, 0($sp)      # save caller's frame pointer
	sw $ra, 4($sp)      # save return address
	addiu $fp, $sp, 20   # setup main frame pointer
	
	sw $a1,  0($fp)      # save k
	li $t0, 1
	sw $t0, -4($fp)         # result($fp-4) = 1
	
	blez $a1, fun_return      # if(k <= 0) fun_return
	li $t0, 2
	div $a1, $t0	 # k/2
	mflo $a1 		 # $a1 = k/2
	mfhi $t0 		 # $t0 = k%2
	beqz $t0, next1  # if(k%2 ==0 ) next1(no change result) 
	div $a0, $a2 	 #x/n
	mfhi $t0 		 # $t0 = x%n
	sw $t0, -4($fp)  #result = x%n
	next1:
	jal fme
	mult $v0, $v0	# $t1 = temp*temp
	mflo $t1
	lw $t0, -4($fp) # $t0 = result
	mult $t0, $t1   # $t0*$t1
	mflo $t0        # $t0 = result* temp*temp  
	div $t0, $a2      #result/n
	mfhi $t0	     #$t0 = result%n
	sw $t0, -4($fp)    #result = $t0 		
	fun_return:
	lw $v0, -4($fp)    #return result
	
	lw $ra, 4($sp)    # get return address from stack
	lw $fp, 0($sp)     # restore the caller's  frame pointer
	addiu $sp, $sp, 24  # restore the caller's stack pointer
	jr $ra
	