-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_bit_extenders24b.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a test bench for 
-- bit extenders 24 bit version
--
-- NOTES:
-- 3/18/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all; -- For logic types I/O
library std;
use std.env.all; -- For hierarchical/external signals
use std.textio.all; -- For basic I/O


entity tb_bit_extenders24b is
  generic(gCLK_HPER   : time := 50 ns; N : integer := 32);
end tb_bit_extenders24b;

architecture behavior of tb_bit_extenders24b is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component bit_extenders24b
    port(
         i_Din : in std_logic_vector(7 downto 0);
         o_OUT : out std_logic_vector(31 downto 0);
         SEL : in std_logic);
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_SEL : std_logic;
  signal s_OUT : std_logic_vector(31 downto 0);
  signal s_Din : std_logic_vector(7 downto 0);

begin

  DUT: bit_extenders24b
  port map(SEL => s_SEL, 
           o_OUT => s_OUT,
           i_Din => s_Din);




 
P_TEST_CASES: process
  begin
    -- Test cases:
   s_SEL <= '0';
   s_DIn <= x"0F";
  
   wait for gCLK_HPER;
   s_SEL <= '1';
   s_DIn <= x"0F";
  
   wait for gCLK_HPER;
   s_SEL <= '0';
   s_DIn <= x"FF";
  
   wait for gCLK_HPER;
   s_SEL <= '1';
   s_DIn <= x"FF";

wait;
  end process;

-- expected
-- x0000000F
-- x0000000F
-- x000000FF
-- xFFFFFFFF
  
end behavior;