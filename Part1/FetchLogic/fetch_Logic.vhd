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
        -- Register inputs
        i_JReg          : IN STD_LOGIC_VECTOR(31 downto 0); -- Jump register input
        i_JalReg        : IN STD_LOGIC_VECTOR(31 downto 0); -- Jump and link register input
        -- Control logic inputs
        i_BranchLogic   : IN STD_LOGIC; -- Branch logic control, 1 if branch
        i_JumpLogic     : IN STD_LOGIC; -- Jump logic control, 1 if jump
        i_JRegLogic     : IN STD_LOGIC; -- Jump register logic control, 1 if jump reg
        i_JalLogic      : IN STD_LOGIC; -- Jump and link logic control, 0 if jump and link CHECK THIS
        -- Ouputs
        o_Instruction   : OUT STD_LOGIC_VECTOR(31 downto 0); -- Instruction output
    );
      
end fetch_Logic;

architecture mixed of fetch_logic is
    
    -- Generic Mux
    component mux2t1N is
        generic (N : integer := 32);
        port (
            i_Sel     : IN STD_LOGIC;
            i_A       : IN STD_LOGIC_VECTOR(N-1 downto 0);
            i_B       : IN STD_LOGIC_VECTOR(N-1 downto 0);
            o_Out     : OUT STD_LOGIC_VECTOR(N-1 downto 0);
        );
    end component;

    -- Signals


    begin
        -- Put together here
