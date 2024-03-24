-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- firstALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an ALU using an adder/subtractor
-- and mux 
-- the register
-- 2/8/24
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;


entity firstALU is
port(
     i_A    : in std_logic_vector(31 downto 0); -- reg a input
     i_B    : in std_logic_vector(31 downto 0); -- reg b input 
     i_imme : in std_logic_vector(31 downto 0); -- immediate input
     i_SEL  : in std_logic;
     ALUSrc : in std_logic;
     o_O : out std_logic_vector(31 downto 0);
     o_Cout : out std_logic
     
     
);

end firstALU;





architecture structure of firstALU is

component adderSubS

  port(
     i_D0    : in std_logic_vector(31 downto 0);
     i_D1    : in std_logic_vector(31 downto 0);
     i_SEL  : in std_logic;
     o_O    : out std_logic_vector(31 downto 0);
     o_Cout : out std_logic
      );


end component;



component mux2t1_N

  port(i_D0     : in std_logic_vector(31 downto 0);
       i_D1     : in std_logic_vector(31 downto 0);
       i_S     : in std_logic;
       o_O     : out std_logic_vector(31 downto 0));




end component;






component onesCompN

  port(i_A     : in std_logic_vector(31 downto 0);
       o_F     : out std_logic_vector(31 downto 0));

end component;




-- Signals
signal s_MOne      : std_logic_vector(31 downto 0); -- signal to carry output from mux
signal s_MTwo      : std_logic_vector(31 downto 0);
--signal s_S      : std_logic; -- signal to carry Sum (optional)
signal s_Ione      : std_logic_vector(31 downto 0); -- signal to carry value out of inverter
signal s_Itwo : std_logic_vector(31 downto 0);


begin






-- level 1: ( n mux compononent)

g_muxGate02 : mux2t1_N
  port MAP(i_D1    => i_imme,
           i_D0    => i_B,
	   i_S    => ALUSrc,
           o_O    => s_MTwo);



-- level 2: adder/sub

g_adderSub01: adderSubS
  port MAP(i_D1    => s_MTwo,
           i_D0    => i_A,
	   i_SEL    => i_SEL,
	   o_Cout => o_Cout,
           o_O    => o_O);



		
end structure;

