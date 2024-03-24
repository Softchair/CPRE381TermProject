-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- lui.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a the implementation of lui
-- 03/6/2024
-------------------------------------------------------------------------



library IEEE;
use IEEE.std_logic_1164.all;





entity lui is 
   port ( 
         i_Din : in std_logic_vector(15 downto 0);
         o_OUT : out std_logic_vector(31 downto 0));

      
end lui;





architecture flow of lui is
--signals 

begin  
 
 	o_OUT <= i_Din & "0000000000000000";
 
end flow;