-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- stallFLush.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit register
-- using a d flip flop
--
-- NOTES:
-- 2/2/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity stallFLush is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK        : in std_logic;
       i_stall      : in std_logic;
       i_flush      : in std_logic;
       i_dataIn          : in std_logic_vector(31 downto 0);
       o_dataOut    : out std_logic_vector(31 downto 0));
end stallFLush;

architecture structural of stallFLush is

  component dffgNN is
    port(i_CLK                : in std_logic;
         i_RST                : in std_logic;
         i_WE                 : in std_logic;
         i_D                  : in std_logic_vector(31 downto 0);
	 o_Q                  : out std_logic_vector(31 downto 0));
  end component;
 

 component mux2t1_N is 
 
 port(i_S        : in std_logic;
       i_D0          : in std_logic_vector(31 downto 0);
       i_D1         : in std_logic_vector(31 downto 0);
       o_O        : out std_logic_vector(31 downto 0));
  end component;


component invg is 
  port(i_A          : in std_logic;
       o_F          : out std_logic);
 end component;

----signals

signal s_flushMuxData : std_logic_vector(31 downto 0);
signal s_stallMuxData : std_logic_vector(31 downto 0);
signal s_regStall     : std_logic;
signal s_IfIDdata     : std_logic_vector(31 downto 0);
signal s_IdExdata     : std_logic_vector(31 downto 0);
signal s_ExMemData    : std_logic_vector(31 downto 0);


begin
 

--level 0

flushMux : mux2t1_N 
  port map(
      i_S => i_flush,
      i_D0   => i_dataIn,
      i_D1   => x"00000000",
      o_O => s_flushMuxData);

stallInv : invg
  port map(
     i_A => i_stall,
     o_F => s_regStall);

IfIdReg : dffgNN 
  port map(
     i_CLK => i_CLK,
     i_RST => '0',
     i_WE  => s_regStall,
     i_D   => s_flushMuxData,
     o_Q   => s_IfIDdata);

--level 1

stallMux : mux2t1_N 
  port map(
      i_S => i_stall,
      i_D0   => s_IfIDdata,
      i_D1  => x"00000000",
      o_O => s_stallMuxData);


IdExReg : dffgNN 
  port map(
     i_CLK => i_CLK,
     i_RST => '0',
     i_WE  => '1',
     i_D   => s_stallMuxData,
     o_Q   => s_IdExdata);

 --level 2

ExMemReg : dffgNN 
  port map(
     i_CLK => i_CLK,
     i_RST => '0',
     i_WE  => '1',
     i_D   => s_IdExdata,
     o_Q   => s_ExMemData);
  

 --level 3


MemWbReg : dffgNN 
  port map(
     i_CLK => i_CLK,
     i_RST => '0',
     i_WE  => '1',
     i_D   => s_ExMemData,
     o_Q   => o_dataOut);


end structural;