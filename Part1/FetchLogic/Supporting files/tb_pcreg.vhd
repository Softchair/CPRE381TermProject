-------------------------------------------------------------------------
-- Camden Fergen
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_pcreg.vhd
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

-- Testbench for PCReg
ENTITY tb_PCReg IS
END tb_PCReg;

ARCHITECTURE behavior OF tb_PCReg IS
    -- Define a constant for the clock period
    CONSTANT cCLK_PER : TIME := 10 ns;

    -- Component declaration for the PCReg
    COMPONENT PCReg IS
        PORT (
            i_CLK : IN STD_LOGIC;
            i_RST : IN STD_LOGIC;
            i_PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            o_PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals to connect to the PCReg component
    SIGNAL s_CLK, s_RST : STD_LOGIC;
    SIGNAL s_PC_IN, s_PC_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    -- Instantiate the PCReg component
    DUT : PCReg
    PORT MAP(
        i_CLK => s_CLK,
        i_RST => s_RST,
        i_PC => s_PC_IN,
        o_PC => s_PC_OUT
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
    P_TB : PROCESS
    BEGIN
        -- Reset the PCReg
        s_RST <= '1';
        s_PC_IN <= (OTHERS => '0'); -- Initialize PC to 0
        WAIT FOR cCLK_PER;

        -- Test 1
        -- Release reset and set PC to a specific value
        s_RST <= '0';
        s_PC_IN <= x"00000040"; -- Set PC to 0x0040
        WAIT FOR cCLK_PER;

        -- Test 2
        -- Change the PC value to something new
        s_PC_IN <= x"00000080"; -- Set PC to 0x0080
        WAIT FOR cCLK_PER*2;

        WAIT;
    END PROCESS;

END behavior;