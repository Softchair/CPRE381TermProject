-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- bit_extenders.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a the implementation of a sign and zero  
-- bit extension.              
-- 02/14/2024
-------------------------------------------------------------------------



library IEEE;
use IEEE.std_logic_1164.all;





entity bit_extenders is 
   port ( 
         i_Din : in std_logic_vector(15 downto 0);
         o_OUT : out std_logic_vector(31 downto 0);
         SEL : in std_logic);
      
end bit_extenders;





architecture flow of bit_extenders is
--signals 
signal s_int : std_logic_vector(15 downto 0); -- intermediate
begin  
 
  
  with i_Din(15) select
 	s_int <= "0000000000000000" when '0',
                 "1111111111111111" when '1',
                 "0000000000000000" when others;



   with SEL select
 	o_OUT <= "0000000000000000" & i_Din when '0',
                 s_int & i_Din when '1',
                 "0000000000000000" & i_Din when others;
 
end flow;
