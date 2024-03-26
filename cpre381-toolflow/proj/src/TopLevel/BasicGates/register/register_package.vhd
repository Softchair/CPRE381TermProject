-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- register_package.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a package for a bus to use for 
-- the register
-- 2/7/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


package register_package is 
 -- constant four_bit_zero : std_logic_vector := "0000";
  type t_bus_32x32 is array (0 to 31) of std_logic_vector(31 downto 0);
 end package register_package;

