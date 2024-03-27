-------------------------------------------------------------------------
-- Camden Fergen
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- rippleCarryAdderN.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a N bit ripple
-- carry adder
--
-- NOTES:
-- Created file - 3/1/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity rippleCarryAdderN is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       i_Cin        : in std_logic;
       o_Cout       : out std_logic;
       o_S          : out std_logic_vector(N-1 downto 0));

end rippleCarryAdderN;

architecture structural of rippleCarryAdderN is

  component adder1b is
    port(iA                  : in std_logic;
         iB                  : in std_logic;
         iC                  : in std_logic;
	 oC		     : out std_logic;
         oS                  : out std_logic);
  end component;

  --Signal for first adder
  signal s_adderCarryBit : std_logic_vector(N-1 downto 0);

begin

  --First adder
  g_1stBitRipple_Adder: adder1b
    port map(iA		=> i_A(0),
	     iB		=> i_B(0),
	     iC		=> i_Cin,
	     oC		=> s_adderCarryBit(0),
	     oS		=> o_S(0));

  --Generate rest of adders
  NbitRipple_Adder: for i in 1 to N-1 generate
    Adderi: adder1b port map(
      iA	=> i_A(i),
      iB	=> i_B(i),
      iC	=> s_adderCarryBit(i-1),
      oC	=> s_adderCarryBit(i),
      oS	=> o_S(i));
  end generate NbitRipple_Adder;

  --Last adder
  g_LastBitRipple_Adder: adder1b
    port map(iA		=> i_A(N-1),
	     iB		=> i_B(N-1),
	     iC		=> s_adderCarryBit(N-1),
	     oC		=> o_Cout,
	     oS		=> o_S(N-1));

end structural;
