-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- barrelShifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an 32 bit wide barrel shifter using
-- multiple generics
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity barrelShifter is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_Cin        : in std_logic_vector(31 downto 0);
       i_shamt         : in std_logic_vector(4 downto 0);
       o_Cout       : out std_logic_vector(31 downto 0));



end barrelShifter;

architecture structural of barrelShifter is

  component mux2t1 is
    port(   i_S    : in std_logic;
     i_D0    : in std_logic;
     i_D1    : in std_logic;
     o_O  : out std_logic);

  end component;


  component invg is 
  port(i_A          : in std_logic;
       o_F          : out std_logic);

  end component;
-- signal for carry 
signal s_carryA : std_logic_vector(N downto 0);
signal s_ovrF : std_logic;
-- bits to shift 
signal s_sbit1 : std_logic;
signal s_sbit2 : std_logic;
signal s_sbit3 : std_logic;
signal s_sbit4 : std_logic;
signal s_sbit5 : std_logic;
-- mux outputs 
signal s_o1bit : std_logic_vector(31 downto 1);

begin

bit1_g : invg 
 port MAP(
     i_A  => i_shamt(0),
     o_F  => s_sbit1);
 


--o_Cout <= s_carryA(N);
  -- Instantiate N mux instances.
  G_NBit_ADDER: for i in 31 downto 1 generate
    MUXI: mux2t1 port map(
              i_S      => s_sbit1,      -- All instances share the same select input.
              i_D0     => i_Cin(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => i_Cin(i-1),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => s_o1bit(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_ADDER;
  


end structural;