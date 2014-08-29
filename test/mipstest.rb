#!/usr/bin/ruby

require "test/unit"
load "mips.rb"

class TestMips < Test::Unit::TestCase

  def setup
    @vm = Mips32.new
  end

  # test registers are initialized correctly
  def test_registers
    assert_equal(0x00400000, @vm.registers.spe[:pc])
    assert_equal(0x10008000, @vm.registers.gen[:gp])
    assert_equal(0x7ffffffc, @vm.registers.gen[:sp])

    assert_equal(0x0, @vm.registers.gen[:zero])
    assert_equal(0x0, @vm.registers.gen[:at])
    assert_equal(0x0, @vm.registers.gen[:v0])
    assert_equal(0x0, @vm.registers.gen[:v1])
    assert_equal(0x0, @vm.registers.gen[:a0])
    assert_equal(0x0, @vm.registers.gen[:a1])
    assert_equal(0x0, @vm.registers.gen[:a2])
    assert_equal(0x0, @vm.registers.gen[:a3])
    assert_equal(0x0, @vm.registers.gen[:t0])
    assert_equal(0x0, @vm.registers.gen[:t2])
    assert_equal(0x0, @vm.registers.gen[:t3])
    assert_equal(0x0, @vm.registers.gen[:t4])
    assert_equal(0x0, @vm.registers.gen[:t5])
    assert_equal(0x0, @vm.registers.gen[:t6])
    assert_equal(0x0, @vm.registers.gen[:t7])
    assert_equal(0x0, @vm.registers.gen[:s0])
    assert_equal(0x0, @vm.registers.gen[:s1])
    assert_equal(0x0, @vm.registers.gen[:s2])
    assert_equal(0x0, @vm.registers.gen[:s3])
    assert_equal(0x0, @vm.registers.gen[:s4])
    assert_equal(0x0, @vm.registers.gen[:s5])
    assert_equal(0x0, @vm.registers.gen[:s6])
    assert_equal(0x0, @vm.registers.gen[:s7])
    assert_equal(0x0, @vm.registers.gen[:t8])
    assert_equal(0x0, @vm.registers.gen[:t9])
    assert_equal(0x0, @vm.registers.gen[:k0])
    assert_equal(0x0, @vm.registers.gen[:k1])
    assert_equal(0x0, @vm.registers.gen[:ra])
    assert_equal(0x0, @vm.registers.gen[:fp])
    assert_equal(0x0, @vm.registers.spe[:hi])
    assert_equal(0x0, @vm.registers.spe[:lo])
    assert_equal(0x0, @vm.registers.spe[:epc])
  end

  def test_memory
    assert_equal({}, @vm.memory.core)
    assert_equal({}, @vm.memory.data)
    assert_equal({}, @vm.memory.symbol_table)
  end

  def test_ops
    @vm.memory.core[0x10008000] = 500
    @vm.memory.core[0x10008004] = 300
    @vm.memory.core[0x10008008] = 50

    # LOAD/STORE INSTRUCTIONS

    # test lw (load word)
    assert(@vm.lw(:t0,0x10008000))
    assert_equal(500, @vm.registers.gen[:t0])

    # test lh (load half word)
    assert(@vm.lh(:t1,0x10008004))
    assert_equal(300, @vm.registers.gen[:t1])

    # test lb (load byte)
    assert(@vm.lb(:t2,0x10008008))
    assert_equal(50, @vm.registers.gen[:t2])

    # test lbu (load byte unsigned)
    assert(@vm.lbu(:s0,0x10008008))
    assert_equal(50, @vm.registers.gen[:s0])

    # test lhu (load half word unsigned)
    assert(@vm.lhu(:t3,0x10008000))
    assert_equal(500, @vm.registers.gen[:t3])

    # test sw (store word)
    assert(@vm.sw(:t3,0x10008008 + 4))
    assert_equal(500, @vm.memory.core[0x10008008 + 4])

    # test shw (store half word)
    assert(@vm.sw(:t2,0x10008008 + 6))
    assert_equal(50, @vm.memory.core[0x10008008 + 6])

    # test sb (store byte)
    assert(@vm.sw(:t2,0x10008008 + 7))
    assert_equal(50, @vm.memory.core[0x10008008 + 7])

    # ARITHMETIC INSTRUCTIONS

    # test add
    assert(@vm.add(:t4,:t0,:t1))
    assert_equal(800, @vm.registers.gen[:t4])

    # test sub (subtract)
    assert(@vm.sub(:t5,:t3,:t2))
    assert_equal(450, @vm.registers.gen[:t5])

    # test addi (add immediate)
    assert(@vm.addi(:t6,:t2,100))
    assert_equal(150, @vm.registers.gen[:t6])

    # test addu (add unsigned)
    assert(@vm.addu(:t7,:t1,:t2))
    assert_equal(350, @vm.registers.gen[:t7])

    # test subu (subtract unsigned)
    assert(@vm.subu(:t8,:t7,:t6))
    assert_equal(200, @vm.registers.gen[:t8])

    # test mult (multiply)

    # test multu (multiply unsigned)
    assert(@vm.multu(:t6,:s0))
    assert_equal(7500, @vm.registers.spe[:lo])
    assert_equal(0, @vm.registers.spe[:hi])

    # test div (divide)
    assert(@vm.div(:t4,:t8))
    assert_equal(4, @vm.registers.spe[:lo])
    assert_equal(0, @vm.registers.spe[:hi])

    # test divu (divide unsigned)
    assert(@vm.divu(:t4,:t6))
    assert_equal(5, @vm.registers.spe[:lo])
    assert_equal(50, @vm.registers.spe[:hi])

    # test mflo (move from lo)
    assert(@vm.mflo(:s1))
    assert_equal(5, @vm.registers.gen[:s1])

    # test mfhi (move from hi)
    assert(@vm.mfhi(:s2))
    assert_equal(50,@vm.registers.gen[:s2])

    # LOGICAL/BITWISE INSTRUCTIONS

    # test and_l (bitwise AND)
    assert(@vm.and_l(:t0,:s2,:s1))
    assert_equal(0 ,@vm.registers.gen[:t0])
    assert(@vm.and_l(:t0,:s2,:s2))
    assert_equal(50 ,@vm.registers.gen[:t0])

    # test andi  (bitwise AND immediate)
    assert(@vm.andi(:t0,:s2,50))
    assert_equal(50 ,@vm.registers.gen[:t0])
    assert(@vm.andi(:t0,:s1,50))
    assert_equal(0,@vm.registers.gen[:t0])

    ## test nor (bitwise NOR)
    #assert(@vm.)
    #assert_equal(,@vm.registers.gen[])
    #
    ## test or_l (bitwise OR)
    #assert(@vm.)
    #assert_equal(,@vm.registers.gen[])
    #
    ## ori (bitwise OR immediate)
    #assert(@vm.)
    #assert_equal(,@vm.registers.gen[])
    #
    ## test sll (shift left logical)
    #assert(@vm.)
    #assert_equal(,@vm.registers.gen[])
    #
    ## test srl (shift right logical)
    #assert(@vm.)
    #assert_equal(,@vm.registers.gen[])

  end

end
