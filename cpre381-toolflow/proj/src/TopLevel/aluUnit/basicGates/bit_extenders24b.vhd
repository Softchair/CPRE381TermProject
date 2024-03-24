-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- bit_extenders24b.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a the implementation of a sign and zero  
-- bit extension now for 24 bits.              
-- 03/18/2024
-------------------------------------------------------------------------



library IEEE;
use IEEE.std_logic_1164.all;





entity bit_extenders24b is 
   port ( 
         i_Din : in std_logic_vector(7 downto 0);
         o_OUT : out std_logic_vector(31 downto 0);
         SEL : in std_logic);
      
end bit_extenders24b;





architecture flow of bit_extenders24b is
--signals 
signal s_int : std_logic_vector(23 downto 0); -- intermediate
begin  
 
  
  with i_Din(7) select
 	s_int <= "000000000000000000000000" when '0',
                 "111111111111111111111111" when '1',
                 "000000000000000000000000" when others;



   with SEL select
 	o_OUT <= "000000000000000000000000" & i_Din when '0',
                 s_int & i_Din when '1',
                 "000000000000000000000000" & i_Din when others;
 
end flow;