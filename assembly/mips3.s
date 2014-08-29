# mips3.s
# read from a file

.data

fromfile: .space 40

.text

main:
    li $t0,35
    li $t1,456
    li $t2,999
    j label2

label1:
    li $t3,15
    li $t4,15
    j exit

label2:
    move $t4,$t5
    li $a2,40
    li $v0,14
    j label1

exit:
