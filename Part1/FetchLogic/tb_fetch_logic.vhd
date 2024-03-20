-------------------------------------------------------------------------
-- Camden Fergen
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_fetch_Logic.vhd
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

-- Testbench for fetch_Logic
ENTITY tb_fetch_Logic IS
END tb_fetch_Logic;

ARCHITECTURE behavior OF tb_fetch_Logic IS
    -- Define a constant for the clock period
    CONSTANT cCLK_PER : TIME := 20 ns;

    -- Component declaration for the fetch_Logic
    COMPONENT fetch_Logic IS
        PORT (
            i_CLK : IN STD_LOGIC;
            i_RST : IN STD_LOGIC;
            i_JReg : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            i_BranchLogic : IN STD_LOGIC;
            i_JumpLogic : IN STD_LOGIC;
            i_JRegLogic : IN STD_LOGIC;
            i_Instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            o_PCAddress : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals to connect to the fetch_Logic component
    SIGNAL s_CLK, s_RST : STD_LOGIC;
    SIGNAL s_JReg : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL s_BranchLogic, s_JumpLogic, s_JRegLogic : STD_LOGIC;
    SIGNAL s_Instruction : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL s_PCAddress : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    -- Instantiate the fetch_Logic component
    DUT : fetch_Logic
    PORT MAP(
        i_CLK => s_CLK,
        i_RST => s_RST,
        i_JReg => s_JReg,
        i_BranchLogic => s_BranchLogic,
        i_JumpLogic => s_JumpLogic,
        i_JRegLogic => s_JRegLogic,
        i_Instruction => s_Instruction,
        o_PCAddress => s_PCAddress
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
        -- Reset the fetch_Logic
        s_RST <= '1';
        s_JReg <= (OTHERS => '0'); -- Initialize JReg to 0
        s_BranchLogic <= '0';
        s_JumpLogic <= '0';
        s_JRegLogic <= '0';
        WAIT FOR cCLK_PER*2;

        -- Testing PC + 4
        assert (s_PCAddress=x"00000044") report "Basic PC + 4 failed" severity error;

        -- Basic jump logic test
        s_JumpLogic <= '1';
        s_Instruction <= "00000000110000000000000000000000";
        WAIT FOR cCLK_PER;
        assert (s_PCAddress=x"03000000") report "Basic jump test failed" severity error;

        -- Reset
        s_Instruction <= (OTHERS => '0');
        s_JumpLogic <= '0';

        -- Jump register logic activated test
        s_JRegLogic <= '1';
        s_JReg <= x"00000088";
        WAIT FOR cCLK_PER*2;
        assert (s_PCAddress=x"00000088") report "Basic jump register test failed" severity error;

        -- Reset
        s_JReg <= (OTHERS => '0');
        s_JRegLogic <= '0';

        -- Branch logic activated test
        s_BranchLogic <= '1';
        s_Instruction <= "00000000000000000000000000001100";
        WAIT FOR cCLK_PER*2;
        assert (s_PCAddress="00000000000000000000000001110100") report "Basic jump register test failed" severity error;

        -- Reset the fetch_Logic
        s_RST <= '1';
        s_JReg <= (OTHERS => '0'); -- Initialize JReg to 0
        s_BranchLogic <= '0';
        s_JumpLogic <= '0';
        s_JRegLogic <= '0';
        WAIT FOR cCLK_PER;

        -- -- Normal operation test
        -- s_RST <= '0';
        -- WAIT FOR cCLK_PER*2;

        -- -- Simulate addi $a0, $0, 1
        -- s_Instruction <= x"20040001";
        -- WAIT FOR cCLK_PER*2;

        -- -- Simulate j next (jump to addr 0x0008)
        -- s_JumpLogic <= '1';
        -- WAIT FOR cCLK_PER*2;

        -- -- Simulate j skip1 (jump to addr 0x0010)
        -- s_JumpLogic <= '1';
        -- WAIT FOR cCLK_PER*2;

        -- -- Simulate add $a0, $a0, $a0
        -- s_Instruction <= x"00842020";
        -- WAIT FOR cCLK_PER*2;

        -- -- Simulate j skip2 (jump to addr 0x001C)
        -- s_JumpLogic <= '1';
        -- WAIT FOR cCLK_PER*2;

        -- -- Simulate add $a0, $a0, $a0
        -- s_Instruction <= x"00842020";
        -- WAIT FOR cCLK_PER*2;

        -- -- Simulate j skip3 (jump to addr 0x002C)
        -- s_JumpLogic <= '1';
        -- WAIT FOR cCLK_PER*2;

        -- -- Simulate add $a0, $a0, $a0
        -- s_Instruction <= x"00842020";
        -- WAIT FOR cCLK_PER*2;

        -- -- Simulate j loop (jump to addr 0x0020)
        -- s_JumpLogic <= '1';
        -- WAIT FOR cCLK_PER*2;

        report "Testbench of fetch logic completely successfully!" severity note;


        WAIT;
    END PROCESS;


END behavior;
