-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_onesCompN.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a N bit 2:1 mux (Geneic version)
--              
-- 01/29/2024
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all; -- For logic types I/O
library std;
use std.env.all; -- For hierarchical/external signals
use std.textio.all; -- For basic I/O


entity tb_onesCompN is
 
  generic(gCLK_HPER   : time := 10 ns; N : integer := 32);   -- Generic for half of the clock cycle period
end tb_onesCompN;



architecture mixed of tb_onesCompN is
-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;


component onesCompN is
 generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
port(
     i_A    : in std_logic_vector(N-1 downto 0);
     o_F  : out std_logic_vector(N-1 downto 0)
);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';


-- outside wires
signal s_A      : std_logic_vector(N-1 downto 0);
signal s_O            : std_logic_vector(N-1 downto 0);



begin 

DUT0: onesCompN
  port map(
            i_A        => s_A,
            o_F        => s_O);


P_TEST_CASES: process
  begin
    -- Test case 1:
    -- 
    s_A  <= x"00000000";  
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    s_A  <= x"FFFFFFFF";
    wait for gCLK_HPER*2;
   wait for gCLK_HPER*2;
    -- Expect: Output of FFFFFFFF then output of 00000000

    -- Test case 2:
    -- 
    s_A  <= x"20202020";  
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    s_A <= x"10000000";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
     
   
    -- Expect: Output of DFDFDFDF and then output of EFFFFFFF

    -- Test case 3:
    -- 
    s_A  <= x"43211234";  
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    s_A <= x"12344321";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
   
    -- Expect: Output of BCDEEDCB and then output of EDCBBCDE


wait;
  end process;

end mixed;