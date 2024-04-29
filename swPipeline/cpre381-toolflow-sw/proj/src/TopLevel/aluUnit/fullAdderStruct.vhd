-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- fullAdderStruct.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the implementation of a full adder using 
-- structures.
--              
-- 01/29/2024
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdderStruct is
port(
     i_D0    : in std_logic;
     i_D1    : in std_logic;
     i_Cin  : in std_logic;
     o_O    : out std_logic;
     o_Cout : out std_logic
     
     
);

end fullAdderStruct;


architecture structure of fullAdderStruct is

component andg2

  port(i_A     : in std_logic;
       i_B     : in std_logic;
       o_F     : out std_logic);




end component;

component xorg2

  port(i_A     : in std_logic;
       i_B     : in std_logic;
       o_F     : out std_logic);

end component;


component org2

  port(i_A    : in std_logic;
       i_B    : in std_logic;
       o_F    : out std_logic);

end component;

-- Signals
signal s_O      : std_logic; -- signal for sum output from xor gate 2
signal s_X1      : std_logic; -- signal to carry output xor 1 gate to xor gate 2
signal s_A1      : std_logic; -- signal to carry AND Gate1
signal s_A2      : std_logic; -- signal to carry AND GAte2
signal s_R0     : std_logic; -- signal to output carry out

begin

-- level 0: Xor gate and AND gate

g_xorGate01: xorg2
  port MAP(i_A   => i_D0,
          i_B   =>  i_D1,
          o_F => s_X1);

g_andGate01 : andg2
  port MAP(i_A    => i_D0,
           i_B    => i_D1,
           o_F    => s_A1);



-- level 1: AND gate and second XOR gate

g_xorGate02: xorg2
  port MAP(i_A   => s_X1,
           i_B   =>  i_Cin,
           o_F => o_O);

g_andGateB : andg2
 port MAP(i_A    => s_X1,
           i_B    => i_Cin,
           o_F    => s_A2);


-- level 3: OR gate

g_orGate : org2
  port MAP(i_A    => s_A2,
           i_B    => s_A1,
           o_F    => o_Cout);



		
end structure;



