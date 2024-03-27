-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_barrelShifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the barrel shifter
--              
-- 03/26/2024
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all; -- For logic types I/O
library std;
use std.env.all; -- For hierarchical/external signals
use std.textio.all; -- For basic I/O


entity tb_barrelShifter is
 
  generic(gCLK_HPER   : time := 10 ns; N : integer := 32);   -- Generic for half of the clock cycle period
end tb_barrelShifter;



architecture mixed of tb_barrelShifter is
-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;


component barrelShifter is

 
port (i_Cin        : in std_logic_vector(31 downto 0);
       i_shamt         : in std_logic_vector(4 downto 0);
       o_Cout       : out std_logic_vector(31 downto 0));
      
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';


-- outside wires
signal s_Cin      : std_logic_vector(31 downto 0);
signal s_shamt            : std_logic_vector(4 downto 0);
signal s_Cout            : std_logic_vector(31 downto 0);



begin 

DUT0: barrelShifter
  port map(

            i_Cin        => s_Cin,
            i_shamt        => s_shamt,
            o_Cout        => s_Cout);


P_TEST_CASES: process
  begin
    -- Test case 1:
    -- 
    s_Cin  <= "00000000000000000000000000000001";
    s_shamt <= "00001";  
    wait for gCLK_HPER*2;
    s_Cin  <= "00000000000000000000000000000001";
    s_shamt <= "00010";  
    wait for gCLK_HPER*2;
    s_Cin  <= "00000000000000000000000000000001";
    s_shamt <= "00011";  
    wait for gCLK_HPER*2;
    s_Cin  <= "00000000000000000000000000000001";
    s_shamt <= "00100";  
    wait for gCLK_HPER*2;
    s_Cin  <= "00000000000000000000000000000001";
    s_shamt <= "00101";  
    wait for gCLK_HPER*2;
    s_Cin  <= "00000000000000000000000000000001";
    s_shamt <= "00110";  
    wait for gCLK_HPER*2;
    s_Cin  <= "00000000000000000000000000000001";
    s_shamt <= "00111";  
    wait for gCLK_HPER*2;
    s_Cin  <= "00000000000000000000000000000001";
    s_shamt <= "01000";  
    wait for gCLK_HPER*2;
    s_Cin  <= "00000000000000000000000000000001";
    s_shamt <= "01001";  
    wait for gCLK_HPER*2;
    s_Cin  <= "00000000000000000000000000010101";
    s_shamt <= "01100"; 
    wait for gCLK_HPER*2;
    s_Cin  <= "10010000000000000000000000000001";
    s_shamt <= "01111";   
    wait for gCLK_HPER*2;
    s_Cin  <= "00000000000000000000000000000001";
    s_shamt <= "10000";  
    wait for gCLK_HPER*2;
    s_Cin  <= "00000000000000000000000000000001";
    s_shamt <= "11100";  
    wait for gCLK_HPER*2;
    s_Cin  <= "00000000000000000000000000000001";
    s_shamt <= "11111";  
    wait for gCLK_HPER*2;


    -- Expect:
    --00000000000000000000000000000010
    --00000000000000000000000000000100
    --00000000000000000000000000001000

  


wait;
  end process;

end mixed;