-------------------------------------------------------------------------
-- Camden Fergen
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Adder1b IS

  PORT (
    iA : IN STD_LOGIC;
    iB : IN STD_LOGIC;
    iC : IN STD_LOGIC;
    oS : OUT STD_LOGIC;
    oC : OUT STD_LOGIC);

END Adder1b;

ARCHITECTURE structural OF Adder1b IS

  -- Defining components of the system
  COMPONENT andg2 IS
    PORT (
      i_A : IN STD_LOGIC;
      i_B : IN STD_LOGIC;
      o_F : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT xorg2 IS
    PORT (
      i_A : IN STD_LOGIC;
      i_B : IN STD_LOGIC;
      o_F : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT org2 IS
    PORT (
      i_A : IN STD_LOGIC;
      i_B : IN STD_LOGIC;
      o_F : OUT STD_LOGIC);
  END COMPONENT;

  -- Signal to carry output of xorgAB
  SIGNAL s_xorgAB : STD_LOGIC;
  -- Signal to carry output of andCAB
  SIGNAL s_andCAB : STD_LOGIC;
  SIGNAL s_andAB : STD_LOGIC;

BEGIN

  --Layer 0
  g_xorgAB : xorg2
  PORT MAP(
    i_A => iA,
    i_B => iB,
    o_F => s_xorgAB);

  --Layer 1
  g_andCAB : andg2
  PORT MAP(
    i_A => s_xorgAB,
    i_B => iC,
    o_F => s_andCAB);

  g_andAB : andg2
  PORT MAP(
    i_A => iA,
    i_B => iB,
    o_F => s_andAB);

  --Layer 2
  g_xorgCGAB : xorg2
  PORT MAP(
    i_A => s_xorgAB,
    i_B => iC,
    o_F => oS);

  g_orAND : org2
  PORT MAP(
    i_A => s_andCAB,
    i_B => s_andAB,
    o_F => oC);

END structural;