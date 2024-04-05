-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_mux16b2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for an 16 bit 2 to 1 mux
--              
-- 03/18/2024
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all; -- For logic types I/O
library std;
use std.env.all; -- For hierarchical/external signals
use std.textio.all; -- For basic I/O
 

entity tb_mux16b2t1 is
 
  generic(gCLK_HPER   : time := 10 ns; N : integer := 32);   -- Generic for half of the clock cycle period
end tb_mux16b2t1;



architecture mixed of tb_mux16b2t1 is
-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;


component mux16b2t1 is

 
port ( D0, D1: in std_logic_vector(15 downto 0);
         o_OUT : out std_logic_vector(15 downto 0);
         SEL : in std_logic);
      
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';


-- outside wires
signal s_B      : std_logic_vector(15 downto 0);
signal s_A            : std_logic_vector(15 downto 0);
signal s_O            : std_logic_vector(15 downto 0);
signal s_SEL            : std_logic;


begin 

DUT0: mux16b2t1
  port map(

            D0        => s_A,
            D1        => s_B,
            o_OUT       => s_O,
            SEL       => s_SEL);


P_TEST_CASES: process
  begin
    -- Test case 1:
    -- 
    s_A  <= "0101001001010010";  
    s_B  <= "0001110000011100";
    s_SEL <= '0';
    wait for gCLK_HPER*2;
    s_SEL <= '1';
    wait for gCLK_HPER*2;
    s_SEL <= '0';

 
    -- Expect:
    --0101001001010010
    --0001110000011100
    --0101001001010010



wait;
  end process;

end mixed;