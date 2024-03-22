-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- onesCompN
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a n-bit ones complementor 
-- using structural VHDL.
--
-- NOTES:
-- 1-29-24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity onesCompN is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(
       i_A         : in std_logic_vector(N-1 downto 0);     
       o_F          : out std_logic_vector(N-1 downto 0));

end onesCompN;

architecture structural of onesCompN is

  component invg is
    port(
         i_A                 : in std_logic;
         o_F                  : out std_logic);
  end component;

begin
-- Instantiate N complementor instances.
  G_NBit_COMP: for i in 0 to N-1 generate
    MUXI: invg port map(
              i_A     => i_A(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
              o_F      => o_F(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_COMP;
  
end structural;