-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_norG_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a N bit nor gate (Generic version)
--              
-- 03/4/2024
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all; -- For logic types I/O
library std;
use std.env.all; -- For hierarchical/external signals
use std.textio.all; -- For basic I/O


entity tb_norG_N is
 
  generic(gCLK_HPER   : time := 10 ns; N : integer := 32);   -- Generic for half of the clock cycle period
end tb_norG_N;



architecture mixed of tb_norG_N is
-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;


component norG_N is
 generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
port(
       i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';


-- outside wires
signal s_B      : std_logic_vector(N-1 downto 0);
signal s_A            : std_logic_vector(N-1 downto 0);
signal s_O            : std_logic_vector(N-1 downto 0);



begin 

DUT0: norG_N
  port map(

            i_A        => s_A,
            i_B        => s_B,
            o_O        => s_O);


P_TEST_CASES: process
  begin
    -- Test case 1:
    -- 
    s_A  <= "00000000000000000000000000000000";  
    s_B  <= "11110000000000000000000000000000";
    wait for gCLK_HPER*2;
    s_A  <= "11000000000000000000000000011100";  
    s_B  <= "11110000000000000000000001110000";
    wait for gCLK_HPER*2;
    s_A  <= "11000000011111111110000000011100";  
    s_B  <= "11110000000011111111110001110000";
    wait for gCLK_HPER*2;
    s_A  <= "11111111111111111111111111111111";  
    s_B  <= "11110000000011111111110001110000";
   wait for gCLK_HPER*2;
    s_A  <= "11111111111111111111111111111111";  
    s_B  <= "11111111111111111111111111111111";
   wait for gCLK_HPER*2;
    s_A  <= "00000000000000000000000000000000";  
    s_B  <= "00000000000000000000000000000000";
    -- Expect:
    -- 00001111111111111111111111111111

    -- 00001111111111111111111110000011

    -- 00001111100000000000001110000011

    -- 00000000000000000000000000000000

    -- 00000000000000000000000000000000

    -- 11111111111111111111111111111111

  


wait;
  end process;

end mixed;