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
-- Tested on:
-- 3/1/24 By Camden Fergen
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity PCReg is 
    port(
        -- Reg file
        i_CLK       : IN STD_LOGIC; -- Clock
        i_RST       : IN STD_LOGIC; -- Reset, should reset PC to 0x0040...
        i_WE        : IN STD_LOGIC;
        -- PC Specific
        i_PC        : IN STD_LOGIC_VECTOR(31 downto 0);  -- Program counter in
        o_PC        : OUT STD_LOGIC_VECTOR(31 downto 0) -- Program counter out
    );
end PCReg;

architecture structural of PCReg is

    -- Register file
    component nbitregister is
        generic(N: integer := 32);
        port(
            i_CLK       : IN STD_LOGIC; -- Clock
            i_RST       : IN STD_LOGIC; -- Reset
            i_WE        : IN STD_LOGIC; -- Write enable
            i_DataIn    : IN STD_LOGIC_VECTOR(N-1 downto 0); -- Data in
            o_DataOut   : OUT STD_LOGIC_VECTOR(N-1 downto 0) -- Data out
        );
    end component;

    -- Generic Mux
    component mux2t1N is
        generic (N : integer := 32);
        port (
            i_Sel     : IN STD_LOGIC; -- Select bit
            i_A       : IN STD_LOGIC_VECTOR(N-1 downto 0); -- When sel 0
            i_B       : IN STD_LOGIC_VECTOR(N-1 downto 0); -- When sel 1
            o_Out     : OUT STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;

    -- Mux out signal
    signal s_muxOut       : STD_LOGIC_VECTOR(31 downto 0);

    begin

        -- Layer 0
        -- Mux to decide when reset
        g_Mux2t1N: mux2t1N
            generic map(N => 32)
            port map(
                i_Sel       => i_RST,
                i_A         => i_PC, -- Default in
                i_B         => x"00400000", -- Reset to start memory point
                o_Out       => s_muxOut
            );

        -- Layer 1
        -- Reg to store PC
        r_PC: nbitregister
            generic map(N => 32)
            port map(
                i_CLK       => i_CLK,
                i_RST       => '0',
                i_WE        => i_WE,
                i_DataIn    => s_muxOut,
                o_DataOut   => o_PC
            );

end structural;