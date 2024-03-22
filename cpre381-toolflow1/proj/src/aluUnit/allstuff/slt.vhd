-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- slt.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a the implementation of slt and slti
-- 03/6/2024
-------------------------------------------------------------------------



library IEEE;
use IEEE.std_logic_1164.all;





entity slt is 
   port ( 
         i_Din : in std_logic_vector(31 downto 0);
         o_OUT : out std_logic_vector(31 downto 0));

      
end slt;





architecture behavorial of slt is
begin
slt_proc: process (i_Din, o_OUT)
begin
  
   if (i_Din >= x"00000000") then if (i_Din < x"F0000000") then o_OUT <= x"00000000";
   else o_OUT <= x"00000001";
   end if;
   end if;
 end process slt_proc;
end behavorial;