-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- fullAdderStructN.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide full 
-- adder using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdderStructN is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_Cin        : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0);
       o_Cout       : out std_logic);

end fullAdderStructN;

architecture structural of fullAdderStructN is

  component fullAdderStruct is
    port(i_Cin                  : in std_logic;
         i_D0                 : in std_logic;
         i_D1                 : in std_logic;
         o_O                  : out std_logic;
	 o_Cout       : out std_logic);
  end component;

-- signal for carry 
signal s_carryA : std_logic_vector(N downto 0);




begin
s_carryA(0) <= i_Cin;
o_Cout <= s_carryA(N);
  -- Instantiate N mux instances.
  G_NBit_ADDER: for i in 0 to N-1 generate
    MUXI: fullAdderStruct port map(
              i_Cin      => s_carryA(i),      -- All instances share the same select input.
	      o_Cout      => s_carryA(i + 1),
              i_D0     => i_D0(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => i_D1(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => o_O(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_ADDER;
  
end structural;