-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_mux8b4t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for an 8 bit 4 to 1 mux
--              
-- 03/18/2024
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all; -- For logic types I/O
library std;
use std.env.all; -- For hierarchical/external signals
use std.textio.all; -- For basic I/O


entity tb_mux8b4t1 is
 
  generic(gCLK_HPER   : time := 10 ns; N : integer := 32);   -- Generic for half of the clock cycle period
end tb_mux8b4t1;



architecture mixed of tb_mux8b4t1 is
-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;


component mux8b4t1 is

 
port ( D0, D1, D2, D3: in std_logic_vector(7 downto 0);
         o_OUT : out std_logic_vector(7 downto 0);
         SEL : in std_logic_vector(1 downto 0));
      
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';


-- outside wires
signal s_B      : std_logic_vector(7 downto 0);
signal s_A            : std_logic_vector(7 downto 0);
signal s_C            : std_logic_vector(7 downto 0);
signal s_D            : std_logic_vector(7 downto 0);
signal s_O            : std_logic_vector(7 downto 0);
signal s_SEL            : std_logic_vector(1 downto 0);


begin 

DUT0: mux8b4t1
  port map(

            D0        => s_A,
            D1        => s_B,
            D2        => s_C,
            D3        => s_D,
            o_OUT       => s_O,
            SEL       => s_SEL);


P_TEST_CASES: process
  begin
    -- Test case 1:
    -- 
    s_A  <= "01010010";  
    s_B  <= "10100101";
    s_C  <= "00011100";
    s_D  <= "10000001";
    s_SEL <= "00";
    wait for gCLK_HPER*2;
    s_SEL <= "01";
    wait for gCLK_HPER*2;
    s_SEL <= "10";
    wait for gCLK_HPER*2;
    s_SEL <= "11";
   wait for gCLK_HPER*2;
    s_SEL <= "10";
   wait for gCLK_HPER*2;
 
    -- Expect:
    --01010010
    --10100101
    --00011100
    --10000001
    --00011100
  


wait;
  end process;

end mixed;