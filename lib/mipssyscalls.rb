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
      # proto: void _exit(int status);
    when 4002
      # fork
      # proto: pid_t fork(void);
    when 4003
      # read
      # proto: ssize_t read(int fd, void *buf, size_t count);
      # $a0 = file descriptor
      # $a1 = address of input buffer
      # $a2 = max number of bytes to read
      # $v0 contains number of chars read (0 if EOF, negative if error)
      # $v1 will contain ERRNO if return < 0
    when 4004
      # write
      # proto: ssize_t write(int fd, const void *buf, size_t count);
      # $a0 = file descriptor
      # $a1 = address of output buffer
      # $a2 = max number of bytes to write
      # $v0 contains number of chars written (0 if nothing written, negative if error)
      # $v1 will contain ERRNO if return < 0
    when 4005
      # open
      # proto: int open(const char *pathname, int flags);
      # proto: int open(const char *pathname, int flags, mode_t mode);
      # $a0 = address of filename
      # $a1 = flags
      # $a2 = optional mode
      # $v0 will contain non-negative integer file descriptor, or -1 on error
      # $v1 will contain ERRNO if return < 0
    when 4006
      # close
      # proto: int close(int fd);
      # $a0 = file descriptor
      # $v0 will contain 0 on success, or -1 on error
      # $v1 will contain ERRNO if return < 0
    when 4007
      # waitpid
      # proto: pid_t waitpid(pid_t pid, int *status, int options);
    when 4008
      # creat
      # proto: int creat(const char *pathname, mode_t mode);
    when 4009
      # link
      # proto: int link(const char *oldpath, const char *newpath);
    when 4010
      # unlink
      # int unlink(const char *pathname);
    when 4011
      # execve
      # proto: int execve(const char *filename, char *const argv[], char *const envp[]);
    when 4012
      # chdir
      # proto: int chdir(const char *path);
    when 4013
      # time
      # proto: time_t time(time_t *t);
    when 4014
      # mknod
      # proto: int mknod(const char *pathname, mode_t mode, dev_t dev);
    when 4015
      # chmod
      # proto: int chmod(const char *pathname, mode_t mode);
    when 4016
      # lchown
      # proto: int lchown(const char *pathname, uid_t owner, gid_t group);
    when 4017
      # break
      # Unimplemented. returns -1.
    # 4018 UNUSED
      #
    when 4019
      # lseek
      # proto: off_t lseek(int fd, off_t offset, int whence);
    when 4020
      # getpid
      # proto: pid_t getpid(void);
    when 4021
      # mount
      # proto: int mount(const char *source, const char *target, const char *filesystemtype, unsigned long mountflags, const void *data);
    when 4022
      # umount
      # proto: int umount(const char *target);
    when 4023
      # setuid
      # proto: int setuid(uid_t uid);
    when 4024
      # getuid
      # proto: uid_t getuid(void);
    when 4025
      # stime
      # proto: int stime(const time_t *t);
    when 4026
      # ptrace
      # proto: long ptrace(enum __ptrace_request request, pid_t pid, void *addr, void *data);
    when 4027
      # alarm
      # proto: unsigned int alarm(unsigned int seconds);
    # 4028 UNUSED
      #
    when 4029
      # pause
      # proto: int pause(void);
    when 4030
      # utime
      # proto: int utime(const char *filename, const struct utimbuf *times);
    when 4031
      # stty
      # Not implemented. Returns -1.
    when 4032
      # gtty
      # Not implemented. Returns -1.
    when 4033
      # access
      # proto: int access(const char *pathname, int mode);
    when 4034
      # nice
      # proto: int nice(int inc);
    when 4035
      # ftime
      # Not implemented. Returns -1.
    when 4036
      # sync
      # proto: void sync(void);
    when 4037
      # kill
      # proto: int kill(pid_t pid, int sig);
    when 4038
      # rename
      # proto: int rename(const char *oldpath, const char *newpath);
    when 4039
      # mkdir
      # proto: int mkdir(const char *pathname, mode_t mode);
    when 4040
      # rmdir
      # proto: int rmdir(const char *pathname);
    when 4041
      # dup
      # proto: int dup(int oldfd);
    when 4042
      # pipe
      # proto: int pipe(int pipefd[2]);
    when 4043
      # times
      # proto: clock_t times(struct tms *buf);
    when 4044
      # prof
      # Unimplemented. Returns -1.
    when 4045
      # brk
      # proto: int brk(void *addr);
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
    # 4059 UNUSED
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
    # 4082 RESERVED
      #
    when 4083
      # symlink
    # 4084 UNUSED
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
      # proto: int fchown(int fd, uid_t owner, gid_t group);
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
    when 4101
      # ioperm
    when 4102
      # socketcall
    when 4103
      # syslog
    when 4104
      # setitimer
    when 4105
      # getitimer
    when 4106
      # stat
    when 4107
      # lstat
    when 4108
      # fstat
    # 4109 UNUSED
      #
    when 4110
      # iopl
    when 4111
      # vhangup
    when 4112
      # idle
    when 4113
      # vm86
    when 4114
      # wait4
    when 4115
      # swapoff
    when 4116
      # sysinfo
    when 4117
      # ipc
    when 4118
      # fsync
    when 4119
      # sigreturn
    when 4120
      # clone
    when 4121
      # setdomainname
    when 4122
      # uname
    when 4123
      # modify_ldt
    when 4124
      # adjtimex
    when 4125
      # mprotect
    when 4126
      # sigprocmask
    when 4127
      # create_module
    when 4128
      # init_module
    when 4129
      # delete_module
    when 4130
      # get_kernel_syms
    when 4131
      # quotactl
    when 4132
      # getpgid
    when 4133
      # fchdir
    when 4134
      # bdflush
    when 4135
      # sysfs
    when 4136
      # personality
    when 4137
      # afs_syscall
    when 4138
      # setfsuid
    when 4139
      # setfguid
    when 4140
      # llseek
    when 4141
      # getdents
    when 4142
      # newselect
    when 4143
      # flock
    when 4144
      # msync
    when 4145
      # readv
    when 4146
      # writev
    when 4147
      # cacheflush
    when 4148
      # cachectl
    when 4149
      # sysmips
    #when 4150 UNUSED
      #
    when 4151
      # getsid
    when 4152
      # fdatasync
    when 4153
      # sysctl
    when 4154
      # mlock
    when 4155
      # munlock
    when 4156
      # mlockall
    when 4157
      # munlockall
    when 4158
      # sched_setparam
    when 4159
      # sched_getparam
    when 4160
      # sched_setscheduler
    when 4161
      # sched_getscheduler
    when 4162
      # sched_yield
    when 4163
      # sched_get_priority_max
    when 4164
      # sched_get_priority_min
    when 4165
      # sched_rr_get_interval
    when 4166
      # nanosleep
    when 4167
      # mremap
    when 4168
      # accept
    when 4169
      # bind
    when 4170
      # connect
    when 4171
      # getpeername
    when 4172
      # getsockname
    when 4173
      # getsockopt
    when 4174
      # listen
    when 4175
      # recv
    when 4176
      # recvfrom
    when 4177
      # recvmsg
    when 4178
      # send
    when 4179
      # sendmsg
    when 4180
      # sendto
    when 4181
      # setsockopt
    when 4182
      # shutdown
    when 4183
      # socket
    when 4184
      # socketpair
    when 4185
      # setresuid
    when 4186
      # getresuid
    when 4187
      # query_module
    when 4188
      # poll
    when 4189
      # nfsservctl
    when 4190
      # setresgid
    when 4191
      # getresgid
    when 4192
      # prctl
    when 4193
      # rt_sigreturn
    when 4194
      # rt_sigaction
    when 4195
      # rt_sigprocmask
    when 4196
      # rt_sigpending
    when 4197
      # rt_sigtimedwait
    when 4198
      # rt_sigqueueinfo
    when 4199
      # rt_sigsuspend
    when 4200
      # pread64
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
