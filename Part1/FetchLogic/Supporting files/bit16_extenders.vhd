-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- bit_extenders.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a the implementation of a sign and zero  
-- bit extension.              
-- 02/14/2024
-------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY bit16_extender IS
  PORT (
    i_Sel : IN STD_LOGIC;
    i_Din : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    o_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

END bit16_extender;

ARCHITECTURE flow OF bit16_extender IS
  --signals 
  SIGNAL s_int : STD_LOGIC_VECTOR(15 DOWNTO 0); -- intermediate

BEGIN
  WITH i_Din(15) SELECT
  s_int <= "0000000000000000" WHEN '0',
    "1111111111111111" WHEN '1',
    "0000000000000000" WHEN OTHERS;

  WITH i_Sel SELECT
    o_OUT <= "0000000000000000" & i_Din WHEN '0',
    s_int & i_Din WHEN '1',
    "0000000000000000" & i_Din WHEN OTHERS;

END flow;