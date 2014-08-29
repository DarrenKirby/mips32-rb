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

  # Load Word
  def lw(dest_reg, source_mem)
    @registers.gen[dest_reg] = @memory.core[source_mem]
    true
  end

  # Load Half-Word
  def lh(dest_reg, source_mem)
    @registers.gen[dest_reg] = @memory.core[source_mem]
    true
  end

  # Load Half-word Unsigned
  def lhu(dest_reg, source_mem)
    @registers.gen[dest_reg] = @memory.core[source_mem]
    true
  end

  # Load Byte
  def lb(dest_reg, source_mem)
    @registers.gen[dest_reg] = @memory.core[source_mem]
    true
  end

  # Load Byte Unsigned
  def lbu(dest_reg, source_mem)
    @registers.gen[dest_reg] = @memory.core[source_mem]
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
  end

  # Load Word Right
  def lwr
  end

  # Store Word Left
  def swl
  end

  # Store Word Right
  def swr
  end

  # Unaligned Load Word
  def ulw
  end

  # Unaligned Load Half-Word
  def ulh
  end

  # Unaligned Load Half-Word Unsigned
  def ulhu
  end

  # Unaligned Store Word
  def usw
  end

  # Unaligned Store Half-Word
  def ush
  end

  # Pseudo instruction
  # Load Immediate
  def li(dest_reg, value)
    @registers.gen[dest_reg] = value
    true
  end

  # Pseudo instruction
  # Load Address
  def la(dest_reg, label)
    @registers.gen[dest_reg] = @memory.symbol_table[label]
    true
  end

  # Logical/Bitwise Instruction
  #
  #
  #

  # And
  def and_l(dest_reg, reg_1, reg_2)
    @registers.gen[dest_reg] = @registers.gen[reg_1] & @registers.gen[reg_2]
  end

  # And Immediate
  def andi(dest_reg, reg_1, immediate)
    @registers.gen[dest_reg] = @registers.gen[reg_1] & immediate
  end

  # Nor
  def nor(dest_reg, reg_1, reg_2)
    @registers.gen[dest_reg] = ~ (@registers.gen[reg_1] | @registers.gen[reg_2])
  end

  # Or
  def or_l(dest_reg, reg_1, reg_2)
    @registers.gen[dest_reg] = @registers.gen[reg_1] | @registers.gen[reg_2]
  end

  # Or Immediate
  def ori(dest_reg, reg_1, immediate)
    @registers.gen[dest_reg] = @registers.gen[reg_1] | immediate
  end

  # Shift Left Logical
  def sll(dest_reg, reg_1, immediate)
    @registers.gen[dest_reg] = @registers.gen[reg_1] << immediate
  end

  # Shift Right Logical
  def srl(dest_reg, reg_1, immediate)
    @registers.gen[dest_reg] = @registers.gen[reg_1] >> immediate
  end

  # Arithmetic Instructions
  #
  #
  #

  # Add (signed)
  def add(dest_reg, reg_1, reg_2)
    @registers.gen[dest_reg] = @registers.gen[reg_1] + @registers.gen[reg_2]
    true
  end

  # Subtract (signed)
  def sub(dest_reg, reg_1, reg_2)
    @registers.gen[dest_reg] = @registers.gen[reg_1] - @registers.gen[reg_2]
    true
  end

  # Add Immediate
  def addi(dest_reg, reg_1, immediate)
    @registers.gen[dest_reg] = @registers.gen[reg_1] + immediate
    true
  end

  # Add Unsigned
  def addu(dest_reg, reg_1, reg_2)
    @registers.gen[dest_reg] = @registers.gen[reg_1] + @registers.gen[reg_2]
    true
  end

  # Subtract Unsigned
  def subu(dest_reg, reg_1, reg_2)
    @registers.gen[dest_reg] = @registers.gen[reg_1] - @registers.gen[reg_2]
    true
  end

  # multiply 32-bit quantities in $t3 and $t4, and store 64-bit
  # result in special registers Lo and Hi:  (Hi,Lo) = $t3 * $t4
  # Multiply
  def mult(reg_1, reg_2)
    tmp = @registers.gen[reg_1] * @registers.gen[reg_2]
    #if tmp > SIGNED #  Overflow?
    #end
  end

  # Multiply Unsigned
  def multu(reg_1, reg_2)
    tmp = @registers.gen[reg_1] * @registers.gen[reg_2]
    if tmp > UNSIGNED_MAX #  Overflow?
      @registers.spe[:lo] = UNSIGNED_MAX
      @registers.spe[:hi] = tmp - UNSIGNED_MAX
    else
      @registers.spe[:lo] = tmp
    end
    true
  end

  # Divide
  def div(reg_1, reg_2)
    @registers.spe[:lo] = @registers.gen[reg_1] / @registers.gen[reg_2] #  Lo = $t5 / $t6   (integer quotient)
    @registers.spe[:hi] = @registers.gen[reg_1] % @registers.gen[reg_2] #  Hi = $t5 mod $t6   (remainder)
    true
  end

  # Divide Unsigned
  def divu(reg_1, reg_2)
    @registers.spe[:lo] = @registers.gen[reg_1] / @registers.gen[reg_2] #  Lo = $t5 / $t6   (integer quotient)
    @registers.spe[:hi] = @registers.gen[reg_1] % @registers.gen[reg_2] #  Hi = $t5 mod $t6   (remainder)
    true
  end

  # Move From Hi
  def mfhi(dest_reg)
    @registers.gen[dest_reg] = @registers.spe[:hi]
    true
  end

  # Move From Lo
  def mflo(dest_reg)
    @registers.gen[dest_reg] = @registers.spe[:lo]
    true
  end

  # Move From Coprocessor Register
  # FIXME:
  def mfc0(dest_reg, spec_reg)
    @registers.gen[dest_reg] = @registers.spe[spec_reg]
    true
  end

  # Pseudo instruction
  # Move
  def move(dest_reg, source_reg)
    @registers.gen[dest_reg] = @registers.gen[source_reg]
    true
  end

  # Control Structures
  #
  #
  #

  # unconditional branch to program label 'targ'
  def b(targ)
  end

  # branch to targ if a = b
  def beq(a, b, targ)
  end

  #  branch to targ if  a < b
  def blt(a, b, targ)
  end

  #  branch to targ if  a <= b
  def ble(a, b, targ)
  end

  #  branch to targ if  a > b
  def bgt(a, b, targ)
  end

  #  branch to targ if  a >= b
  def bge(a, b, targ)
  end

  #  branch to targ if  a != b
  def bne(a, b, targ)
  end

  # Unconditional jump
  def j(targ)
    @registers.spe[:pc] = @memory.symbol_table[targ]
    true
  end

  # Jump register
  def jr(targ)
  end

  # Jump and Link
  def jal(targ)
  end

  # syscalls
  #
  #
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
    when 10                                      # exit
      Kernel.exit(true)
    when 11                                      # print character
      # $a0 = character to print
    when 12                                      # read character
      # $v0 contains character read
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
    when 15                                        # write to file
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
