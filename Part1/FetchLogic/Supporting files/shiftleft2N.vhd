-------------------------------------------------------------------------
-- Camden Fergen
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- shiftleft2.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of shift left 2
-- NOTES:
-- Created file - 3/1/24
-- Tested on:
-- 3/1/24 By Camden Fergen
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


entity shiftleft2N is
    generic(N : integer := 32); -- Generic
    port(
        i_In        : IN STD_LOGIC_VECTOR(N-1 downto 0);
        o_Out        : OUT STD_LOGIC_VECTOR(N+1 downto 0)
    );
end shiftleft2N;

architecture Behavioral of shiftleft2N is
    
    begin
        
        -- Shifts twice to the left by padding with 0
        o_Out <= std_logic_vector(unsigned(i_In) & "00");
    
end Behavioral;