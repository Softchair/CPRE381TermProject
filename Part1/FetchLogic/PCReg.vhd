-------------------------------------------------------------------------
-- Camden Fergen
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- PCReg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a register to hold
-- the program counter
--
-- NOTES:
-- Created file - 3/1/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity PCReg is 
    port(
        -- Reg file
        i_CLK      : IN STD_LOGIC; -- Clock
        i_RST       : IN STD_LOGIC; -- Reset, should reset PC to 0x0040...
        -- PC Specific
        i_PC        : IN STD_LOGIC_VECTOR(31 downto 0);  -- Program counter in
        o_PC        : OUT STD_LOGIC_VECTOR(31 downto 0) -- Program counter out
    );
end PCReg;

architecture structural of PCReg is

    component nbitregister is
        generic(N: integer := 32);
        port(
            i_CLK       : IN STD_LOGIC;
            i_RST       : IN STD_LOGIC;
            i_WE        : IN STD_LOGIC;
            i_DataIn    : IN STD_LOGIC_VECTOR(N-1 downto 0);
            o_DataOut   : OUT STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;

    begin
        -- Reg to store PC
        r_PC: nbitregister
            generic map(N => 32)
            port map(
                i_CLK       => i_CLK,
                i_RST       => i_RST,
                i_WE        => '1',
                i_DataIn    => i_PC,
                o_DataOut   => o_PC
            );

end structural;