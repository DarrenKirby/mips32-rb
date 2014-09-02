#    Copyright:: (c) 2014 Darren Kirby
#    Author:: Darren Kirby (mailto:bulliver@gmail.com)

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

module Syscalls
  # Implements syscalls for a Linux kernel running on Mips32
  # syscall numbers gleaned from arch/mips/include/asm/unistd.h
  #
  #
  def linux_syscall
    case @registers.gen[:v0]        # $v0 holds the syscall code
    when 4000
      # syscall
    when 4001
      # exit
    when 4002
      # fork
    when 4003
      # read
      # $a0 = file descriptor
      # $a1 = address of input buffer
      # $a2 = max number of bytes to read
      # $v0 contains number of chars read (0 if EOF, negative if error)
      # $v1 will contain ERRNO if return < 0
    when 4004
      # write
      # $a0 = file descriptor
      # $a1 = address of output buffer
      # $a2 = max number of bytes to write
      # $v0 contains number of chars written (0 if nothing written, negative if error)
      # $v1 will contain ERRNO if return < 0
    when 4005
      # open
      # $a0 = address of filename
      # $a1 = flags
      # $a2 = optional mode
      # $v0 will contain non-negative integer file descriptor, or -1 on error
      # $v1 will contain ERRNO if return < 0
    when 4006
      # close
      # $a0 = file descriptor
      # $v0 will contain 0 on success, or -1 on error
      # $v1 will contain ERRNO if return < 0
    when 4007
      # waitpid
    when 4008
      # creat
    when 4009
      # link
    when 4010
      # unlink
    when 4011
      # execve
    when 4012
      # chdir
    when 4013
      # time
    when 4014
      # mknod
    when 4015
      # chmod
    when 4016
      # lchown
    when 4017
      # break
    # when 4018 UNUSED
      #
    when 4019
      # lseek
    when 4020
      # getpid
    when 4021
      # mount
    when 4022
      # umount
    when 4023
      # setuid
    when 4024
      # getuid
    when 4025
      # stime
    when 4026
      # ptrace
    when 4027
      # alarm
    # when 4028 UNUSED
      #
    when 4029
      # pause
    when 4030
      # utime
    when 4031
      # stty
    when 4032
      # gtty
    when 4033
      # access
    when 4034
      # nice
    when 4035
      # ftime
    when 4036
      # sync
    when 4037
      # kill
    when 4038
      # rename
    when 4039
      # mkdir
    when 4040
      # rmdir
    when 4041
      # dup
    when 4042
      # pipe
    when 4043
      # times
    when 4044
      # prof
    when 4045
      # brk
    when 4046
      # setgid
    when 4047
      # getgid
    when 4048
      # signal
    when 4049
      # geteuid
    when 4050
      # getegid
    when 4051
      # acct
    when 4052
      # umount2
    when 4053
      # lock
    when 4054
      # ioctl
    when 4055
      # fcntl
    when 4056
      # mpx
    when 4057
      # setpdid
    when 4058
      # ulimit
    # when 4059 UNUSED
      #
    when 4060
      # umask
    when 4061
      # chroot
    when 4062
      # ustat
    when 4063
      # dup2
    when 4064
      # getppid
    when 4065
      # getpgrp
    when 4066
      # setsid
    when 4067
      # sigaction
    when 4068
      # sgetmask
    when 4069
      # ssetmask
    when 4070
      # setruid
    when 4071
      # setregid
    when 4072
      # sigsuspend
    when 4073
      # sigpending
    when 4074
      # sethostname
    when 4075
      # setrlimit
    when 4076
      # getrlimit
    when 4077
      # getrusage
    when 4078
      # gettimeofday
    when 4079
      # settimeofday
    when 4080
      # getgroups
    when 4081
      # setgroups
    # when 4082 RESERVED
      #
    when 4083
      # symlink
    # when 4084 UNUSED
      #
    when 4085
      # readlink
    when 4086
      # uselib
    when 4087
      # swapon
    when 4088
      # reboot
    when 4089
      # readdir
    when 4090
      # mmap
    when 4091
      # munmap
    when 4092
      # truncate
    when 4093
      # ftruncate
    when 4094
      # fchmod
    when 4095
      # fchown
    when 4096
      # getpriority
    when 4097
      # setpriority
    when 4098
      # profil
    when 4099
      # statfs
    when 4100
      # fstatfs
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when
    when

  end
end
