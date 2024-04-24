-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- orG32b.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32 bit wide AND gate
--
-- NOTES:
-- 3/18/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
library std;


entity orG5b is
port (
   D0, D1, D2, D3, D4 : in std_logic;
   o_Out : out std_logic);

end orG5b;


architecture dataflow of orG5b is 
  begin 
   o_Out <= D0 OR D1 OR D2 OR D3 OR D4;
end dataflow;
