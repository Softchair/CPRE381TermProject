-------------------------------------------------------------------------
-- Camden Fergen
-------------------------------------------------------------------------

-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of 1bit 2to1Mux
--
--
-- NOTES:
-- 1/24/24 - Created file
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY mux2t1 IS
  PORT (
    i_A   : IN STD_LOGIC;
    i_B   : IN STD_LOGIC;
    i_Sel : IN STD_LOGIC;
    o_Out : OUT STD_LOGIC);
END mux2t1;

ARCHITECTURE structure OF mux2t1 IS

  -- Describing the component entities
  COMPONENT andg2
    PORT (
      i_A : IN STD_LOGIC;
      i_B : IN STD_LOGIC;
      o_F : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT org2
    PORT (
      i_A : IN STD_LOGIC;
      i_B : IN STD_LOGIC;
      o_F : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT invg
    PORT (
      i_A : IN STD_LOGIC;
      o_F : OUT STD_LOGIC);
  END COMPONENT;

  -- Signal to carray and1 to or
  SIGNAL s_and1 : STD_LOGIC;
  -- Signal to carray and2 to or
  SIGNAL s_and2 : STD_LOGIC;
  -- Signal to carray not to and2
  SIGNAL s_not1 : STD_LOGIC;

  -- Start of actual design file
BEGIN

  --Layer 0
  g_not1 : invg
  PORT MAP(
    i_A => i_Sel,
    o_F => s_not1);

  --Layer 1
  g_and1 : andg2
  PORT MAP(
    i_A => i_A,
    i_B => s_not1,
    o_F => s_and1);

  g_and2 : andg2
  PORT MAP(
    i_A => i_B,
    i_B => i_Sel,
    o_F => s_and2);

  --layer 2
  g_or1 : org2
  PORT MAP(
    i_A => s_and1,
    i_B => s_and2,
    o_F => o_Out);

END structure;