-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_control_Logic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a test bench for 
-- the mips processor control logic unit
--
-- NOTES:
-- 2/29/24
-- Finished testing 3/6/24 - Camden Fergen
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY tb_control_Logic IS
  GENERIC (
    gCLK_HPER : TIME := 10 ns;
    N : INTEGER := 32);
END tb_control_Logic;

ARCHITECTURE behavior OF tb_control_Logic IS

  -- Calculate the clock period as twice the half-period
  CONSTANT cCLK_PER : TIME := gCLK_HPER * 2;
  COMPONENT control_logic
    PORT (
      i_DOpcode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      i_DFunc : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      o_signals : OUT STD_LOGIC_VECTOR(17 DOWNTO 0));

  END COMPONENT;

  -- Temporary signals to connect to the dff component.
  SIGNAL s_opcode : STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL s_Dfunc : STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL s_signalsOut : STD_LOGIC_VECTOR(17 DOWNTO 0);

BEGIN

  DUT : control_logic
  PORT MAP(
    i_DOpcode => s_opcode,
    i_DFunc => s_Dfunc,
    o_signals => s_signalsOut);
  P_TEST_CASES : PROCESS
  BEGIN

    -- Test cases:

    -- Testing addi - basic
    s_opcode <= "001000";
    -- Expecting: 100011000000000110
    wait for cClk_per*2;
    assert (s_signalsOut="100011000000000110") report "Basic addi failed" severity error;

    -- Testing addi - random dfunc
    s_opcode <= "001000";
    s_dfunc  <= "000100";
    -- Expecting: 100011000000000110
    wait for cClk_per*2;
    assert (s_signalsOut="100011000000000110") report "Random dfunc addi failed" severity error;


    -- Testing add - correct dfunc
    s_opcode <= "000000";
    s_dfunc  <= "010100";
    -- Expecting: 000010000000000110
    wait for cClk_per*2;
    assert (s_signalsOut="000010000000000110") report "add correct dfunc failed" severity error;


    -- Testing addiu - basic
    s_opcode <= "001001";
    -- Expecting: 100011000000000010
    wait for cClk_per*2;
    assert (s_signalsOut="100011000000000010") report "addiu basic failed" severity error;


    -- Testing addiu - radnom dfunc
    s_opcode <= "001001";
    s_dfunc  <= "010101";
    -- Expecting: 100011000000000010
    wait for cClk_per*2;
    assert (s_signalsOut="100011000000000010") report "addiu random dfunc failed" severity error;

    -- Testing addu - basic
    s_opcode <= "000000";
    s_dfunc  <= "010101";
    -- Expecting: 100010000000000010
    wait for cClk_per*2;
    assert (s_signalsOut="100010000000000010") report "addu basic failed" severity error;

    -- AI

    -- Testing and - correct dfunc
    s_opcode <= "000000";
    s_dfunc <= "011000";
    -- Expecting: 000010000000001000
    wait for cClk_per*2;
    assert (s_signalsOut="000010000000001000") report "and correct dfunc failed" severity error;

    -- Testing andi - basic
    s_opcode <= "001100";
    -- Expecting: 100011000000001000
    wait for cClk_per*2;
    assert (s_signalsOut="100011000000001000") report "andi basic failed" severity error;

    -- Testing lui - basic
    s_opcode <= "001111";
    -- Expecting: 000011000000010000
    wait for cClk_per*2;
    assert (s_signalsOut="000011000000010000") report "lui basic failed" severity error;

    -- Testing lw - basic
    s_opcode <= "100111";
    -- Expecting: 101011000000000010
    wait for cClk_per*2;
    assert (s_signalsOut="101011000000000010") report "lw basic failed" severity error;

    -- Testing nor - correct dfunc
    s_opcode <= "000000";
    s_dfunc <= "100111";
    -- Expecting: 000010000000011000
    wait for cClk_per*2;
    assert (s_signalsOut="000010000000011000") report "nor correct dfunc failed" severity error;

    -- Testing xor - correct dfunc
    s_opcode <= "000000";
    s_dfunc <= "100110";
    -- Expecting: 000010000000100000
    wait for cClk_per*2;
    assert (s_signalsOut="000010000000100000") report "xor correct dfunc failed" severity error;

    -- Testing xori - basic
    s_opcode <= "001110";
    -- Expecting: 100011000000100000
    wait for cClk_per*2;
    assert (s_signalsOut="100011000000100000") report "xori basic failed" severity error;

    -- Testing or - correct dfunc
    s_opcode <= "000000";
    s_dfunc <= "100101";
    -- Expecting: 000010000000101000
    wait for cClk_per*2;
    assert (s_signalsOut="000010000000101000") report "or correct dfunc failed" severity error;

    -- Testing ori - basic
    s_opcode <= "001101";
    -- Expecting: 100011000000101000
    wait for cClk_per*2;
    assert (s_signalsOut="100011000000101000") report "ori basic failed" severity error;

    -- Testing slt - correct dfunc
    s_opcode <= "000000";
    s_dfunc <= "101010";
    -- Expecting: 010010000000110000
    wait for cClk_per*2;
    assert (s_signalsOut="010010000000110000") report "slt correct dfunc failed" severity error;

    -- Testing slti - basic
    s_opcode <= "001010";
    -- Expecting: 110011000000110010
    wait for cClk_per*2;
    assert (s_signalsOut="110011000000110010") report "slti basic failed" severity error;

    -- Testing sll (excluding don't cares) - basic
    s_opcode <= "000000";
    s_dfunc <= "000000";
    -- Expecting: 000010000000111000
    wait for cClk_per*2;
    assert (s_signalsOut="000010000000111000") report "sll (excluding don't cares) basic failed" severity error;

    -- Testing srl - correct dfunc
    s_opcode <= "000000";
    s_dfunc <= "000010";
    -- Expecting: 000010000001000000
    wait for cClk_per*2;
    assert (s_signalsOut="000010000001000000") report "srl correct dfunc failed" severity error;

    -- Testing sra - correct dfunc
    s_opcode <= "000000";
    s_dfunc <= "000011";
    -- Expecting: 000010000001001000
    wait for cClk_per*2;
    assert (s_signalsOut="000010000001001000") report "sra correct dfunc failed" severity error;

    -- Testing sw - basic
    s_opcode <= "101011";
    -- Expecting: 100100000000000010
    wait for cClk_per*2;
    assert (s_signalsOut="100100000000000010") report "sw basic failed" severity error;

    -- Testing sub - correct dfunc
    s_opcode <= "000000";
    s_dfunc <= "100010";
    -- Expecting: 010010000000000100
    wait for cClk_per*2;
    assert (s_signalsOut="010010000000000100") report "sub correct dfunc failed" severity error;

    -- Testing subu - basic
    s_opcode <= "000000";
    s_dfunc <= "100011";
    -- Expecting: 010010000000000000
    wait for cClk_per*2;
    assert (s_signalsOut="010010000000000000") report "subu basic failed" severity error;

    -- Testing beq - basic
    s_opcode <= "000100";
    -- Expecting: 010000100000000000
    wait for cClk_per*2;
    assert (s_signalsOut="010000100000000000") report "beq basic failed" severity error;

    -- Testing bne - basic
    s_opcode <= "000101";
    -- Expecting: 010000010000000000
    wait for cClk_per*2;
    assert (s_signalsOut="010000010000000000") report "bne basic failed" severity error;

    -- Testing j - basic
    s_opcode <= "000010";
    -- Expecting: 000000001000000000
    wait for cClk_per*2;
    assert (s_signalsOut="000000001000000000") report "j basic failed" severity error;

    -- Testing jal - basic
    s_opcode <= "000011";
    -- Expecting: 000010001100000000
    wait for cClk_per*2;
    assert (s_signalsOut="000010001100000000") report "jal basic failed" severity error;

    -- Testing jr - basic
    s_opcode <= "000000";
    s_dfunc <= "001000";
    -- Expecting: 000000000010000000
    wait for cClk_per*2;
    assert (s_signalsOut="000000000010000000") report "jr basic failed" severity error;

    -- Testing lb - basic
    s_opcode <= "100000";
    -- Expecting: 101011000000000010
    wait for cClk_per*2;
    assert (s_signalsOut="101011000000000010") report "lb basic failed" severity error;

    -- Testing lh - basic
    s_opcode <= "100001";
    -- Expecting: 101011000000000010
    wait for cClk_per*2;
    assert (s_signalsOut="101011000000000010") report "lh basic failed" severity error;

    -- Testing lbu - basic
    s_opcode <= "100100";
    -- Expecting: 101011000000000000
    wait for cClk_per*2;
    assert (s_signalsOut="101011000000000000") report "lbu basic failed" severity error;

    -- Testing lhu - basic
    s_opcode <= "100101";
    -- Expecting: 101011000000000000
    wait for cClk_per*2;
    assert (s_signalsOut="101011000000000000") report "lhu basic failed" severity error;

    -- Testing sllv - correct dfunc
    s_opcode <= "000000";
    s_dfunc <= "000100";
    -- Expecting: 000010000000111001
    wait for cClk_per*2;
    assert (s_signalsOut="000010000000111001") report "sllv correct dfunc failed" severity error;

    -- Testing srlv - correct dfunc
    s_opcode <= "000000";
    s_dfunc <= "000110";
    -- Expecting: 000010000001000001
    wait for cClk_per*2;
    assert (s_signalsOut="000010000001000001") report "srlv correct dfunc failed" severity error;

    -- Testing srav - correct dfunc
    s_opcode <= "000000";
    s_dfunc <= "000111";
    -- Expecting: 000010000001001001
    wait for cClk_per*2;
    assert (s_signalsOut="000010000001001001") report "srav correct dfunc failed" severity error;

    -- Testing random
    s_opcode <= "101010";
    s_dfunc <= "000111";
    -- Expecting: 000010000001001001
    wait for cClk_per*2;
    assert (s_signalsOut="000000000000000000") report "random test failed" severity error;


    report "Testbench of control logic completely successfully!" severity note;

    WAIT;
  END PROCESS;

END behavior;