-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux16_1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32 bit 16:1 mux
--
-- NOTES:
-- 3/4/24
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity mux16_1 is 
   port ( D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11,
          D12, D13, D14, D15 : in std_logic_vector(31 downto 0);
         o_OUT : out std_logic_vector(31 downto 0);
         SEL : in std_logic_vector(3 downto 0));
      
end mux16_1;

architecture mux of mux16_1 is 
begin 
with SEL select 
    o_OUT  <= D0 when "0000",
              D1 when "0001",
	      D2 when "0010",
              D3 when "0011", 
              D4 when "0100",
	      D5 when "0101",
	      D6 when "0110",
              D7 when "0111",
	      D8 when "1000",
              D9 when "1001",
              D10 when "1010",
	      D11 when "1011",
 	      D12 when "1100",
              D13 when "1101",
	      D14 when "1110",
              D15 when "1111",
	      x"00000000" when others;

end mux;
            