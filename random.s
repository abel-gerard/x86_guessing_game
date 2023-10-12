.section .data

.equ GET_RAND, 355

.equ GET_RAND_FLAGS, 0

.equ SYS_CALL, 0x80

.section .bss
.equ RAND_SIZE, 1
.lcomm RAND, RAND_SIZE

.section .text

# Output between 0 and 255
.globl random
.type random, @function
random:
    pushl %ebp
    movl %esp, %ebp

    movl $GET_RAND, %eax
    movl $RAND, %ebx
    movl $RAND_SIZE, %ecx
    movl $GET_RAND_FLAGS, %edx
    int $SYS_CALL

    movl RAND, %eax

    movl %ebp, %esp
    popl %ebp
    ret
