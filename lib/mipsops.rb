#
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



module MipsOps
  UNSIGNED_MAX =  4294967295
  SIGNED_MAX   =  2147483647
  SIGNED_MIN   = -2147483648

  # Load / Store Instructions
  #
  #
  #

  # Aligned load/store instructions

  # Load Byte
  #
  # $RD = MEM[BASE] + OFFSET
  # Asm format: 'lb $rd 4(0x10000000)'
  def lb(rd, source_mem)
    @registers.gen[rd] = @memory.core[source_mem]
    true
  end

  # Load Byte Unsigned
  #
  #
  #
  def lbu(rd, source_mem)
    @registers.gen[rd] = @memory.core[source_mem]
    true
  end

  # Load Half-Word
  #
  #
  #
  def lh(rd, source_mem)
    @registers.gen[rd] = @memory.core[source_mem]
    true
  end

  # Load Half-word Unsigned
  #
  #
  #
  def lhu(rd, source_mem)
    @registers.gen[rd] = @memory.core[source_mem]
    true
  end

  # Load Word
  #
  #
  #
  def lw(rd, source_mem)
    @registers.gen[rd] = @memory.core[source_mem]
    true
  end

  # Store Word
  def sw(source_reg, dest_mem)
    @memory.core[dest_mem] = @registers.gen[source_reg]
    true
  end

  # Store Half-Word
  def shw(source_reg, dest_mem)
    @memory.core[dest_mem] = @registers.gen[source_reg]
    true
  end

  # Store Byte
  def sb(source_reg, dest_mem)
    @memory.core[dest_mem] = @registers.gen[source_reg]
    true
  end

  # Unaligned load/store instructions

  # Load Word Left
  def lwl
    true
  end

  # Load Word Right
  def lwr
    true
  end

  # Store Word Left
  def swl
    true
  end

  # Store Word Right
  def swr
    true
  end

  # Unaligned Load Word
  def ulw
    true
  end

  # Unaligned Load Half-Word
  def ulh
    true
  end

  # Unaligned Load Half-Word Unsigned
  def ulhu
    true
  end

  # Unaligned Store Word
  def usw
    true
  end

  # Unaligned Store Half-Word
  def ush
    true
  end

  # Pseudo instruction
  # Load Immediate
  def li(rd, value)
    @registers.gen[rd] = value
    true
  end

  # Pseudo instruction
  # Load Address
  def la(rd, label)
    @registers.gen[rd] = @memory.symbol_table[label]
    true
  end

  # Logical/Bitwise Instructions
  #
  #
  #

  # And
  #
  # $RD = $RS & $RT
  # Asm format: 'and $rd,$rs,$rt'
  def and_l(rd, rs, rt)
    @registers.gen[rd] = @registers.gen[rs] & @registers.gen[rt]
    true
  end

  # And Immediate
  #
  # $RD = $RS & $RT
  # Asm format: 'and $rd,$rs,$rt'
  def andi(rd, rs, immediate)
    @registers.gen[rd] = @registers.gen[rs] & immediate
    true
  end

  # Load Upper Immediate
  #
  # $RT = (imm << 16)
  # Asm format: 'lui $rt,imm'
  def lui(rt, imm)
    @registers.gen[rt] = (imm << 16)
    true
  end

  # Not Or
  #
  # $RD = ~($RS | $RT)
  # Asm format: 'nor $rd,$rs,$rt'
  def nor(rd, rs, rt)
    @registers.gen[rd] = ~(@registers.gen[rs] | @registers.gen[rt])
    true
  end

  # Or
  #
  # $RD  = $RS | $RT
  # Asm format: 'or $rd,$rs,$rt'
  def or_l(rd, rs, rt)
    @registers.gen[rd] = @registers.gen[rs] | @registers.gen[rt]
    true
  end

  # Or Immediate
  #
  # $RD = $RS | Immediate
  # Asm format: 'ori $rd,$rs,imm'
  def ori(rd, rs, immediate)
    @registers.gen[rd] = @registers.gen[rs] | immediate
    true
  end

  # Exclusive Or
  #
  # $RD = $RS ^ $RT
  # Asm format: 'xor $rd,$rs,$rt'
  def xor(rd, rs, rt)
    @registers.gen[rd] = @registers.gen[rs] ^ @registers.gen[rt]
    true
  end

  # Exclusive Or Immediate
  #
  # $RD = $RS ^ Immediate
  # Asm format: 'xori $rd,$rs,imm'
  def xori(rd, rs, immediate)
    @registers.gen[rd] = @registers.gen[rs] ^ immediate
    true
  end

  # Shift Instructions
  #
  #
  #

  # Shift Left Logical
  #
  # $RD = $RS << Immediate
  # Asm format: 'sll $rd,$rs,imm'
  def sll(rd, rs, immediate)
    @registers.gen[rd] = @registers.gen[rs] << immediate
  end

  # Shift Right Logical
  #
  # $RD = $RS >> Immediate
  # Asm format: 'srl $rs,$rs,imm'
  def srl(rd, rs, immediate)
    @registers.gen[rd] = @registers.gen[rs] >> immediate
  end

  # Arithmetic Instructions
  #
  #
  #

  # Add (signed)
  #
  # $RD = $RS + RT (traps on overflow)
  # Asm format: 'add $rd,$rs,$rt'
  def add(rd, rs, rt)
    tmp = @registers.gen[rs] + @registers.gen[rt]
    if tmp > SIGNED_MAX
      raise Mips32Error, "Arithmetic overflow"
    end
    @registers.gen[rd] = tmp
    true
  end

  # Add Immediate (signed)
  #
  # $RD = $RS + Immediate (traps on overflow)
  # Asm format: 'addi $rd,$rs,imm'
  def addi(rd, rs, immediate)
    tmp = @registers.gen[rs] + immediate
    if tmp > SIGNED_MAX
      raise Mips32Error, "Arithmetic overflow"
    end
    @registers.gen[rd] = tmp
    true
  end

  # Add Immediate Unsigned
  #
  # $RD = $RS + Immediate
  # Asm format: 'addiu $rd,$rs,imm'
  def addiu(rd, rs, immediate)
    @registers.gen[rd] = @registers.gen[rs] + immediate
    true
  end

  # Add Word Unsigned
  #
  # $RD = $RS + RT
  # Asm format: 'addu $rd,$rs,$rt'
  def addu(rd, rs, rt)
    @registers.gen[rd] = @registers.gen[rs] + @registers.gen[rt]
    true
  end

  # Count Leading Ones in Word
  #
  # $RD = count_leading_ones($RS)
  # Asm format: 'clo $rd,$rs'
  def clo(rd, rs)
    word = int_to_bitstring(@registers.gen[rs])
    @registers.gen[rd] = word.index("0")
    true
  end

  # Count leading Zeros in Word
  #
  # $RD = count_leading_zeros($RS)
  # Asm format: 'clz $rd,$rs'
  def clz(rd, rs)
    word = int_to_bitstring(@registers.gen[rs])
    @registers.gen[rd] = word.index("1")
    true
  end

  # Divide Word (signed, but doesn't trap overflow)
  #
  # $LO = $RS / $RT
  # $HI = $RS % $RT
  # Asm format: 'div $rs,$rt'
  def div(rs, rt)
    @registers.spe[:lo] = @registers.gen[rs] / @registers.gen[rt]
    @registers.spe[:hi] = @registers.gen[rs] % @registers.gen[rt]
    true
  end

  # Divide Word Unsigned
  #
  # $LO = $RS / $RT
  # $HI = $RS % $RT
  # Asm format: 'divu $rs,$rt'
  def divu(rs, rt)
    @registers.spe[:lo] = @registers.gen[rs] / @registers.gen[rt]
    @registers.spe[:hi] = @registers.gen[rs] % @registers.gen[rt]
    true
  end

  # Multiply and Add Word to Hi, Lo (signed, but does not trap on overflow)
  #
  # $Lo,$Hi = $Lo,$Hi + $RS x $RT
  # Multiply 2 32 bit integers. Add to values in Lo and Hi, LSB placed in $LO, MSB placed in $HI
  # Asm format 'madd $rs,$rt'
  def madd(rs, rt)
    tmp = @registers.gen[rs] * @registers.gen[rt]
    tmp += (@registers.spe[:lo] + @registers.spe[hi])
    if tmp > SIGNED_MAX
      @registers.spe[:lo] = SIGNED_MAX
      @registers.spe[:hi] = tmp - SIGNED_MAX
    else
      @registers.spe[:lo] = tmp
      @registers.spe[:hi] = 0
    end
    true
  end

  # Multiply and Add Unsigned Word to Hi, Lo
  #
  # $Lo,$Hi = $Lo,$Hi + $RS x $RT
  # Multiply 2 32 bit integers. Add to values in Lo and Hi, LSB placed in $LO, MSB placed in $HI
  # format: 'maddu rs,rt'
  def maddu(rs, rt)
    tmp = @registers.gen[rs] * @registers.gen[rt]
    tmp += (@registers.spe[:lo] + @registers.spe[hi])
    if tmp > UNSIGNED_MAX
      @registers.spe[:lo] = UNSIGNED_MAX
      @registers.spe[:hi] = tmp - UNSIGNED_MAX
    else
      @registers.spe[:lo] = tmp
      @registers.spe[:hi] = 0
    end
    true
  end

  # Multiply and Subtract Word to Hi, Lo (signed, but does not trap on overflow)
  #
  # $Lo,$hi = $Lo,$Hi - $RS x $RT
  # Multiply 2 32 bit integers. Subtract from values in Lo and Hi, LSB placed in $LO, MSB placed in $HI
  # Asm format: 'msub $rs,$rt'
  def msub(rs, rt)
    tmp = @registers.gen[rs] * @registers.gen[rt]
    tmp -= (@registers.spe[:lo] + @registers.spe[hi])
    if tmp > UNSIGNED_MAX
      @registers.spe[:lo] = UNSIGNED_MAX
      @registers.spe[:hi] = tmp - UNSIGNED_MAX
    else
      @registers.spe[:lo] = tmp
      @registers.spe[:hi] = 0
    end
    true
  end

  # Multiply and Subtract Unsigned Word to Hi, Lo
  #
  # $Lo,$hi = $Lo,$Hi - $RS x $RT
  # Multiply 2 32 bit integers. Subtract from values in Lo and Hi, LSB placed in $LO, MSB placed in $HI
  # Asm format: 'msubu $rs,$rt'
  def msubu(rs, rt)
    tmp = @registers.gen[rs] * @registers.gen[rt]
    tmp -= (@registers.spe[:lo] + @registers.spe[hi])
    if tmp > UNSIGNED_MAX
      @registers.spe[:lo] = UNSIGNED_MAX
      @registers.spe[:hi] = tmp - UNSIGNED_MAX
    else
      @registers.spe[:lo] = tmp
      @registers.spe[:hi] = 0
    end
    true
  end

  # Multiply Word to General Register
  #
  # $RD = $RS * $RT
  # Asm format: 'mul $rd,$rs,$rt'
  def mul(rd, rs, rt)
    @registers.gen[rd] = @registers.gen[rs] * @registers.gen[rt]
    true
  end

  # Multiply Word (signed, but does not trap on overflow)
  #
  # $Lo,$Hi = $RS * $RT
  # Asm format: 'mult $rs,$rt'
  def mult(rs, rt)
    tmp = @registers.gen[rs] * @registers.gen[rt]
    if tmp > SIGNED_MAX
      @registers.spe[:lo] = SIGNED_MAX
      @registers.spe[:hi] = tmp - SIGNED_MAX
    else
      @registers.spe[:lo] = tmp
      @registers.spe[:hi] = 0
    end
    true
  end

  # Multiply Word Unsigned
  #
  # $Lo,$Hi = $RS * $RT
  # Asm format: 'multu $rs,$rt'
  def multu(rs, rt)
    tmp = @registers.gen[rs] * @registers.gen[rt]
    if tmp > UNSIGNED_MAX
      @registers.spe[:lo] = UNSIGNED_MAX
      @registers.spe[:hi] = tmp - UNSIGNED_MAX
    else
      @registers.spe[:lo] = tmp
      @registers.spe[:hi] = 0
    end
    true
  end

  # Sign-Extend Byte
  #
  # $RD = sign_extend($RT)
  # Asm format: 'seb $rd,$rt'
  def seb(rd, rt)
    true
  end

  # Sign-Extend Halfword
  #
  # $RD = sign_extend($RT)
  # Asm format: 'seh $rd,$rt'
  def seh(rd, rt)
    true
  end

  # Set On Less Than
  #
  # $RD = 1 if $RS < $RT else 0
  # Asm format: 'slt $rd,$rs,$rt'
  def slt(rd, rs, rt)
    if @register.gen[rs] < @register.gen[rt]
      @register.gen[rd] = 1
    else
      @register.gen[rd] = 0
    end
    true
  end

  # Set On Less Than Immediate
  #
  # $RD = 1 if $RS < Immediate
  # Asm format: 'slti $rd,$rs,imm'
  def slti(rd, rs, immediate)
    if @register.gen[rs] < immediate
      @register.gen[rd] = 1
    else
      @register.gen[rd] = 0
    end
    true
  end

  # Set On Less Than Immediate Unsigned
  #
  # $RD = 1 if $RS < Immediate
  # Asm format: 'sltiu $rd,$rs,imm'
  def sltiu(rd, rs, immediate)
    if @register.gen[rs] < immediate
      @register.gen[rd] = 1
    else
      @register.gen[rd] = 0
    end
    true
  end

  # Set on Less Than Unsigned
  #
  # $RD = 1 if $RS < $RT else 0
  # Asm format: 'sltu $rd,$rs,imm'
  def sltu(rd, rs, rt)
    if @register.gen[rs] < @register.gen[rt]
      @register.gen[rd] = 1
    else
      @register.gen[rd] = 0
    end
    true
  end

  # Subtract (signed)
  #
  # $RD = $RS - $RT
  # Asm format: 'sub $rd,$rs,$rt'
  def sub(rd, rs, rt)
    tmp = @registers.gen[rs] - @registers.gen[rt]
    if tmp < SIGNED_MIN
      raise Mips32Error, "Arithmetic overflow"
    end
    @registers.gen[rd] = tmp
    true
  end

  # Subtract Unsigned
  #
  # $RD = $RS - $RT
  # Asm format: 'sub $rd,$rs,$rt'
  def subu(rd, rs, rt)
    @registers.gen[rd] = @registers.gen[rs] - @registers.gen[rt]
    true
  end

