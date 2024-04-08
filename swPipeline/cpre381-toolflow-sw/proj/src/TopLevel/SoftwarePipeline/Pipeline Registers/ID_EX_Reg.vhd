-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- ID_EX_Reg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the ID/EX pipeline 
-- register
-- NOTES:
-- 4/3/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ID_EX_Reg is
  generic(N : integer := 134); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK        : in std_logic;
       i_RST         : in std_logic;
       i_WE         : in std_logic;
       i_D          : in std_logic_vector(133 downto 0);
       o_Q       : out std_logic_vector(133 downto 0));

end ID_EX_Reg;

architecture structural of ID_EX_Reg is

  component dffg is
    port(i_CLK                  : in std_logic;
         i_RST                 : in std_logic;
         i_WE                 : in std_logic;
         i_D                  : in std_logic;
	 o_Q       : out std_logic);
  end component;



begin
  -- Instantiate N FF instances.
  G_133Bit_DFFG: for i in 0 to N-1 generate
    MUXI: dffg port map(
              i_CLK      => i_CLK,      -- All instances share the same select input.
	      i_RST      => i_RST,
              i_D     => i_D(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_WE     => i_WE,  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_Q      => o_Q(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_133Bit_DFFG;
  
end structural;