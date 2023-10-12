# With the help of the responses at:
# https://codereview.stackexchange.com/questions/286406/number-guessing-game-for-x86/

.section .data

.equ SUCCESS, 0

.equ EXIT, 1

.equ SYS_CALL, 0x80

.section .text

.globl _start
_start:
    call random
    
    pushl %eax  # Save random on the stack as arg
    call guess
    addl $4, %esp
    
    movl $SUCCESS, %ebx
    movl $EXIT, %eax
    int $SYS_CALL
