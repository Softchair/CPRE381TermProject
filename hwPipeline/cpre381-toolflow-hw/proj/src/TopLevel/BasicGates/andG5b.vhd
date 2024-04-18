-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- andG5b.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 5 bit wide
-- NOTES:
-- 3/19/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
library std;


entity andG5b is
port (
   i_A : in std_logic_vector(4 downto 0);
   i_B : in std_logic_vector(4 downto 0);
   o_F : out std_logic);

end andG5b;


architecture dataflow of andG5b is 
  begin 
   o_F <= '1' when i_A = i_B else '0';
end dataflow;