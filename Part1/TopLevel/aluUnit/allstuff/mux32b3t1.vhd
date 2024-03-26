-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux32b3t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32 bit 3 to 1 mux 
--
-- NOTES:
-- 3/20/24
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity mux32b3t1 is 
   port ( D0, D1, D2, D3, D4, D5, D6, D7: in std_logic_vector(31 downto 0);
         o_OUT : out std_logic_vector(31 downto 0);
         SEL : in std_logic_vector(2 downto 0));
      
end mux32b3t1;

architecture mux of mux32b3t1 is 
begin 
with SEL select 
    o_OUT  <= D0 when "000",
              D1 when "001",
	      D2 when "010",
              D3 when "011", 
              D4 when "100",
              D5 when "101",
              D6 when "110", 
              D7 when "111",

	      x"00000000" when others;

end mux;
            