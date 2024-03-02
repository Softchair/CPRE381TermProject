-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1N is
  generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_Sel        : in std_logic;
       i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       o_Out        : out std_logic_vector(N-1 downto 0));

end mux2t1N;

architecture structural of mux2t1N is

  component mux2t1 is
    port(i_Sel               : in std_logic;
         i_A                 : in std_logic;
         i_B                 : in std_logic;
         o_Out               : out std_logic);
  end component;

begin

  -- Instantiate N mux instances.
  G_NBit_MUX: for i in 0 to N-1 generate
    MUXi: mux2t1 port map(
              i_Sel    => i_Sel,     -- All instances share the same select input.
              i_A      => i_A(i),    -- ith instance's data 0 input hooked up to ith data 0 input.
              i_B      => i_B(i),    -- ith instance's data 1 input hooked up to ith data 1 input.
              o_Out    => o_Out(i)); -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_MUX;
  
end structural;
