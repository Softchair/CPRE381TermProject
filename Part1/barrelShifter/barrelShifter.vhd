-------------------------------------------------------------------------
-- Camden Fergen
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- barrelShifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a barrel shifter
--
-- NOTES:
-- Created file - 3/6/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity barrelShifter is 
    port (
        i_CLK           : IN STD_LOGIC; -- Clock
    );
      
end barrelShifter;

architecture mixed of barrelShifter is