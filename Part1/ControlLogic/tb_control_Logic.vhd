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
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_control_Logic is
  generic(gCLK_HPER   : time := 50 ns; N : integer := 32);
end tb_control_Logic;

architecture behavior of tb_control_Logic is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component control_logic
    port(
        i_DOpcode : in std_logic_vector(5 downto 0);
         i_DFunc : in std_logic_vector(5 downto 0);
         o_signals : out std_logic_vector(17 downto 0));

  end component;

  -- Temporary signals to connect to the dff component.
  signal s_opcode : std_logic_vector(5 downto 0);
  signal s_func : std_logic_vector(5 downto 0);
  signal s_signalsOut : std_logic_vector(17 downto 0);

begin

  DUT: control_logic 
  port map(i_DOpcode => s_opcode, 
           i_DFunc => s_func,
           o_signals => s_signalsOut);

 
P_TEST_CASES: process
  begin
    -- Test cases:
    

    s_opcode  <= "000000";  
    s_func  <= "010100";  
  
    wait for gCLK_HPER*2;


    s_opcode  <= "001110";  
    s_func  <= "010100";  -- num should not matter

    wait for gCLK_HPER*2;


    s_opcode  <= "000100";  
    s_func  <= "111111";  -- num should not matter


   wait for gCLK_HPER*2;

    s_opcode  <= "000000";  
    s_func  <= "001000";  

    wait for gCLK_HPER*2;

    s_opcode  <= "000000";  
    s_func  <= "000111";  

   wait for gCLK_HPER*2;

    s_opcode  <= "111111";  -- no opcode has this
    s_func  <= "000111";  

   
-- expecting: 000010000000000110 (add), 100011000000100000 xori, 010000100000000000 (beq), 000000000010000000 (jr), 000010000001001001 (srav), 000000000000000000 (nothing)

wait;
  end process;


  
end behavior;