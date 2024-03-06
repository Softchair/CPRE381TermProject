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
    CONSTANT cCLK_PER : TIME := 10 ns;

    -- Component declaration for the fetch_Logic
    COMPONENT fetch_Logic IS
        PORT (
            i_CLK : IN STD_LOGIC;
            i_RST : IN STD_LOGIC;
            i_JReg : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            i_BranchLogic : IN STD_LOGIC;
            i_JumpLogic : IN STD_LOGIC;
            i_JRegLogic : IN STD_LOGIC;
            i_JalLogic : IN STD_LOGIC;
            o_Instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            o_PCAddress : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals to connect to the fetch_Logic component
    SIGNAL s_CLK, s_RST : STD_LOGIC;
    SIGNAL s_JReg : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL s_BranchLogic, s_JumpLogic, s_JRegLogic, s_JalLogic : STD_LOGIC;
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
        i_JalLogic => s_JalLogic,
        o_Instruction => s_Instruction,
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
        s_JalLogic <= '0';
        WAIT FOR cCLK_PER;

        -- Test 1: Normal operation, no branching, jumping, or jump register logic
        s_RST <= '0';
        WAIT FOR cCLK_PER*2;

        -- Test 2: Branch logic activated
        s_BranchLogic <= '1';
        WAIT FOR cCLK_PER*2;

        -- Test 3: Jump logic activated
        s_JumpLogic <= '1';
        WAIT FOR cCLK_PER*2;

        -- Test 4: Jump register logic activated
        s_JRegLogic <= '1';
        WAIT FOR cCLK_PER*2;

        -- Test 5: Jal logic activated
        s_JalLogic <= '1';
        WAIT FOR cCLK_PER*2;

        -- Test 6: Reset and change JReg value
        s_RST <= '1';
        s_JReg <= x"00000080"; -- Set JReg to a specific value
        WAIT FOR cCLK_PER;

        WAIT;
    END PROCESS;

END behavior;
