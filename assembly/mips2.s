# mips2.s
# grab two integers from the user
# print the sum and exit

.data

prompt:   .ascii   "Type an integer: "
prompt2:  .ascii   "Type another integer: "


.text

li   $v0,4                           # place print string code in $v0
la   $a0,prompt                      # address of prompt
syscall                              # call the operating system

li   $v0,5                           # place read int code in $v0
syscall                              # call the operating system

move $s0,$v0                         # move first integer to $s0

li  $v0,4                            # place print string code in $v0
la  $a0,prompt2                      # address of prompt
syscall                              # call the operating system

li  $v0,5                            # place read int code in $v0
syscall                              # call the operating system

move $s1,$v0                         # move second integer to $s1

add  $a0,$s0,$s1                     # add integers, place sum in $a0

li  $v0,1                            # place print int code in $v0
syscall                              # call the operating system

# commented out because this will quit irb...
# li  $v0,10                           # place exit code in $v0
# syscall                              # call the operating system
