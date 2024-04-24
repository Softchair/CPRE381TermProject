-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- IF_ID_Reg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the IF/ID pipeline 
-- register
--
-- NOTES:
-- 4/3/24
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY IF_ID_Reg IS
  PORT (
    i_CLK : IN STD_LOGIC;
    i_RST : IN STD_LOGIC;
    i_WE : IN STD_LOGIC;
    -- In Signals
    i_IFID_PC4 : IN STD_LOGIC_VECTOR(31 downto 0); -- PC + 4 (jal)
    i_IFID_Inst : IN STD_LOGIC_VECTOR(31 downto 0); -- Next Instruction
    -- Out Signals
    o_IFID_PC4 : OUT STD_LOGIC_VECTOR(31 downto 0);
    o_IFID_Inst : OUT STD_LOGIC_VECTOR(31 downto 0));
END IF_ID_Reg;

ARCHITECTURE structural OF IF_ID_Reg IS

  COMPONENT dffg IS
    PORT (
      i_CLK : IN STD_LOGIC;
      i_RST : IN STD_LOGIC;
      i_WE : IN STD_LOGIC;
      i_D : IN STD_LOGIC;
      o_Q : OUT STD_LOGIC);
  END COMPONENT;

BEGIN

  -- PC4 dffg
  g_PC4_dffg : FOR i IN 0 TO 31 GENERATE
    dffgi : dffg PORT MAP(
      i_CLK => i_CLK, -- All instances share the same clk
      i_RST => i_RST, -- All instances share the same rst
      i_WE => i_WE, -- All instances share the same WE
      i_D => i_IFID_PC4(i),
      o_Q => o_IFID_PC4(i));
  END GENERATE g_PC4_dffg;

  -- Inst dffg
  g_Inst_dffg : FOR i IN 0 TO 31 GENERATE
    dffgi : dffg PORT MAP(
      i_CLK => i_CLK, -- All instances share the same clk
      i_RST => i_RST, -- All instances share the same rst
      i_WE => i_WE, -- All instances share the same WE
      i_D => i_IFID_Inst(i),
      o_Q => o_IFID_Inst(i));
  END GENERATE g_Inst_dffg;  

END structural;