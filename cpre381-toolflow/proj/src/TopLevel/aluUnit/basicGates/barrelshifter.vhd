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
signal s_m1bit : std_logic_vector(31 downto 1);
signal s_m1bit1 : std_logic;
signal s_allbit1 : std_logic_vector(31 downto 0);

signal s_m2bit : std_logic_vector(31 downto 2);
signal s_m2bit2 : std_logic_vector(1 downto 0);
signal s_allbit2 : std_logic_vector(31 downto 0);

signal s_m3bit : std_logic_vector(31 downto 4);
signal s_m3bit4 : std_logic_vector(3 downto 0);
signal s_allbit3 : std_logic_vector(31 downto 0);

signal s_m4bit : std_logic_vector(31 downto 8);
signal s_m4bit8 : std_logic_vector(7 downto 0);
signal s_allbit4 : std_logic_vector(31 downto 0);

signal s_m5bit : std_logic_vector(31 downto 16);
signal s_m5bit16 : std_logic_vector(15 downto 0);
signal s_allbit5 : std_logic_vector(31 downto 0);



begin

bit1_g : invg 
 port MAP(
     i_A  => i_shamt(0),
     o_F  => s_sbit1);
 
-- LEVEL 1 (SHIFT 1 BIT)

--o_Cout <= s_carryA(N);
  -- Instantiate N mux instances.
  G_NBit_MUX01: for i in 31 downto 1 generate
    MUXI: mux2t1 port map(
              i_S      => s_sbit1,      -- All instances share the same select input.
              i_D0     => i_Cin(i-1),  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => i_Cin(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => s_m1bit(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_MUX01;
  


mux01_2 : mux2t1
 port MAP(
     i_S  => s_sbit1,
     i_D0  => '0',
     i_D1  => i_Cin(0),
     o_O  => s_m1bit1);

s_allbit1(31 downto 1) <= s_m1bit;
s_allbit1(0) <= s_m1bit1;

-- LEVEL 2 (SHIFT 2 BITS)


bit2_g : invg 
 port MAP(
     i_A  => i_shamt(1),
     o_F  => s_sbit2);


 G_NBit_MUX02: for i in 31 downto 2 generate
    MUXI1: mux2t1 port map(
              i_S      => s_sbit2,      -- All instances share the same select input.
              i_D0     => s_allbit1(i-2),  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => s_allbit1(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => s_m2bit(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_MUX02;


G_NBit_MUX02_lower: for i in 1 downto 0 generate
    MUXI2: mux2t1 port map(
              i_S      => s_sbit2,      -- All instances share the same select input.
              i_D0     => '0',  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => s_allbit1(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => s_m2bit2(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_MUX02_lower;


s_allbit2(31 downto 2) <= s_m2bit;
s_allbit2(1 downto 0) <= s_m2bit2;


-- LEVEL 3 (SHIFT 4 BITS)

bit3_g : invg 
 port MAP(
     i_A  => i_shamt(2),
     o_F  => s_sbit3);


 G_NBit_MUX03: for i in 31 downto 4 generate
    MUXI3: mux2t1 port map(
              i_S      => s_sbit3,      -- All instances share the same select input.
              i_D0     => s_allbit2(i-4),  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => s_allbit2(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => s_m3bit(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_MUX03;


G_NBit_MUX03_lower: for i in 3 downto 0 generate
    MUXI4: mux2t1 port map(
              i_S      => s_sbit3,      -- All instances share the same select input.
              i_D0     => '0',  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => s_allbit2(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => s_m3bit4(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_MUX03_lower;


s_allbit3(31 downto 4) <= s_m3bit;
s_allbit3(3 downto 0) <= s_m3bit4;


-- LEVEL 4 (SHIFT 8 BITS)

bit4_g : invg 
 port MAP(
     i_A  => i_shamt(3),
     o_F  => s_sbit4);


 G_NBit_MUX04: for i in 31 downto 8 generate
    MUXI5: mux2t1 port map(
              i_S      => s_sbit4,      -- All instances share the same select input.
              i_D0     => s_allbit3(i-8),  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => s_allbit3(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => s_m4bit(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_MUX04;


G_NBit_MUX04_lower: for i in 7 downto 0 generate
    MUXI6: mux2t1 port map(
              i_S      => s_sbit4,      -- All instances share the same select input.
              i_D0     => '0',  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => s_allbit3(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => s_m4bit8(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_MUX04_lower;


s_allbit4(31 downto 8) <= s_m4bit;
s_allbit4(7 downto 0) <= s_m4bit8;



-- LEVEL 5 (SHIFT 16 BITS)

bit5_g : invg 
 port MAP(
     i_A  => i_shamt(4),
     o_F  => s_sbit5);


 G_NBit_MUX05: for i in 31 downto 16 generate
    MUXI7: mux2t1 port map(
              i_S      => s_sbit5,      -- All instances share the same select input.
              i_D0     => s_allbit4(i-16),  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => s_allbit4(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => s_m5bit(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_MUX05;


G_NBit_MUX05_lower: for i in 15 downto 0 generate
    MUXI8: mux2t1 port map(
              i_S      => s_sbit5,      -- All instances share the same select input.
              i_D0     => '0',  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => s_allbit4(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => s_m5bit16(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_MUX05_lower;


s_allbit5(31 downto 16) <= s_m5bit;
s_allbit5(15 downto 0) <= s_m5bit16;
o_Cout <= s_allbit5;

end structural;