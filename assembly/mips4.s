# mips4.s
# Prompt for integer from user
# print whether even or odd

.data

prompt:     .ascii  "Enter an integer: "
msg_even:   .ascii  "Your number is even"
msg_odd:    .ascii  "Your number is odd"

.text

main:
        li   $v0,4                     # place print string code in $v0
        la   $a0,prompt                # address of prompt
        syscall                        # call the operating system

        li   $v0,5                     # place read integer code in $v0
        syscall                        # read the integer
        move $t0,$v0                   # move the integer to a temporary register

        li   $t1,2                     # place our divisor into a register
        div  $t0,$t1                   # divide by two
        mfhi $t2                       # place remainder in register
        beq  $t2,$zero,even            # branch to 'even' if remainder 0
        b    odd                       # else branch to 'odd'

even:
        li   $v0,4                     # place print string code in $v0
        la   $a0,msg_even              # address of msg
        syscall                        # call the operating system

        j exit                         # unconditional jump to exit routine

odd:
        li   $v0,4                     # place print string code in $v0
        la   $a0,msg_odd               # address of msg
        syscall                        # call the operating system

        j exit                         # unconditional jump to exit routine

exit:
        li  $v0,10                     # place exit code in $v0
        syscall                        # call the operating system

