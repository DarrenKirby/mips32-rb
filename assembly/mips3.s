# mips3.s
# read from a file

.data

msg:   .ascii   "In main"
msg2:  .ascii   "In label1"
msg3:  .ascii   "In label2"
msg4:  .ascii   "In exit"

.text

main:
    li   $v0,4
    la   $a0,msg
    syscall
    li $t0,35
    li $t1,456
    li $t2,999
    j label2

label1:
    li   $v0,4
    la   $a0,msg2
    syscall
    li $t3,15
    li $t4,15
    j exit

label2:
    li   $v0,4
    la   $a0,msg3
    syscall
    move $t4,$t5
    li $a2,40
    li $v0,14
    j label1

exit:
    li   $v0,4
    la   $a0,msg4
    syscall
    li  $v0,10                           # place exit code in $v0
    syscall                              # call the operating system
