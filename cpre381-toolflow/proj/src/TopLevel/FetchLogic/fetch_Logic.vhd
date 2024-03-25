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
-- Finished file - 3/6/24
-- Removed memory to be moved outside of fetch - 3/6/24
-- Added PC+4 out for JAL 3/25/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity fetch_Logic is 
    port (
        i_CLK           : IN STD_LOGIC; -- Clock
        i_RST           : IN STD_LOGIC; -- Reset
        -- Register inputs
        i_JReg          : IN STD_LOGIC_VECTOR(31 downto 0); -- Jump register inputz
        -- Control logic inputs
        i_BranchLogic   : IN STD_LOGIC; -- Branch logic control, 1 if branch
        i_JumpLogic     : IN STD_LOGIC; -- Jump logic control, 1 if jump
        i_JRegLogic     : IN STD_LOGIC; -- Jump register logic control, 1 if jump reg
        -- Instruction input
        i_Instruction   : IN STD_LOGIC_VECTOR(31 downto 0); -- Instruction output
        -- Ouput
        o_PCAddress     : OUT STD_LOGIC_VECTOR(31 downto 0); -- PC Address 
        o_jalAdd        : OUT STD_LOGIC_VECTOR(31 downto 0) -- JAL Output
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
        generic (
            NIn     : integer := 30;
            NOut    : integer := 32
        );
        port(
            i_In        : IN STD_LOGIC_VECTOR(NIn-1 downto 0);
            o_Out       : OUT STD_LOGIC_VECTOR(NOut-1 downto 0)
        );
    end component;

    component bit16_extender is
        port(
            i_Sel       : IN STD_LOGIC;
            i_Din       : IN STD_LOGIC_VECTOR(15 downto 0);
            o_Out       : OUT STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    -- Generic Mux
    component mux2t1N is
        generic (N : integer := 32);
        port (
            i_Sel       : IN STD_LOGIC; -- Select bit
            i_A         : IN STD_LOGIC_VECTOR(N-1 downto 0); -- When sel 0
            i_B         : IN STD_LOGIC_VECTOR(N-1 downto 0); -- When sel 1
            o_Out       : OUT STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;

    -- Signal to hold the PC address out of the PC register
    signal s_PCAddressOut       : STD_LOGIC_VECTOR(31 downto 0);

    -- General Signals
    -- Next PC address
    signal s_PCNext             : STD_LOGIC_VECTOR(31 downto 0);

    -- Jump Signals
    -- To store top 4 bits of PCNext
    signal s_PCNextTop4         : STD_LOGIC_VECTOR(31 downto 0);
    -- Jump address without top 4 bits
    signal s_JumpAddressPreAdd  : STD_LOGIC_VECTOR(27 downto 0);
    -- 32 bit of above
    signal s_JumpAddressPreAdd32  : STD_LOGIC_VECTOR(31 downto 0);
    -- Calculated jump address
    signal s_JumpAddress        : STD_LOGIC_VECTOR(31 downto 0);

    -- Branching Signals
    -- Signal to hold the bottom 16 bits of instruction
    signal s_Bottom16Instruct   : STD_LOGIC_VECTOR(15 downto 0);
    -- Signal to carry the output of the bit extender
    signal s_BitExtendOut       : STD_LOGIC_VECTOR(31 downto 0);
    -- Signal to carry output of shift left on branch address
    signal s_BranchShiftLeft    : STD_LOGIC_VECTOR(31 downto 0);
    -- Signal to carry location to branch to
    signal s_BranchLocation     : STD_LOGIC_VECTOR(31 downto 0);
    -- Signal to carry output of branch mux to jump mux
    signal s_BranchMuxOut       : STD_LOGIC_VECTOR(31 downto 0);

    -- Ending Signals
    -- Signal to carry the jump address mux output
    signal s_JumpAddMuxOut      : STD_LOGIC_VECTOR(31 downto 0);
    -- Signal to carry the jump register mux output
    signal s_JumpRegMuxOut      : STD_LOGIC_VECTOR(31 downto 0);

    begin
        
        -- PCReg file
        r_PCReg: PCReg
            port map(
                i_CLK   => i_CLK,
                i_RST   => i_RST,
                i_PC    => s_JumpRegMuxOut, -- New PC
                o_PC    => s_PCAddressOut -- Cur PC
            );

        -- Get next PC address
        -- Adding 4
        g_NextPC: rippleCarryAdderN
            generic map(N => 32)
            port map(
                i_A     => s_PCAddressOut,
                i_B     => x"00000004",
                i_Cin   => '0', -- No input
                o_Cout  => open, -- Output to nothing
                o_S     => s_PCNext -- Next PC
            );

        o_jalAdd <= s_PCNext; -- For JAL add

        -- -------- START JUMP LOGIC CONTROL -------- --

        -- Shift left 2 for jump address
        -- In 26 bits, out 28 bits
        g_jShiftLeft: shiftLeft2N
            generic map(
                NIn     => 26,
                NOut    => 28
            )
            port map(
                -- Take only 26 bits
                i_In    => i_Instruction(25 downto 0), -- Bottom 25 of instruction
                o_Out   => s_JumpAddressPreAdd(27 downto 0) -- To ripple carry
            );

        -- Grabbing only the top 4
        s_PCNextTop4 <= s_PCNext(31 downto 28) & "0000000000000000000000000000";

        -- To fill to 32
        s_JumpAddressPreAdd32 <= "0000" & s_JumpAddressPreAdd;

        -- Adder to add top 4 bits of PC to get full jump address
        g_jAdd: rippleCarryAdderN
            generic map(N => 32)
            port map(
                -- Add zeros to top
                i_A     => s_JumpAddressPreAdd32, -- Jump address before adding top 4
                i_B     => s_PCNextTop4, -- Take top 4 bits
                i_Cin   => '0', -- No input
                o_Cout  => open, -- Output to nothing
                o_S     => s_JumpAddress -- Send to jump control mux
            );

        -- -------- END JUMP LOGIC CONTROL -------- --

        -- ------ START BRANCH LOGIC CONTROL ------ --

        s_Bottom16Instruct <= i_Instruction(15 downto 0);

        -- Extender to make it 32 bits
        g_bitExtender: bit16_extender
            port map(
                i_Sel   => '0', -- TEMP
                i_Din   => s_Bottom16Instruct, -- Take bottom 16 bits
                o_Out   => s_BitExtendOut -- Send to left shift 2
            );

        -- Shift left address by 2
        g_bShiftLeft: shiftLeft2N
            generic map(
                NIn     => 30,
                NOut    => 32
            )
            port map(
                i_In    => s_BitExtendOut(29 downto 0), -- Little hack to not have to remake the shiftLeft2
                o_Out   => s_BranchShiftLeft
            );

        -- Add branch location and PC, as branch is relative
        g_bAddPC: rippleCarryAdderN
            generic map(N => 32)
            port map(
                i_A     => s_PCNext, -- Adding PC location
                i_B     => s_BranchShiftLeft, -- Relative location
                i_Cin   => '0', -- No input
                o_Cout  => open,
                o_S     => s_BranchLocation -- Location to branch to
            );

        g_branchMuxControl: mux2t1N
            generic map(N => 32)
            port map(
                i_A     => s_PCNext, -- Next PC location (0)
                i_B     => s_BranchLocation, -- Branching location (1)
                i_Sel   => i_BranchLogic, -- From control
                o_Out   => s_BranchMuxOut -- To jump mux
            );

        -- ------- END BRANCH LOGIC CONTROL ------- --

        -- ------ START ENDING LOGIC CONTROL ------ --

        -- Mux to control jump address for next PC
        g_jumpMuxControl: mux2t1N
            generic map(N => 32)
            port map(
                i_A     => s_BranchMuxOut, -- From branch logic (0)
                i_B     => s_JumpAddress, -- From jump logic (1)
                i_Sel   => i_JumpLogic, -- From control
                o_Out   => s_JumpAddMuxOut -- To jump reg control
            );

        -- Mux to control jump register address
        g_jumpRegControl: mux2t1N
            generic map(N => 32)
            port map(
                i_A     => i_JReg, -- From output of jump mux (0)
                i_B     => s_JumpAddMuxOut, -- Jump register output (1)
                i_Sel   => i_JRegLogic, -- From control
                o_Out   => s_JumpRegMuxOut -- To PC reg
            );

        -- Also assign the out of PC address to the result of jump reg control
        o_PCAddress <= s_PCaddressOut;
        o_jalAdd  <= s_PCNext; -- NEW
        -- ------- END ENDING LOGIC CONTROL ------- --

end mixed;