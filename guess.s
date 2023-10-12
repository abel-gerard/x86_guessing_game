.section .data
MSG_CORRECT: .ascii "That's the correct number!\n" 
.equ LEN_CORRECT, . - MSG_CORRECT

MSG_LOWER: .ascii "Lower!\n" 
.equ LEN_LOWER, . - MSG_LOWER

MSG_HIGHER: .ascii "Higher!\n" 
.equ LEN_HIGHER, . - MSG_HIGHER

.equ READ, 3
.equ WRITE, 4

.equ STDIN, 0
.equ STDOUT, 1

.equ SYS_CALL, 0x80

.section .bss
.equ BUFFER_SIZE, 4 # not much size needed, just 4 bytes would suffice 
                    # (from "0" to "255" + '\n')
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

# INPUT: the secret number
#
# iteratively guess the number and get a feedback
# until win
#
# -4(%ebp) -> user integer input 
# -8(%ebp) -> winning flag ($1 = win) 
.globl guess
.type guess, @function
guess:
    pushl %ebp
    movl %esp, %ebp

    get_input:
        # clear input
        movl $0, -4(%ebp)

        movl $READ, %eax
        movl $STDIN, %ebx
        movl $BUFFER_DATA, %ecx
        movl $BUFFER_SIZE, %edx
        int $SYS_CALL
    
    # convert string into number
    atoi: 
        xorl %ecx, %ecx # current digit
        xorl %edx, %edx # current result
        movl $BUFFER_DATA, %ebx # pointer into %ebx
        
    atoi_next:
        cmpb $'\n', (%ebx)  # is the char '\n'?
        je atoi_end

        # update the current result
        imull $10, %edx     # %edx *= 10
        movzx (%ebx), %ecx  # putting in %ecx before hand to prevent overflow, with zero extension
        subl $'0', %ecx     # %ecx -= '0'
        cmpl $9, %ecx       # check if not in [0-9] -> input again
        ja get_input
        addl %ecx, %edx

        incl %ebx        # move the pointer
        jmp atoi_next

    atoi_end:
        movl %edx, -4(%ebp) # save int input as loc var
        movl 8(%ebp), %edx  # put random into %edx

    movl $WRITE, %eax
    movl $STDOUT, %ebx

    # case input == random
    cmpl %edx, -4(%ebp)
    je write_correct

    # case input < random
    movl $MSG_HIGHER, %ecx
    movl $LEN_HIGHER, %edx
    jl write_incorrect

    # case input > random
    movl $MSG_LOWER, %ecx
    movl $LEN_LOWER, %edx

    write_incorrect:
        int $SYS_CALL
        jmp get_input

    write_correct:
        movl $MSG_CORRECT, %ecx
        movl $LEN_CORRECT, %edx
        int $SYS_CALL

    movl %ebp, %esp
    popl %ebp
    ret
