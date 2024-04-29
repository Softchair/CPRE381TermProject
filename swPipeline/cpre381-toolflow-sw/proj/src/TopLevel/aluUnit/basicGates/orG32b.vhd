-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- norG32b.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32 bit wide OR gate
--
-- NOTES:
-- 3/19/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
library std;


entity orG32b is
port (
   i_D   : in std_logic_vector(31 downto 0);
   o_Out : out std_logic);
end orG32b;


architecture dataflow of orG32b is 
  begin 
   o_Out <= or_reduce(i_D);
end dataflow;