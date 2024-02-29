-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- control_Logic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a test bench for 
-- bit extenders
--
-- NOTES:
-- 2/28/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all; -- For logic types I/O
library std;
use std.env.all; -- For hierarchical/external signals
use std.textio.all; -- For basic I/O





entity control_Logic is 
   port ( 
         i_DOpcode : in std_logic_vector(5 downto 0);
         i_DFunc : in std_logic_vector(5 downto 0);
         o_signals : out std_logic_vector(20 downto 0);
         SEL : in std_logic);
      
end control_Logic;





architecture behavioral of control_Logic is
--signals 

begin  
 
 
 
 	o_signals <= "100011000000000110" when i_DOpcode = "001000" else,
                     "0000000000000000" when i_DOpcode = "000000" and i_DFunc = "000000" else,
                
                 
 
end flow;