-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- loadMemModule.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the implementation of a adder-subtractor using 
-- structures.
--              
-- 03/18/2024
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity loadMemModule is

port(
     i_memData    : in std_logic_vector(31 downto 0); -- data from memory address from dmem 
     i_addrData   : in std_logic_vector(1 downto 0); -- last 2 bit of the memory address
     o_LB    : out std_logic_vector(31 downto 0);
     o_LBU    : out std_logic_vector(31 downto 0);
     o_LH    : out std_logic_vector(31 downto 0);
     o_LHU    : out std_logic_vector(31 downto 0)
        
);

end loadMemModule;


architecture structure of loadMemModule is

component mux8b4t1

   port ( D0, D1, D2, D3: in std_logic_vector(7 downto 0);
         o_OUT : out std_logic_vector(7 downto 0);
         SEL : in std_logic_vector(1 downto 0));
     

end component;


component mux16b2t1
  
port ( D0, D1: in std_logic_vector(15 downto 0);
         o_OUT : out std_logic_vector(15 downto 0);
         SEL : in std_logic);
      
end component;



component bit_extenders

 port ( 
         i_Din : in std_logic_vector(15 downto 0);
         o_OUT : out std_logic_vector(31 downto 0);
         SEL : in std_logic);
      
end component;


component bit_extenders24b
 port ( 
         i_Din : in std_logic_vector(7 downto 0);
         o_OUT : out std_logic_vector(31 downto 0);
         SEL : in std_logic);

end component;

-- Signals
signal s_8bmuxtoext      : std_logic_vector(7 downto 0); -- signal to carry output from 8 bit mux to bit extenders (LB/LBU)
signal s_16bmuxtoext      : std_logic_vector(15 downto 0); -- signal to carry output from 16 bit mux to bit extenders (LH/LHU)



begin

-- level 0: ( both mux compononents)

g_8b4t1mux01 : mux8b4t1  
   port MAP(D3 => i_memData(31 downto 24),
            D2 => i_memData(23 downto 16),
            D1 => i_memData(15 downto 8),
            D0 => i_memData(7 downto 0),
            o_OUT => s_8bmuxtoext,
            SEL => i_addrData);


g_16b2t1mux01 : mux16b2t1  
   port MAP(D0 => i_memData(15 downto 0),
            D1 => i_memData(31 downto 16),
            o_OUT => s_16bmuxtoext,
            SEL => i_addrData(1)); -- error is coming from here


-- level 1: ( all bit extenders)

-- LB sign extender
g_24bsignExt : bit_extenders24b 
  port MAP(i_Din    => s_8bmuxtoext,
           o_OUT    => o_LB,
	   SEL    => '1'); -- hard coded to sign extend


-- LBU zero extender
g_24bzeroExt : bit_extenders24b 
  port MAP(i_Din    => s_8bmuxtoext,
           o_OUT    => o_LBU,
	   SEL    => '0'); -- hard coded to zero extend


-- LH sign extender
g_16bsignExt : bit_extenders
  port MAP(i_Din    => s_16bmuxtoext,
           o_OUT    => o_LH,
	   SEL    => '1'); -- hard coded to sign extend


-- LHU zero extender
g_16bzeroExt : bit_extenders
  port MAP(i_Din    => s_16bmuxtoext,
           o_OUT    => o_LHU,
	   SEL    => '0'); -- hard coded to zero extend



		
end structure;
