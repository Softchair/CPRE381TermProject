-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux16b2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 16 bit 2 to 1 mux 
--
-- NOTES:
-- 3/18/24
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity mux16b2t1 is 
   port ( D0, D1: in std_logic_vector(15 downto 0);
         o_OUT : out std_logic_vector(15 downto 0);
         SEL : in std_logic);
      
end mux16b2t1;

architecture mux of mux16b2t1 is 
begin 
with SEL select 
    o_OUT  <= D0 when '0',
              D1 when '1', 
	      "0000000000000000" when others;

end mux;
            