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

module Assembler

  def assemble(instruction)

    ops = {
    # R-Format Instructions
    # [opcode (6)|RS (5)|RT (5)|RD (5)|Shamt (5)|Function (6)]
    # Name         type   opcode    function
      "add"   => [ "R", "000000", "100000" ],
      "addu"  => [ "R", "000000", "100001" ],
      "and"   => [ "R", "000000", "100100" ],
      "jr"    => [ "R", "000000", "001000" ],
      "nor"   => [ "R", "000000", "100111" ],
      "or"    => [ "R", "000000", "100101" ],
      "slt"   => [ "R", "000000", "101010" ],
      "sltu"  => [ "R", "000000", "101011" ],
      "sll"   => [ "R", "000000", "000000" ],
      "srl"   => [ "R", "000000", "000010" ],
      "sub"   => [ "R", "000000", "100010" ],
      "subu"  => [ "R", "000000", "100011" ],
      "div"   => [ "R", "000000", "011010" ],
      "divu"  => [ "R", "000000", "011011" ],
      "mfhi"  => [ "R", "000000", "010000" ],
      "mflo"  => [ "R", "000000", "010010" ],
      "mul"   => [ "R", "011100", "000010" ],
      "mult"  => [ "R", "000000", "011000" ],
      "multu" => [ "R", "000000", "011001" ],
      "mfc0"  => [ "R", "010000", "000000" ],

    # I-Format Instructions
    # [Opcode (6)|RS (5)|RT (5)|Immediate (16)]
    # Name         type   opcode
      "addi"  => [ "I", "001000" ],
      "addiu" => [ "I", "001001" ],
      "andi"  => [ "I", "001100" ],
      "lui"   => [ "I", "001111" ],
      "ori"   => [ "I", "001101" ],
      "slti"  => [ "I", "001010" ],
      "sltiu" => [ "I", "001011" ],
      "swc1"  => [ "I", "111001" ],
      "swc2"  => [ "I", "111010" ],
      "sdc1"  => [ "I", "111101" ],
      "sdc2"  => [ "I", "111101" ],

    # Load/Story Memory Instructions (M-Format)
    # [Opcode (6)|RS (5)|RT (5)|Offset (16)]
    # Name         type   opcode
      "lb"    => [ "M", "100000" ],
      "lbu"   => [ "M", "100100" ],
      "lh"    => [ "M", "100001" ],
      "lhu"   => [ "M", "100101" ],
      "lw"    => [ "M", "100011" ],
      "sb"    => [ "M", "101000" ],
      "sh"    => [ "M", "101001" ],
      "sw"    => [ "M", "101011" ],
      "lwc1"  => [ "M", "110001" ],
      "lwc2"  => [ "M", "110001" ],
      "ldc1"  => [ "M", "110101" ],
      "ldc2"  => [ "M", "110110" ],
      "beq"   => [ "M", "000100" ],
      "bne"   => [ "M", "000101" ],

    # Jump Instructions (J-Format)
    # [Opcode (6)| Address (26)
    # Name
      "j"     => [ "J", "000010" ],
      "jal"   => [ "J", "000011" ],


    # pseudo instructions
      "li"    => [ "P" ],
      "move"  => [ "P" ],
      "la"    => [ "P" ],

    }

    s = Kernel.caller[0]
    if instruction == "syscall"
      mc = sprintf("%032b", 12) # syscall
      return [mc.to_i(2), mc]
    end
    if ops[instruction.split[0]][0] == "R"
      mc = r_type(instruction,ops)
      print "Opcode: #{mc[0..5]} RS: #{mc[6..10]} RT: #{mc[11..15]} RD: #{mc[16..20]} " \
             "Shamt: #{mc[21..25]} Function: #{mc[26..-1]}\n" if s[(s.index("`")+1)..-2] == "irb_binding"
    elsif ops[instruction.split[0]][0] == "I"
      mc = i_type(instruction,ops)
      print "Opcode: #{mc[0..5]} RS: #{mc[6..10]} RT: #{mc[11..15]} Immediate: #{mc[16..-1]}\n" if defined? conf.prompt_i
    elsif ops[instruction.split[0]][0] == "M"
      mc = m_type(instruction,ops)
      print "Opcode: #{mc[0..5]} Base: #{mc[6..10]} RT: #{mc[11..15]} Offset: #{mc[16..-1]}\n" if defined? conf.prompt_i
    elsif ops[instruction.split[0]][0] == "P"
      mc = p_type(instruction,ops)
    else
      mc = j_type(instruction,ops)
      print "Opcode: #{mc[0..5]} Address: #{mc[6..-1]}\n" if defined? conf.prompt_i
    end
    [mc.to_i(2), mc]
  end

  private
  # Convert symbolic register name to integer.

  def reg_to_bin(a)
    pos = [:zero, :at, :v0, :v1, :a0, :a1, :a2, :a3,
             :t0, :t1, :t2, :t3, :t4, :t5, :t6, :t7,
             :s0, :s1, :s2, :s3, :s4, :s5, :s6, :s7,
             :t8, :t9, :k0, :k1, :gp, :sp, :fp, :ra]
    n = []
    a.each do |reg|
      reg[0] > 57 ? n << pos.index(reg.to_sym).to_i : n << reg.to_i
    end
    n
  end

  # Assemble a pseudo instruction
  def p_type(s,ops)
    op, args = s.split
    a = args.split(",")
    if op == "li"
      return i_type("ori #{a[0]},$zero,#{a[1]}", ops)
    end

    if op == "la"
      # lui $at, %lo[addr]
      # addiu $2, $at, $hi[addr]
      # FIXME:
      return "00000000000000000000000000000000"
    end


    if op == "move"
      return r_type("add #{a[0]},$zero,#{a[1]}", ops)
    end
  end

  # Assemble an R-format Mips instruction.
  def r_type(s,ops)
    op, args = s.split
    args = reg_to_bin(args.delete("$").split(","))
    mc = ops[op][1]                  # Opcode
    if ["sll", "srl"].index(op)      # Shift Operations?
      mc += "00000"                  # RS is n/a
      mc += sprintf("%05b", args[1]) # RT
      mc += sprintf("%05b", args[0]) # RD
      mc += sprintf("%05b", args[2]) # Shamt
      mc += ops[op][2]               # Function
    else
      mc += sprintf("%05b", args[1]) # RS
      mc += sprintf("%05b", args[2]) # RT
      mc += sprintf("%05b", args[0]) # RD
      mc += "00000"                  # Shamt is n/a
      mc += ops[op][2]               # Function
    end
  end

  # Assemble an I-format Mips instruction.
  def i_type(s,ops)
    op, args = s.split
    args = reg_to_bin(args.delete("$").split(","))
    mc = ops[op][1]                                 # Opcode
    mc += sprintf("%05b", args[1])                  # RS
    mc += sprintf("%05b", args[0])                  # RT
    mc += sprintf("%016b", args[2])                 # Immediate
  end

  # Assemble an M-format Mips instruction.
  def m_type(s,ops)
    op, args = s.split
    d_reg, offset = args.delete("$").split(",")
    i, o_reg = offset.split("(")
    ok = reg_to_bin([d_reg, i, o_reg[0..-2]])
    mc = ops[op][1]                              # Opcode
    mc += sprintf("%05b", ok[2])                 # Base
    mc += sprintf("%05b", ok[0])                 # RT
    mc += sprintf("%016b", ok[1])                # Offset
  end

  # Assemble an J-format Mips instruction.
  def j_type(s,ops)
    op, arg = s.split
    if (48..57).member?(arg[0])                    # Check if argument is integer
      mc = ops[op][1]                              # Opcode
      mc += sprintf("%026b", arg.to_i(0))          # 26 bit address
      return mc
    elsif arg[0] == 36                                    # Check if argument is a register
      arg.delete!("$")
      mc = ops[op][1]                                     # Opcode
      mc += sprintf("%026b", @registers.gen[arg.to_sym])  # 26 bit address retrieved fromm register
      return mc
    else
      mc = ops[op][1]
      mc += sprintf("%026b", @memory.symbol_table[arg])
      return mc
    end

  end

  def dissemble(instruction)
    opcode = instruction[0..5]
    if opcode == "000000"
      r_type(instruction)
    else
    end
  end
end
