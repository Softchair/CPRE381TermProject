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
library std;


entity orG32b is
port (
   D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, D16,
   D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28, D29, D30, D31 : in std_logic;
   o_Out : out std_logic);

end orG32b;


architecture dataflow of orG32b is 
  begin 
   o_Out <= D0 OR D1 OR D2 OR D3 OR D4 OR D5 OR D6 OR D7 OR D8 OR D9 OR D10
   OR D11 OR D12 OR D13 OR D14 OR D15 OR D16 OR D17 OR D18 OR D19 OR D20 OR D21
   OR D22 OR D23 OR D24 OR D25 OR D26 OR D27 OR D28 OR D29 OR D30 OR D31;
end dataflow;