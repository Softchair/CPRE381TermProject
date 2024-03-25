-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- norG_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the implementation of a nor gate using 
-- structures.
--              
-- 03/4/2024
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity norG_N is
generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
port(
     i_A    : in std_logic_vector(N-1 downto 0);
     i_B    : in std_logic_vector(N-1 downto 0); 
     o_O    : out std_logic_vector(N-1 downto 0));
     
     


end norG_N;


architecture structure of norG_N is

component orG_N

  port(i_A     : in std_logic_vector(N-1 downto 0);
       i_B     : in std_logic_vector(N-1 downto 0);
       o_F     : out std_logic_vector(N-1 downto 0));




end component;



component onesCompN

  port(i_A     : in std_logic_vector(N-1 downto 0);
       o_F     : out std_logic_vector(N-1 downto 0));

end component;




-- Signals
signal s_F      : std_logic_vector(N-1 downto 0); -- signal to carry output from OR gate






begin






-- level 0: ( n OR compononent)

g_orGate01 : orG_N
  port MAP(i_A    => i_A,
           i_B    => i_B,
           o_F    => s_F);


-- level 1: (1s comp component)

g_inverterGate01 : onesCompN
   port MAP(i_A => s_F,
            o_F => o_O);





		
end structure;