#########

  # Move From Hi
  def mfhi(rd)
    @registers.gen[rd] = @registers.spe[:hi]
    true
  end

  # Move From Lo
  def mflo(rd)
    @registers.gen[rd] = @registers.spe[:lo]
    true
  end

  # Move From Coprocessor Register
  # FIXME:
  def mfc0(rd, spec_reg)
    @registers.gen[rd] = @registers.spe[spec_reg]
    true
  end

  # Pseudo instruction
  # Move
  def move(rd, source_reg)
    @registers.gen[rd] = @registers.gen[source_reg]
    true
  end
##############


  # Branch/Jump Instructions
  #
  #
  #

  # Unconditional Branch
  #
  # PC = Label
  # Asm format: 'b label'
  def b(targ)
    @registers.spe[:pc] = @memory.symbol_table[targ]
    true
  end

  # Branch on Equal
  #
  # IF ($RS == $RT) PC = Label
  # Asm format: 'beq $rs,$rt,label'
  def beq(rs, rt, targ)
    if @registers.gen[:rs] == @registers.gen[:rt]
      @registers.spe[:pc] = @memory.symbol_table[targ]
    end
    true
  end

  # Branch Less Than (PSEUDO)
  #
  # IF ($RS < $RT) PC = Label
  # Asm format: 'blt $rs,$rt,label'
  def blt(rs, rt, targ)
    if @registers.gen[:rs] < @registers.gen[:rt]
      @registers.spe[:pc] = @memory.symbol_table[targ]
    end
    true
  end

  # Branch Less Than or Equal (PSEUDO)
  #
  # IF ($RS <= $RT) PC = Label
  # Asm format: 'ble $rs,$rt,label'
  def ble(rs, rt, targ)
    if @registers.gen[:rs] <= @registers.gen[:rt]
      @registers.spe[:pc] = @memory.symbol_table[targ]
    end
    true
  end

  # Branch Greater Than (PSEUDO)
  #
  # IF ($RS > $RT) PC = Label
  # Asm format: 'bgt $rs,$rt,label'
  def bgt(rs, rt, targ)
    if @registers.gen[:rs] > @registers.gen[:rt]
      @registers.spe[:pc] = @memory.symbol_table[targ]
    end
    true
  end

  # Branch Greater Than or Equal (PSEUDO)
  #
  # IF ($RS >= $RT) PC = Label
  # Asm format: 'bge $rs,$rt,label'
  def bge(rs, rt, targ)
    if @registers.gen[:rs] >= @registers.gen[:rt]
      @registers.spe[:pc] = @memory.symbol_table[targ]
    end
    true
  end

  # Branch if Not Equal
  #
  # IF ($RS != $RT) PC = Label
  # Asm format: 'bne $rs,$rt,label'
  def bne(rs, rt, targ)
    if @registers.gen[:rs] != @registers.gen[:rt]
      @registers.spe[:pc] = @memory.symbol_table[targ]
    end
    true
  end

  # Unconditional Jump
  #
  # PC = Label
  # Asm format: 'j label'
  def j(targ)
    @registers.spe[:pc] = @memory.symbol_table[targ]
    true
  end

  # Jump Register
  #
  # PC = $RS
  # Asm format: 'j $rs'
  def jr(rs)
    @registers.spe[:pc] = @registers.gen[:rs]
    true
  end

  # Jump and Link
  def jal(targ)
  end

  # syscalls
  #
  # A simple set of syscalls as found in SPIM
  #

  def syscall
    case @registers.gen[:v0]                     # $v0 holds the syscall code
    when 1                                       # print integer
      # $a0 = integer to print
      puts @registers.gen[:a0]
    when 2                                       # print float
      # $f12 = float to print
      puts @registers.fpr[:f12]
    when 3                                       # print double
      # $f12 = double to print
      puts @registers.fpr[:f12]
    when 4                                       # print string
      # $a0 = address of null-terminated string to print
      puts @memory.core[@registers.gen[:a0]]
    when 5                                       # read integer
      # $v0 contains integer read
      @registers.gen[:v0] = gets.chomp.to_i
    when 6                                       # read float
      # $f0 contains float read
      @registers.gen[:f0] = gets.chomp.to_f
    when 7                                       # read double
      # $f0 contains double read
      @registers.gen[:f0] = gets.chomp.to_f
    when 8                                       # read string
      # $a0 = address of input buffer
      # $a1 = max number of chars to read
      s = gets.chomp
      if s.length > @registers.gen[:a1]
        s = s[0..(@registers.gen[:a1] - 2)]
        s += "\0"
      elsif s.length < @registers.gen[:a1]
        s += "\0" * (@registers.gen[:a1] - s.length)
      else
        s[-1] = "\0"
      end
      @memory.core[@registers.gen[:a0]] = s
    when 9                                       # sbrk (allocate heap memory)
      # $a0 = number of bytes to allocate
      # $v0 contains address of allocated memory
      @registers.gen[:v0] = @memory.heap_pointer
      @memory.heap_pointer = @memory.heap_pointer + @registers.gen[:a0]
    when 10                                      # exit
      Kernel.exit(true)
    when 11                                      # print character
      # $a0 = character to print
      puts @registers.gen[:a0].chr
    when 12                                      # read character
      # $v0 contains character read
      @registers.gen[:v0] = gets[0].ord
    when 13                                      # open file
      # $a0 = address of null-terminated string containing filename
      # $a1 = flags
      # $a2 = mode
      # $v0 contains file descriptor (negative if error)
      filename = @memory.core[@registers.gen[:a0]][1]
      @registers.gen[:v0] = @fp.length + 3
      @fp[@fp.length + 3] = filename[0..-2]
    when 14                                      # read from file
      # $a0 = file descriptor
      # $a1 = address of input buffer
      # $a2 = max number of chars to read
      # $v0 contains number of chars read (0 if EOF, negative if error)
      filename = @fp[@registers.gen[:a0]]
      chars = File.open(filename).read(@registers.gen[:a2])
      @memory.core[@registers.gen[:a1]] = chars
      @registers.gen[:v0] = chars.length
      #= @registers.gen[:a1]
      #= @registers.gen[:a2]
    when 15                                      # write to file
      # $a0 = file desciptor
      # $a1 = address of output buffer
      # $a2 = number of characters to write
      filename = @fp[@registers.gen[:a0]]
      chars = @memory.core[@registers.gen[:a1]]
      # check size of chars
      fp = File.open(filename, "w")
      fp.write(chars)
    when 16                                      # close file
      # $a0 = file descriptor
      @fp.delete(@registers.gen[:a0])
    when 17                                      # exit2 (terminate with value)
      # $a0 = termination result
      Kernel.exit(@registers.gen[:a0])
    end

  end

end
