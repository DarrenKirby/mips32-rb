# mips.s
# Just moves numbers around

.data

buf:     .space     40
prompt:  .ascii     "Type a string: "
prompt2: .ascii     "You typed: "

.text
ori  $s0,$zero,250           # put 250 in register $s0
ori  $s1,$zero,300           # put 300 in register $s1
add  $t0,$s0,$s1             # $t0 = $s0 + $s1
ori  $t6,$zero,456           # put 456 in register $t6

ori  $t1,$zero,3000
div  $t1,$t0
  mflo $t2
  mfhi $t3

sll  $t4,$t1,2               # this is all really just to make sure
sll  $t5,$t1,4               # the code deals with comments properly

li   $v0,4
la   $a0,prompt
syscall

li   $v0,8                   # syscall code for read string
li   $a1,40                  # max chars to read
la   $a0,buf                 # address of buffer
syscall

li   $v0,4
la   $a0,prompt2
syscall

li   $v0,4                   # syscall code for print string
la   $a0,buf                 # address of string
syscall
