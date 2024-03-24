-------------------------------------------------------------------------
-- Camden Fergen
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_shiftleft2.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Testbench for shiftleft2
entity tb_shiftleft2N is
end tb_shiftleft2N;

architecture behavior of tb_shiftleft2N is
    CONSTANT cCLK_PER : TIME := 10 ns;

    -- Component declaration for the shiftleft2
    component shiftleft2N is
        generic(N : integer := 32);
        port(
            i_In : in std_logic_vector(25 downto 0);
            o_Out : out std_logic_vector(27 downto 0)
        );
    end component;
    
    -- Signals to connect to the shiftleft2 component
    signal s_In : std_logic_vector(25 downto 0);
    signal s_Out : std_logic_vector(27 downto 0);
    SIGNAL s_CLK : std_logic;
    
begin
    -- Instantiate the shiftleft2 component
    DUT: shiftleft2N
    generic map(N => 26)
    port map(
        i_In => s_In,
        o_Out => s_Out
    );

    -- Clock generation process
    P_CLK : PROCESS
    BEGIN
        s_CLK <= '0';
        WAIT FOR cCLK_PER / 2;
        s_CLK <= '1';
        WAIT FOR cCLK_PER / 2;
    END PROCESS;
    
    -- Testbench process
    P_TB: process
    begin
        -- Test case 1: Shift a known value
        s_In <= "00000000000000000000000001"; -- Shift 1 left by 2 bits
        WAIT FOR cCLK_PER;

        -- Test case 2: Shift another known value
        s_In <= "00000000000000000000000100"; -- Shift 4 left by 2 bits
        WAIT FOR cCLK_PER*2;
        
        wait;
    end process;

end behavior;
