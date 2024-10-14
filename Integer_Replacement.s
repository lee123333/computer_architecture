    .data
input_num1: 
    .word 0x00fff000  # First input
input_num2: 
    .word 0x00000002  # Second input
input_num3: 
    .word 0x7f000800  # Third input
answer:
    .word 0x19,0x1,0x21

newline:
    .asciz "\n"       # Newline character for printing
str1:     
    .string " answer is "  # First part of the output message
str2:     
    .string " .Actual answer is "                 # Second part of the output message
str3:     
    .string "Input number is " 
.text
    .globl _start

_start:
    # Handle first input
    add t6,x0,x0
    la t0, input_num1  # Load address of first input
    lw t1, 0(t0)       # Load the first input into t1
    mv a2,t1
    jal call_process       # Call the process loop
    jal call_print         # Print the result
    addi t6,x0,4
    # Handle second input
    la t0, input_num2  # Load address of second input
    lw t1, 0(t0)  
    mv a2,t1     # Load the second input into t1
    jal call_process       # Call the process loop
    jal call_print         # Print the result
    addi t6,t6,4
    # Handle third input
    la t0, input_num3  # Load address of third input
    lw t1, 0(t0)       # Load the third input into t1
    mv a2,t1
    jal call_process       # Call the process loop
    jal call_print         # Print the result

    li a7, 10          # Syscall for exit
    ecall

# Process loop
call_process:
    addi a1, x0, 1     # Initialize a1 to 1
    addi a6, x0, 31    # Initialize a6 to 31
    add t5, x0, x0     # Initialize result t5 to 0

while_loop:
    li a5,0  #count number of ctz or cto
    li a4,0  #judge cto or ctz
    add t2,x0,t1
    beq t1,a1,exit 
    andi t3,t1,1 
    bnez t3,cto_loop
    j ctz_loop
cto_loop:   
    not t2, t1 
    addi a4,x0,1
ctz_loop:
    slli t0,t2,1
    or t2,t0,t2
    slli t0,t2,2
    or t2,t0,t2
    slli t0,t2,4
    or t2,t0,t2
    slli t0,t2,8
    or t2,t0,t2
    slli t0,t2,16
    or t2,t0,t2
    
    srli t0,t2,1
    li t3,0x55555555
    and t0,t0,t3
    sub t2,t2,t0
    
    srli t0,t2,2
    li t3,0x33333333
    and t0,t0,t3
    and t2,t2,t3
    add t2,t0,t2
    
    srli t0,t2,4
    add t2,t2,t0
    li t3,0x0f0f0f0f
    and t2,t2,t3
    
    srli t3,t2,8
    add t2,t2,t3
    
    srli t3,t2,16
    add t2,t2,t3
    
    andi t2,t2,0x3f
    addi t0,x0,32
    sub a5,t0,t2
    bnez a4,if_case
else_case:
    srl t1,t1,a5
    add t5,t5,a5
    j while_loop    
        
if_case:
    blt a1,a5,if_case2

else_if_case:
    beq a5,a6,exit_special    
else_case2:
    addi t1,t1,-1
    srli t1,t1,1
    addi t5,t5,2
    j while_loop
    
if_case2:
    addi t4,x0,3
    blt t4,t1,count_mul_1
    j else_if_case

count_mul_1:
    addi t1,t1 1
    srl t1,t1,a5
    add t5,t5,a5
    addi t5,t5,1
    j while_loop                
exit_special:
    addi a5,x0,33
    ret        # a7 = 10, syscall for exit
exit:
    add a5,x0,t5             # Return from call_process
    ret
# Print function
call_print:
    la a0,str3
    li a7,4
    ecall
    mv a0, a2          # Move result to a0 for printing
    li a7, 1           # Syscall for print integer
    ecall
    
    la a0,str1
    li a7,4
    ecall
    mv a0, a5          # Move result to a0 for printing
    li a7, 1           # Syscall for print integer
    ecall
    
    la a0,str2
    li a7,4
    ecall
    la t0,answer
    add t0,t0,t6
    lw a0,0(t0)
    li a7,1
    ecall

    la a0, newline     # Load address of newline character
    li a7, 4           # Syscall for print string
    ecall

    ret  
 
