-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- ID_EX_Reg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the ID/EX pipeline 
-- register
-- NOTES:
-- 4/3/24
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ID_EX_Reg IS
  PORT (
    i_CLK : IN STD_LOGIC;
    i_RST : IN STD_LOGIC;
    i_WE : IN STD_LOGIC;

    -- In Signals
    i_IDEX_PC4 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- PC+4 input
    i_IDEX_RT : IN STD_LOGIC_VECTOR(31 downto 0); -- RT reg data
    i_IDEX_RS : IN STD_LOGIC_VECTOR(31 downto 0); -- RS reg data
    i_IDEX_imm : IN STD_LOGIC_VECTOR(15 downto 0); -- imm value
    i_IDEX_writeAddr : IN STD_LOGIC_VECTOR(4 downto 0); -- Write address
    -- In Control Signals
    i_IDEX_ControlSignal : IN STD_LOGIC_VECTOR(16 downto 0);

    -- Out Signals
    o_IDEX_PC4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    o_IDEX_RT : OUT STD_LOGIC_VECTOR(31 downto 0); -- RT reg data
    o_IDEX_RS : OUT STD_LOGIC_VECTOR(31 downto 0); -- RS reg data
    o_IDEX_imm : OUT STD_LOGIC_VECTOR(15 downto 0); -- imm value
    o_IDEX_writeAddr : OUT STD_LOGIC_VECTOR(4 downto 0); -- Write address
    -- Out Control Signals
    o_IDEX_ControlSignal : OUT STD_LOGIC_VECTOR(16 downto 0));
END ID_EX_Reg;

ARCHITECTURE structural OF ID_EX_Reg IS

  COMPONENT dffg IS
    PORT (
      i_CLK : IN STD_LOGIC;
      i_RST : IN STD_LOGIC;
      i_WE : IN STD_LOGIC;
      i_D : IN STD_LOGIC;
      o_Q : OUT STD_LOGIC);
  END COMPONENT;

  SIGNAL s_InControlSignals : STD_LOGIC_VECTOR(16 downto 0); --holds all control signals
  SIGNAL s_OutControlSignals : STD_LOGIC_VECTOR(16 downto 0); --holds all control signals


BEGIN

  -- PC4 dffg
  g_PC4_dffg : FOR i IN 0 TO 31 GENERATE
    dffgi : dffg PORT MAP(
      i_CLK => i_CLK, -- All instances share the same clk
      i_RST => i_RST, -- All instances share the same rst
      i_WE => i_WE, -- All instances share the same WE
      i_D => i_IDEX_PC4(i),
      o_Q => o_IDEX_PC4(i));
  END GENERATE g_PC4_dffg;

  -- RT dffg
  g_RT_dffg : FOR i IN 0 TO 31 GENERATE
    dffgi : dffg PORT MAP(
      i_CLK => i_CLK, -- All instances share the same clk
      i_RST => i_RST, -- All instances share the same rst
      i_WE => i_WE, -- All instances share the same WE
      i_D => i_IDEX_RT(i),
      o_Q => o_IDEX_RT(i));
  END GENERATE g_RT_dffg;

  -- RS dffg
  g_RS_dffg : FOR i IN 0 TO 31 GENERATE
    dffgi : dffg PORT MAP(
      i_CLK => i_CLK, -- All instances share the same clk
      i_RST => i_RST, -- All instances share the same rst
      i_WE => i_WE, -- All instances share the same WE
      i_D => i_IDEX_RS(i),
      o_Q => o_IDEX_RS(i));
  END GENERATE g_RS_dffg;

  -- imm dffg
  g_imm_dffg : FOR i IN 0 TO 15 GENERATE
    dffgi : dffg PORT MAP(
      i_CLK => i_CLK, -- All instances share the same clk
      i_RST => i_RST, -- All instances share the same rst
      i_WE => i_WE, -- All instances share the same WE
      i_D => i_IDEX_imm(i),
      o_Q => o_IDEX_imm(i));
  END GENERATE g_imm_dffg;

  -- writeAddr dffg
  g_writeAddr_dffg : FOR i IN 0 TO 4 GENERATE
    dffgi : dffg PORT MAP(
      i_CLK => i_CLK, -- All instances share the same clk
      i_RST => i_RST, -- All instances share the same rst
      i_WE => i_WE, -- All instances share the same WE
      i_D => i_IDEX_writeAddr(i),
      o_Q => o_IDEX_writeAddr(i));
  END GENERATE g_writeAddr_dffg;

  -- Control Signals dffg 16 signals
  g_controlSignals_dffg : FOR i IN 0 TO 16 GENERATE
    dffgi : dffg PORT MAP(
      i_CLK => i_CLK, -- All instances share the same clk
      i_RST => i_RST, -- All instances share the same rst
      i_WE => i_WE, -- All instances share the same WE
      i_D => i_IDEX_ControlSignal(i),
      o_Q => o_IDEX_ControlSignal(i));
  END GENERATE g_controlSignals_dffg;
  
END structural;