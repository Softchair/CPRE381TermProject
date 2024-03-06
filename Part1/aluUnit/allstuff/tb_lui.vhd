-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_lui.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for lui
--              
-- 03/6/2024
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all; -- For logic types I/O
library std;
use std.env.all; -- For hierarchical/external signals
use std.textio.all; -- For basic I/O


entity tb_lui is
 
  generic(gCLK_HPER   : time := 10 ns; N : integer := 32);   -- Generic for half of the clock cycle period
end tb_lui;



architecture mixed of tb_lui is
-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;


component lui is

port(
     i_Din : in std_logic_vector(15 downto 0);
     o_OUT : out std_logic_vector(31 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';


-- outside wires
signal s_A      : std_logic_vector(15 downto 0);
signal s_O            : std_logic_vector(31 downto 0);



begin 

DUT0: lui
  port map(

            i_Din        => s_A,
            o_OUT        => s_O);


P_TEST_CASES: process
  begin
    -- Test case 1:
    -- 
    s_A  <= "0000000000000000";  
    wait for gCLK_HPER*2;
    s_A  <= "0001111000000000";  
    wait for gCLK_HPER*2;
    s_A  <= "1111111111111111";  
    wait for gCLK_HPER*2;
    s_A  <= "1110001010100101";  
   wait for gCLK_HPER*2;
    s_A  <= "1111000000001110";  

  
    -- Expect:
    -- 00000000000000000000000000000000

    -- 00011110000000000000000000000000

    -- 11111111111111110000000000000000

    -- 11100010101001010000000000000000

    -- 11110000000011100000000000000000



  


wait;
  end process;

end mixed;