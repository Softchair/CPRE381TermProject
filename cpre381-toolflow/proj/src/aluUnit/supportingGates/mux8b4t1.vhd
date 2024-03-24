-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux8b4t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 8 bit 4 to 1 mux 
--
-- NOTES:
-- 3/18/24
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity mux8b4t1 is 
   port ( D0, D1, D2, D3: in std_logic_vector(7 downto 0);
         o_OUT : out std_logic_vector(7 downto 0);
         SEL : in std_logic_vector(1 downto 0));
      
end mux8b4t1;

architecture mux of mux8b4t1 is 
begin 
with SEL select 
    o_OUT  <= D0 when "00",
              D1 when "01",
	      D2 when "10",
              D3 when "11", 
	      "00000000" when others;

end mux;
            