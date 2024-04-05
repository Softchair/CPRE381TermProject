-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1Flow.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2 to 1 mux
-- using data flow
--
-- NOTES:
-- 1-28-24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity mux2t1Flow is 
	port (A, B : in std_logic;
	SEL : in std_logic;
	m_OUT : out std_logic);
end mux2t1Flow;

architecture mux2t1F of mux2t1Flow is 
begin
   m_OUT <= A when (SEL = '0') else
            B when (SEL = '1') else
            '0';

end mux2t1F;