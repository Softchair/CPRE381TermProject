-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux32_1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32 bit 32:1 mux
--
-- NOTES:
-- 2/4/24
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity mux32_1 is 
   port ( D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11,
          D12, D13, D14, D15, D16, D17, D18, D19, D20, D21, D22,
          D23, D24, D25, D26, D27, D28, D29, D30, D31 : in std_logic_vector(31 downto 0);
         o_OUT : out std_logic_vector(31 downto 0);
         SEL : in std_logic_vector(4 downto 0));
      
end mux32_1;

architecture mux of mux32_1 is 
begin 
with SEL select 
    o_OUT  <= x"00000000" when "00000",
              D1 when "00001",
	      D2 when "00010",
              D3 when "00011", 
              D4 when "00100",
	      D5 when "00101",
	      D6 when "00110",
              D7 when "00111",
	      D8 when "01000",
              D9 when "01001",
              D10 when "01010",
	      D11 when "01011",
 	      D12 when "01100",
              D13 when "01101",
	      D14 when "01110",
              D15 when "01111",
              D16 when "10000",
	      D17 when "10001",
	      D18 when "10010",
	      D19 when "10011", 
              D20 when "10100",
	      D21 when "10101",
	      D22 when "10110",
              D23 when "10111",
	      D24 when "11000",
              D25 when "11001",
              D26 when "11010",
	      D27 when "11011",
 	      D28 when "11100",
              D29 when "11101",
	      D30 when "11110",
              D31 when "11111",
	      x"00000000" when others;

end mux;
            