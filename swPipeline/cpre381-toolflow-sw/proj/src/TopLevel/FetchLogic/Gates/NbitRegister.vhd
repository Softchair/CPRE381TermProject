-------------------------------------------------------------------------
-- Camden Fergen
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY nbitregister IS
  GENERIC (N : INTEGER := 8); -- Default value is 8.
  PORT (
    i_CLK : IN STD_LOGIC; -- Clock input
    i_RST : IN STD_LOGIC; -- Reset input
    i_WE : IN STD_LOGIC; -- Write enable input
    i_DataIn : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0); -- Data value input
    o_DataOut : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)); -- Data value output

END nbitregister;

ARCHITECTURE structural OF nbitregister IS
  COMPONENT dffg IS
    PORT (
      i_CLK : IN STD_LOGIC;
      i_RST : IN STD_LOGIC;
      i_WE : IN STD_LOGIC;
      i_D : IN STD_LOGIC;
      o_Q : OUT STD_LOGIC);
  END COMPONENT;

BEGIN

  gen_dffg : FOR i IN 0 TO N - 1 GENERATE
    g_dffg : dffg
    PORT MAP(
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_WE => i_WE,
      i_D => i_DataIn(i),
      o_Q => o_DataOut(i));
  END GENERATE gen_dffg;

END structural;