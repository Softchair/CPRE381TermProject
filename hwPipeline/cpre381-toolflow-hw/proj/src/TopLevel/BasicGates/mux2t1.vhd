-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2 to 1 mux
-- using structures
--
-- NOTES:
-- 1-24-24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is
port(
     i_S    : in std_logic;
     i_D0    : in std_logic;
     i_D1    : in std_logic;
     o_O  : out std_logic);

end mux2t1;


architecture structure of mux2t1 is

component andg2
  port(i_A     : in std_logic;
       i_B     : in std_logic;
       o_F     : out std_logic);

end component;

component org2
  port(i_A     : in std_logic;
       i_B     : in std_logic;
       o_F     : out std_logic);

end component;


component invg
  port(i_A    : in std_logic;
       o_F    : out std_logic);

end component;

-- Signals
signal s_O      : std_logic; -- signal for final output
signal s_N      : std_logic; -- signal to carry output from not gate
signal s_A      : std_logic; -- signal to carry AND GateA
signal s_B      : std_logic; -- signal to carry AND GAteB


begin
-- level 0: NOT gate

g_notGate: invg
  port MAP(i_A   => i_S,
           o_F   =>  s_N);


-- level 1: AND gate

g_andGateB : andg2
  port MAP(i_A    => i_D1,
           i_B    => i_S,
           o_F    => s_A);

g_andGateA : andg2
  port MAP(i_A    => i_D0,
           i_B    => s_N,
           o_F    => s_B);

-- level 3: OR gate

g_orGate : org2
  port MAP(i_A    => s_A,
           i_B    => s_B,
           o_F    => o_O);



end structure;




