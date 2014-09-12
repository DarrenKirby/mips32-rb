#!/usr/bin/ruby
#
# = Description
#
# A MIPS32 emulator
#
# = Copyright and Disclaimer
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


require './mipsops'
require './mipscoderunner'
require './mipsassembler'

class Mips32Error < StandardError
end

# Implements a strict stack
class Stack
  def initialize
    @store = []
  end
  def push(x)
    @store.push(x)
  end
  def pop
    @store.pop
  end
  def peek
    @store.last
  end
end

# Implements the Mips32 memory structure
class Memory
  attr_accessor :core, :data, :stack, :symbol_table
  def initialize()
    @core = {}          # Global memory (0x10000000+), heap (0x10040000+)
    @heap_pointer = 0x10040000
    @data = {}          # Program data
    @stack = Stack.new  # Stack
    @symbol_table = {}  # Symbol table
  end
end

# Implements the Mips32 register structure
class Register
  attr_accessor :gen, :spe, :fpr, :pos
  def initialize()
    @gen = {
      :zero => 0x0, :at => 0x0, :v0 => 0x0, :v1 => 0x0, :a0 => 0x0, :a1 => 0x0, :a2 => 0x0, :a3 => 0x0,
        :t0 => 0x0, :t1 => 0x0, :t2 => 0x0, :t3 => 0x0, :t4 => 0x0, :t5 => 0x0, :t6 => 0x0, :t7 => 0x0,
        :s0 => 0x0, :s1 => 0x0, :s2 => 0x0, :s3 => 0x0, :s4 => 0x0, :s5 => 0x0, :s6 => 0x0, :s7 => 0x0,
        :t8 => 0x0, :t9 => 0x0, :k0 => 0x0, :k1 => 0x0, :gp => 0x10000000, :sp => 0x7ffffffc,
        :fp => 0x0, :ra => 0x0 }

    @spe = {
      :pc  => 0x00400000,  # The program counter
      :hi  => 0x0,         # Special register Hi
      :lo  => 0x0,         # Special register Lo
      :epc => 0x0 }        # Exception PC

    # This array keeps track of register positions
    # so we can map, say, '$8' to '$t0'.
    @pos = [:zero, :at, :v0, :v1, :a0, :a1, :a2, :a3,
            :t0, :t1, :t2, :t3, :t4, :t5, :t6, :t7,
            :s0, :s1, :s2, :s3, :s4, :s5, :s6, :s7,
            :t8, :t9, :k0, :k1, :gp, :sp, :fp, :ra]

    # floating-point registers
    @fpr = {
       :f0 => 0x0,  :f1 => 0x0,  :f2 => 0x0,  :f3 => 0x0,  :f4 => 0x0,  :f5 => 0x0,  :f6 => 0x0,  :f7 => 0x0,
       :f8 => 0x0,  :f9 => 0x0, :f10 => 0x0, :f11 => 0x0, :f12 => 0x0, :f13 => 0x0, :f14 => 0x0, :f15 => 0x0,
      :f16 => 0x0, :f17 => 0x0, :f18 => 0x0, :f19 => 0x0, :f20 => 0x0, :f21 => 0x0, :f22 => 0x0, :f23 => 0x0,
      :f24 => 0x0, :f25 => 0x0, :f26 => 0x0, :f27 => 0x0, :f28 => 0x0, :f29 => 0x0, :f30 => 0x0, :f31 => 0x0 }
  end
end

class Mips32
  include MipsOps, MipsCodeRunner, Assembler
  attr_reader :registers, :memory, :fd
  def initialize
    @registers = reset_registers
    @memory = reset_memory
    @fd = {}
    super
  end

  # Dumps a pretty-printed representation of all or a user-specified register
  def dump_registers(which="all")
    if which == "all"
      puts "    General Registers"
      puts sprintf("$zero | %11d |  0x%08x  |  %032s", @registers.gen[:zero], @registers.gen[:zero], "0" * 32)
      @registers.pos[1..-1].each do |name|
        puts sprintf("$%s   | %11d |  0x%08x  |  %032s", name, @registers.gen[name],
                     @registers.gen[name], int_to_bitstring(@registers.gen[name]))
      end
      puts "    Special Registers"
      @registers.spe.each_pair do |k,v|
        puts sprintf("$%s #{k == :epc ? "" : " "} | %11d |  0x%08x  |  %032s", k, v, v, int_to_bitstring(v))
      end
    else
      puts sprintf("$%s   | %11d |  0x%08x  |  %032s", which, @registers.gen[which],
                      @registers.gen[which], int_to_bitstring(@registers.gen[which]))
    end
    true
  end

  # Dumps a pretty-printed representation of all or a user-specified memory address
  def dump_memory(which="all")
    if which == "all"
      k_arr = []
      @memory.core.each_key do |k|
        k_arr << k
      end
      k_arr.sort.each do |a|
        puts sprintf("0x%08x: #{@memory.core[a]}", a)
      end
    else
      puts "#{which}: #{@memory.core[which]}"
    end
    true
  end

  def dump_symbol_table
    @memory.symbol_table.each_pair do |k,v|
      puts sprintf("#{k} => 0x%08x", v)
    end
    true
  end

  # Dumps pretty-printed representation of program data memory
  def dump_program_data
    #@memory.data.each_pair do |k,v|
    #  puts "#{k} => #{v}"
    #end
    k_arr = []
    @memory.data.each_key do |k|
      k_arr << k
    end
    k_arr.sort.each do |a|
      puts sprintf("0x%08x: %-20s %032s", a, @memory.data[a], assemble(@memory.data[a]))
    end
    true
  end

  def reset_registers
    @registers = Register.new
    #true
  end

  def reset_memory
    @memory = Memory.new
    #true
  end

  def reset_all
    @registers = Register.new
    @memory =    Memory.new
    true
  end

  def int_to_bitstring(i)
    if i >= 0
      s = sprintf("%b", i)
      if s.length < 32
        return "0" * (32 - s.length) + s
      end
      s
    else  # Signed value, encode two's compliment.
      s = sprintf("%b", i)[2..-1]
      if s.length < 32
        return "1" * (32 - s.length) + s
      end
      s
    end
  end

  def bitstring_to_int(s, signed=true)
    if signed && s[0].ord == 49
      ~ (flipbits(s).to_i(2) + 1) + 1
    else
      s.to_i(2)
    end
  end

  def inspect #:nodoc:
    "#<#{self.class}:0x#{(self.object_id*2).to_s(16)}\b>"
  end
  
  alias d_reg dump_registers
  alias d_mem dump_memory
  alias d_pro dump_program_data
  alias d_sym dump_symbol_table
  alias itob  int_to_bitstring
  alias btoi  bitstring_to_int
  
  private

  # It flips the bits
  def flipbits(s)
    r = ""
    s.each_byte do |b|
      if b == 48
        r += "1"
      else
        r += "0"
      end
    end
    r
  end
end


# Load a MIPS assembly file, place each line in program data, execute
