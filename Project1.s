.data
A: .word -89, 19, 91, -23, -31, -96, 3, 67, 17, 13, -43, -74
str: .asciiz "Average of positive array elements: "

.text
.globl main
main:

la $t0, A

                          #s0 - variable represents int sum
                          #s1 - variable represents int average
                          #s2 - variable represents int i
                          #t0 - variable represents array A

li $s3, 0                       #s3 index
addi $s0, $zero, 0              #setting int sum = 0
addi $s1, $zero, 0              #setting int average = 0
addi $s2, $zero, 0              #setting int i = 0



  li $s2,0                #int i is 0
for_Loop:
  
  slti $t1,$s2,12              #if s2<12,t1=1 else 0
  beq $t1,$0,for_Loop_done       #if t1=0,exit

  lw $t2, 0($t0)                #load array A offset 0 into t2
slti $t3, $t2, 0             #if t2<0,t3=1 else 0
beq $t3, $0, temp            #if t3=0,trunck to temp


  addi $s2,$s2,1          #i++
add $t0, $t0, 4           #next element in array A
  j  for_Loop             #loop continues

temp:
add $s0,$s0,$t2            #add t2 and sum
addi $s2,$s2,1             #i++
add $t0,$t0,4              #to next element in array A
j for_Loop                 #loop continues


for_Loop_done:               #loop exits
div $s1,$s0,6                #avg=sum/6

li $v0, 4       # system call code for printing string     
la $a0, str     # address of string to print      
syscall          # print str

li $v0, 1       # system call code for printing int      
move $a0, $s1       # move vaue in s1 to a0     
syscall          # print int s1

li $v0, 10
syscall          #exit program

      