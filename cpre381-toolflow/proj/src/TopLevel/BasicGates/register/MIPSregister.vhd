-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- MIPSregister.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a MIPS register file
-- using structures
-- NOTES:
-- 2/7/24
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use work.register_package.all;

ENTITY MIPSregister IS
  PORT (
    i_CLK : IN STD_LOGIC;
    i_enable : IN STD_LOGIC;
    i_rd : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    i_rs : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    i_rt : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    i_rdindata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    i_reset : IN STD_LOGIC;
    o_rsOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    o_rtOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );

END MIPSregister;

ARCHITECTURE structure OF MIPSregister IS

  COMPONENT decoder5_32

    PORT (
      D_IN : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
      F_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT dffgN

    PORT (
      i_CLK : IN STD_LOGIC;
      i_RST : IN STD_LOGIC;
      i_WE : IN STD_LOGIC;
      i_D : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      o_Q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));

  END COMPONENT;
  COMPONENT mux32_1

    PORT (
      D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11,
      D12, D13, D14, D15, D16, D17, D18, D19, D20, D21, D22,
      D23, D24, D25, D26, D27, D28, D29, D30, D31 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      o_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      SEL : IN STD_LOGIC_VECTOR(4 DOWNTO 0));

  END COMPONENT;
  COMPONENT andg2

    PORT (
      i_A : IN STD_LOGIC;
      i_B : IN STD_LOGIC;
      o_F : OUT STD_LOGIC);
  END COMPONENT;
  -- Signals
  SIGNAL s_DOUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_ANDOUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R5 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R6 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R7 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R8 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R9 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R10 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R11 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R12 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R13 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R14 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R15 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R16 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R17 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R18 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R19 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R20 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R21 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R22 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R23 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_R24 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_rsOUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_rtOUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_REG : t_bus_32x32;

BEGIN
  -- level 0: the decoder
  g_decoder : decoder5_32
  PORT MAP(
    D_IN => i_rd,
    F_OUT => s_DOUT);

  -- level 1: write enable

  G_NBit_AND : FOR i IN 0 TO 31 GENERATE
    DEC : andg2 PORT MAP(
      i_A => i_enable, -- All instances share the same select input.
      i_B => s_DOUT(i),
      o_F => s_ANDOUT(i)); -- ith instance's data output hooked up to ith data output.
  END GENERATE G_NBit_AND;

  -- Level 2: Registers
  G_NBit_REGISTER : FOR i IN 0 TO 31 GENERATE
    REG : dffgN PORT MAP(
      --    i_CLK        : in std_logic;
      --    i_RST         : in std_logic;
      --    i_WE         : in std_logic;
      --    i_D          : in std_logic_vector(31 downto 0);
      --   o_Q       : out std_logic_vector(31 downto 0));  
      i_CLK => i_CLK, -- All instances share the same select input.
      i_RST => i_reset,
      i_WE => s_ANDOUT(i),
      i_D => i_rdindata,
      o_Q => s_REG(i)); -- ith instance's data output hooked up to ith data output.
  END GENERATE G_NBit_REGISTER;

  -- Level 3: Mux's
  g_mux01 : mux32_1 -- rs mux
  PORT MAP(
    D0 => s_REG(0),
    D1 => s_REG(1),
    D2 => s_REG(2),
    D3 => s_REG(3),
    D4 => s_REG(4),
    D5 => s_REG(5),
    D6 => s_REG(6),
    D7 => s_REG(7),
    D8 => s_REG(8),
    D9 => s_REG(9),
    D10 => s_REG(10),
    D11 => s_REG(11),
    D12 => s_REG(12),
    D13 => s_REG(13),
    D14 => s_REG(14),
    D15 => s_REG(15),
    D16 => s_REG(16),
    D17 => s_REG(17),
    D18 => s_REG(18),
    D19 => s_REG(19),
    D20 => s_REG(20),
    D21 => s_REG(21),
    D22 => s_REG(22),
    D23 => s_REG(23),
    D24 => s_REG(24),
    D25 => s_REG(25),
    D26 => s_REG(26),
    D27 => s_REG(27),
    D28 => s_REG(28),
    D29 => s_REG(29),
    D30 => s_REG(30),
    D31 => s_REG(31),
    o_OUT => o_rsOUT,
    SEL => i_rs);
  g_mux02 : mux32_1 -- rt mux
  PORT MAP(
    D0 => s_REG(0),
    D1 => s_REG(1),
    D2 => s_REG(2),
    D3 => s_REG(3),
    D4 => s_REG(4),
    D5 => s_REG(5),
    D6 => s_REG(6),
    D7 => s_REG(7),
    D8 => s_REG(8),
    D9 => s_REG(9),
    D10 => s_REG(10),
    D11 => s_REG(11),
    D12 => s_REG(12),
    D13 => s_REG(13),
    D14 => s_REG(14),
    D15 => s_REG(15),
    D16 => s_REG(16),
    D17 => s_REG(17),
    D18 => s_REG(18),
    D19 => s_REG(19),
    D20 => s_REG(20),
    D21 => s_REG(21),
    D22 => s_REG(22),
    D23 => s_REG(23),
    D24 => s_REG(24),
    D25 => s_REG(25),
    D26 => s_REG(26),
    D27 => s_REG(27),
    D28 => s_REG(28),
    D29 => s_REG(29),
    D30 => s_REG(30),
    D31 => s_REG(31),
    o_OUT => o_rtOUT,
    SEL => i_rt);
END structure;