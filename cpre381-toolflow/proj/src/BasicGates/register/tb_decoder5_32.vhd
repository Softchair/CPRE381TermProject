-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_decoder5_32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a test bench for 
-- a 32 bit decoder
--
-- NOTES:
-- 2/4/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_decoder5_32 is
  generic(gCLK_HPER   : time := 50 ns; N : integer := 32);
end tb_decoder5_32;

architecture behavior of tb_decoder5_32 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component decoder5_32
    port(
         D_IN          : in std_logic_vector(4 downto 0);     -- Data value input
         F_OUT          : out std_logic_vector(31 downto 0));   -- Data value output
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_IN : std_logic_vector(4 downto 0);
  signal s_OUT : std_logic_vector(31 downto 0);

begin

  DUT: decoder5_32 
  port map(D_IN => s_IN, 
           F_OUT => s_OUT);

 
P_TEST_CASES: process
  begin
    -- Test cases:
    
    s_IN  <= "00000";  
  
   
    wait for gCLK_HPER*2;

    s_IN  <= "00100";  

    wait for gCLK_HPER*2;

    s_IN  <= "11111";  

   wait for gCLK_HPER*2;

    s_IN  <= "01100";  

    wait for gCLK_HPER*2;

    s_IN  <= "01111";  

   wait for gCLK_HPER*2;

    s_IN  <= "00011";  
   


wait;
  end process;


  
end behavior;