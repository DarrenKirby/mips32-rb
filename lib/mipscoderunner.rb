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

module MipsCodeRunner

  def load_file(file)
    load_file_into_program_data(file)
    true
  end

  def execute
    num_instructions = @memory.data.length
    while num_instructions > 0
      run_mips_instruction(@memory.data[@registers.spe[:pc]]) # fetch the instruction at the address in the program counter
      @registers.spe[:pc] += 4                                # increase PC to point to next instruction
      num_instructions -= 1
    end
    @registers.gen[:pc] = 0x00400000                          # reset program counter after last instruction runs
    true
  end

  private

  def load_file_into_program_data(file)
    lines = IO.readlines(file)
    lines.each do |line|
      line.sub!(/#.*$/, "")                       # strip inline comments
      line.strip!                                 # remove leading/trailing whitspace
    end
    lines.delete("\n")
    lines.delete("")
    lines = load_variables_into_memory(lines)

    lines.each do |line|
      if line.scan(/\(/) == ["("]                 # check for offset style address
        line.gsub!("(", " ")
        line.gsub!(")", "")

        if line.split.length == 3
          op, middle, address = line.split
          dest, offset = middle.split(",")
          #puts "#{op}, #{dest}, #{offset}, #{address}"
          if address[0] == 36   # check for $
            address.gsub!("$","")
            #puts "#{op} #{dest} #{offset} #{offset.to_i} #{@registers.gen[address.to_sym]}"
            line = "#{op} #{dest},#{offset.to_i + @registers.gen[address.to_sym]}"
          else
            line = "#{op} #{dest},#{offset.to_i + @memory.symbol_table[address]}"
          end

        elsif line.split.length == 2
          op, address = line.split
          if address[0] == "$"
            #address.gsub!("$", ":")
            line = "#{op} #{@registers.gen[address.gsub("$","").to_sym]}"
          else
            line = "#{op} #{@memory.symbol_table[address]}"
          end
        end

      end

      if line.split.length == 1                            # Do we have a label?
        if line == "syscall"
          @memory.data[@registers.spe[:pc]] = line
          @registers.spe[:pc] += 0x4
          next
        end

        if line == "exit"
          #Kernel.exit()
          @memory.data[@registers.spe[:pc]] = "li  $v0,10"
          @memory.data[@registers.spe[:pc]] += 0x4
          @memory.data[@registers.spe[:pc]] = "syscall"
          @memory.data[@registers.spe[:pc]] += 0x4
          next
        end


        label = line[0..-2]                                # remove colon
        @memory.symbol_table[label] = @registers.spe[:pc]
        next
      end

      @memory.data[@registers.spe[:pc]] = line    # place instruction into program data
      @registers.spe[:pc] += 0x4                  # 4byte offset for each address - update program counter
    end
    @registers.spe[:pc] = 0x00400000              # reset the program counter to point to first instruction
  end

  def run_mips_instruction(instruction)
    puts instruction
    #p instruction
    if instruction == "syscall"
      #eval("self.syscall")
      self.send(:syscall)
      return
    end

    op, args = instruction.split(" ")
    if op == "and"                                # special cases for instructions
      op = "and_l"                                # whose names are Ruby keywords
    end
    if op == "or"
      op = "or_l"
    end
    if op == "la"
      args = args.split(",")
      args[0].gsub!("$",":")
      eval("self.#{op} #{args[0]},'#{args[1]}'")
      return true
    end

    if op == "j"
      eval("self.#{op} '#{args}'")
      return true
    end

    3.times do args.gsub!("$",":") end            # at most three operands
    eval("self.#{op} #{args}")                    # build line of executable Ruby code and run it
    return true
  end

  def load_variables_into_memory(lines)
    if lines.index("main:")
      lines.delete_at(lines.index("main:"))
    end
    if lines.index(".data") == nil                # no .data section
      return lines
    end
    if lines.index(".text") == nil                # read til EOF
      data = lines.slice(lines.index(".data"), lines.length)
    else
      data = lines.slice(lines.index(".data"), lines.index(".text") + 1)
    end

    ptr = @registers.gen[:gp]
    data[1..-2].each do |line|
      begin
          #name, type, value = line.split
          name = line.split[0]
          type = line.split[1]
          line.gsub!(name, "")
          line.gsub!(type, "")
          line.strip!
          name.delete!(":")
          if line[0] == 34 # check for "
            line = line[1..-2]
          end
          value = line
          case type
          when ".word"
            @memory.core[ptr] = value
            @memory.symbol_table[name] = ptr
            ptr += 4
          when ".byte"
            @memory.core[ptr] = value
            @memory.symbol_table[name] = ptr
            ptr += 1
          when ".space"
            @memory.core[ptr] = "\0"
            @memory.symbol_table[name] = ptr
            ptr += value.to_i
          when ".ascii"
            @memory.core[ptr] = value[1..-2]
            @memory.symbol_table[name] = ptr
            ptr += value.length
          when ".asciiz"
            @memory.core[ptr] = (value[1..-2] += "\0")
            @memory.symbol_table[name] = ptr
            ptr += (value[1..-2].length + 1)
          end
      rescue NoMethodError
        return lines
      end
    end
    return lines - data
  end
end
