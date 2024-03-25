-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_bit_extenders.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a test bench for 
-- bit extenders
--
-- NOTES:
-- 2/14/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all; -- For logic types I/O
library std;
use std.env.all; -- For hierarchical/external signals
use std.textio.all; -- For basic I/O


entity tb_bit_extenders is
  generic(gCLK_HPER   : time := 50 ns; N : integer := 32);
end tb_bit_extenders;

architecture behavior of tb_bit_extenders is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component bit_extenders
    port(
         i_Din : in std_logic_vector(15 downto 0);
         o_OUT : out std_logic_vector(31 downto 0);
         SEL : in std_logic);
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_SEL : std_logic;
  signal s_OUT : std_logic_vector(31 downto 0);
  signal s_Din : std_logic_vector(15 downto 0);

begin

  DUT: bit_extenders 
  port map(SEL => s_SEL, 
           o_OUT => s_OUT,
           i_Din => s_Din);




 
P_TEST_CASES: process
  begin
    -- Test cases:
   s_DIn <= x"F00F";
   s_SEL <= '0'; 
   wait for gCLK_HPER;
   s_DIn <= x"000F";
   s_SEL <= '1';
   wait for gCLK_HPER;
   s_DIn <= x"1F0F";
   s_SEL <= '0';
   wait for gCLK_HPER;
   s_DIn <= x"F00F";
   s_SEL <= '1';
wait;
  end process;


  
end behavior;