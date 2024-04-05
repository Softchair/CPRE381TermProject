-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- andG32b.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32 bit wide AND gate
--
-- NOTES:
-- 3/18/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
library std;


entity andG32b is
port (
   D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, D16,
   D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28, D29, D30, D31 : in std_logic;
   o_Out : out std_logic);

end andG32b;


architecture dataflow of andG32b is 
  begin 
   o_Out <= D0 AND D1 AND D2 AND D3 AND D4 AND D5 AND D6 AND D7 AND D8 AND D9 AND D10
   AND D11 AND D12 AND D13 AND D14 AND D15 AND D16 AND D17 AND D18 AND D19 AND D20 AND D21
   AND D22 AND D23 AND D24 AND D25 AND D26 AND D27 AND D28 AND D29 AND D30 AND D31;
end dataflow;
