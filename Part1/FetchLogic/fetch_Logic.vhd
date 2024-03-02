-------------------------------------------------------------------------
-- Camden Fergen
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- fetch_Logic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the fetch logic
-- for a basic MIPS CPU
--
-- NOTES:
-- Created file - 3/1/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity fetch_Logic is 
    port (
        i_CLK           : IN STD_LOGIC; -- Clock
        i_RST           : IN STD_LOGIC; -- Reset
        -- Register inputs
        i_JReg          : IN STD_LOGIC_VECTOR(31 downto 0); -- Jump register input
        -- Control logic inputs
        i_BranchLogic   : IN STD_LOGIC; -- Branch logic control, 1 if branch
        i_JumpLogic     : IN STD_LOGIC; -- Jump logic control, 1 if jump
        i_JRegLogic     : IN STD_LOGIC; -- Jump register logic control, 1 if jump reg
        i_JalLogic      : IN STD_LOGIC; -- Jump and link logic control, 0 if jump and link CHECK THIS
        -- Ouputs
        o_Instruction   : OUT STD_LOGIC_VECTOR(31 downto 0); -- Instruction output
        o_PCAddress     : OUT STD_LOGIC_VECTOR(31 downto 0) -- PC Address for JAL box
    );
      
end fetch_Logic;

architecture mixed of fetch_logic is

    -- PCReg
    component PCReg is
        port (
            i_CLK       : IN STD_LOGIC; -- Clock
            i_RST       : IN STD_LOGIC; -- Reset
            i_PC        : IN STD_LOGIC_VECTOR(31 downto 0); -- PC in
            o_PC        : OUT STD_LOGIC_VECTOR(31 downto 0) -- PC Out
        );
    end component;

    -- Adder
    component rippleCarryAdderN is
        generic (N : integer := 32);
        port (
            i_A          : in std_logic_vector(N-1 downto 0);
            i_B          : in std_logic_vector(N-1 downto 0);
            i_Cin        : in std_logic;
            o_Cout       : out std_logic;
            o_S          : out std_logic_vector(N-1 downto 0)
        );
    end component;

    component shiftLeft2N is
        generic (N : integer := 32);
        port(
            i_In    : IN STD_LOGIC_VECTOR(N-1 downto 0);
            o_Out   : OUT STD_LOGIC_VECTOR(N-1 downto 0)
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

    -- Signals

    -- Signal to hold the PC address out of the PC register
    signal s_PCAddressOut       : STD_LOGIC_VECTOR(31 downto 0);
    -- Next PC address
    signal s_PCNext             : STD_LOGIC_VECTOR(31 downto 0);
    -- To store top 4 bits of PCNext
    signal s_PCNextTop4         : STD_LOGIC_VECTOR(31 downto 0);
    -- Signal to carry the instruction out
    signal s_InstructionOut     : STD_LOGIC_VECTOR(31 downto 0);
    -- Jump address without top 4 bits
    signal s_JumpAddressPreAdd  : STD_LOGIC_VECTOR(27 downto 0);
    -- Calculated jump address
    signal s_JumpAddress        : STD_LOGIC_VECTOR(31 downto 0);
    -- Signal to carry the jump address mux output
    signal s_JumpAddMuxOut      : STD_LOGIC_VECTOR(31 downto 0);
    -- Signal to carry the jump register mux output
    signal s_JumpRegMuxOut      : STD_LOGIC_VECTOR(31 downto 0);

    signal placeholder          : std_logic_vector(31 downto 0) := (others => '0');


    begin
        
        -- PCReg file
        r_PCReg: PCReg
            port map(
                i_CLK   => i_CLK,
                i_RST   => i_RST,
                i_PC    => s_JumpRegMuxOut,
                o_PC    => s_PCAddressOut
            );

        -- Get next PC address
        -- Adding 4
        g_NextPC: rippleCarryAdderN
            generic map(N => 32)
            port map(
                i_A     => s_PCAddressOut,
                i_B     => x"0004",
                i_Cin   => '0', -- No input
                o_Cout  => open, -- Output to nothing
                o_S     => s_PCNext
            );

        -- Instruction memory
        -- INSERT HERE



        -- -------- START JUMP LOGIC CONTROL -------- --

        -- Shift left 2 for jump address
        -- In 26 bits, out 28 bits
        g_jShiftLeft: shiftLeft2N
            generic map(N => 26)
            port map(
                -- Take only 26 bits
                i_In    => s_InstructionOut(25 downto 0),
                o_Out   => s_JumpAddressPreAdd
            );

        -- Grabbing only the top 4
        s_PCNextTop4 <= s_PCNext(31 downto 28) & "0000000000000000000000000000";

        -- Adder to add top 4 bits of PC to get full jump address
        g_jAdd: rippleCarryAdderN
            generic map(N => 32)
            port map(
                i_A     => s_JumpAddressPreAdd,
                i_B     => s_PCNextTop4, -- Take top 4 bits
                i_Cin   => '0', -- No input
                o_Cout  => open, -- Output to nothing
                o_S     => s_JumpAddress
            );

        -- -------- END JUMP LOGIC CONTROL -------- --

        -- ------ START BRANCH LOGIC CONTROL ------ --


        
        -- ------- END BRANCH LOGIC CONTROL ------- --

        -- ------ START ENDING LOGIC CONTROL ------ --

        -- Mux to control jump address for next PC
        g_jumpMuxControl: mux2t1N
            generic map(N => 32)
            port map(
                i_A     => placeholder, -- From branch logic (0)
                i_B     => s_JumpAddress, -- From jump logic (1)
                i_Sel   => i_JumpLogic, -- From control
                o_Out   => s_JumpAddMuxOut
            );

        -- Mux to control jump register address
        g_jumpRegControl: mux2t1N
            generic map(N => 32)
            port map(
                i_A     => s_JumpAddMuxOut, -- (0)
                i_B     => i_JReg, -- Jump register output (1)
                i_Sel   => i_JRegLogic, -- From control
                o_Out   => s_JumpRegMuxOut
            );

        -- Also assign the out of PC address to the result of jump reg control
        o_PCAddress <= s_JumpRegMuxOut;

        -- ------- END ENDING LOGIC CONTROL ------- --

end mixed;