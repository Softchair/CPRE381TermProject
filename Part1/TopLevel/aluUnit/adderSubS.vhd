-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- adderSubS.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the implementation of a adder-subtractor using 
-- structures.
--              
-- 01/31/2024
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity adderSubS is
generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
port(
     i_D0    : in std_logic_vector(N-1 downto 0); -- reg A input
     i_D1   : in std_logic_vector(N-1 downto 0); -- reg B input
     i_SEL  : in std_logic;
     o_O    : out std_logic_vector(N-1 downto 0);
     o_Cout : out std_logic
     
     
);

end adderSubS;


architecture structure of adderSubS is

component mux2t1_N

  port(i_D0     : in std_logic_vector(N-1 downto 0);
       i_D1     : in std_logic_vector(N-1 downto 0);
       i_S     : in std_logic;
       o_O     : out std_logic_vector(N-1 downto 0));




end component;



component xorg2

  port(i_A     : in std_logic;
       i_B     : in std_logic;
       o_F     : out std_logic);

end component;


component onesCompN

  port(i_A     : in std_logic_vector(N-1 downto 0);
       o_F     : out std_logic_vector(N-1 downto 0));

end component;






component fullAdderStructN

  port(i_D0    : in std_logic_vector(N-1 downto 0);
       i_D1    : in std_logic_vector(N-1 downto 0);
       o_O    : out std_logic_vector(N-1 downto 0);
       o_Cout    : out std_logic;
       o_Cout31     : out std_logic;
       i_Cin    : in std_logic);

end component;

-- Signals
signal s_M      : std_logic_vector(N-1 downto 0); -- signal to carry output from mux
signal s_Cout      : std_logic; -- signal to carry cOUT
signal s_Cout31 : std_logic;

--signal s_S      : std_logic; -- signal to carry Sum (optional)
signal s_I      : std_logic_vector(N-1 downto 0); -- signal to carry value out of inverter










begin


g_inverterGate01 : onesCompN
   port MAP(i_A => i_D1,
            o_F => s_I);




-- level 1: ( n mux compononent)

g_muxGate01 : mux2t1_N
  port MAP(i_D1    => s_I,
           i_D0    => i_D1,
	   i_S    => i_SEL,
           o_O    => s_M);



-- level 2: Ripple Full Adder component

g_RippleFAGate02: fullAdderStructN
  port MAP(i_D0    => i_D0,
           i_D1    => s_M,
	   i_Cin    => i_SEL,
	   o_Cout => s_Cout,
           o_Cout31 => s_Cout31, 
           o_O    => o_O);



xorg01 : xorg2 
 port MAP(
          i_A => s_Cout,
          i_B => s_Cout31,
          o_F => o_Cout);

		
end structure;


