-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- ALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the ALU for the single
-- cycle MIPS processor.
--
-- NOTES:
-- 3/1/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all; -- For logic types I/O
library std;
use std.env.all; -- For hierarchical/external signals
use std.textio.all; -- For basic I/O



entity ALU is
port(

     i_A    : in std_logic_vector(31 downto 0); -- reg a input (rs)
     i_B    : in std_logic_vector(31 downto 0); -- reg b input  (rt)
     i_imme : in std_logic_vector(15 downto 0); -- immediate input
     i_zeroSignSEL  : in std_logic; -- s_signExt
     i_SEL : in std_logic; -- nAdd_Sub
     ALUSrc : in std_logic;
     i_ALUOpSel : in std_logic_vector(3 downto 0); -- s_ALUOPSel
     o_DataOut : out std_logic_vector(31 downto 0); -- dataOut
     i_sOverFlow : in std_logic; -- overflow signal
     o_overFlow : out std_logic -- overflow output
     
     
);

end ALU;



architecture structure of ALU is

-- For all Add/Sub operations
component firstALU

  port(i_A    : in std_logic_vector(31 downto 0); -- reg a input
     i_B    : in std_logic_vector(31 downto 0); -- reg b input 
     i_imme : in std_logic_vector(31 downto 0); -- immediate input
     i_SEL  : in std_logic; -- nAdd_Sub
     ALUSrc : in std_logic;
     o_O : out std_logic_vector(31 downto 0);
     o_Cout : out std_logic);


end component;


-- used for immediate operations
component bit_extenders

port ( 
         i_Din : in std_logic_vector(15 downto 0);
         o_OUT : out std_logic_vector(31 downto 0);
         SEL : in std_logic);

end component;

-----------------------------------------
-- MUX's
-----------------------------------------

component mux2t1Flow 

port (A, B : in std_logic;
	SEL : in std_logic;
	m_OUT : out std_logic);

end component;



component mux2t1_N -- 2t1 32 bits wide mux

port (i_S          : in std_logic;
       i_D0         : in std_logic_vector(31 downto 0);
       i_D1         : in std_logic_vector(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));

end component;

component mux16_1 -- 16t1 32 bit wide mux

port ( D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11,
          D12, D13, D14, D15 : in std_logic_vector(31 downto 0);
         o_OUT : out std_logic_vector(31 downto 0);
         SEL : in std_logic_vector(3 downto 0));

end component;





-----------------------------------------
-- AND/OR/XOR/NOR gates
-----------------------------------------

component andG_N -- 32 bit AND gate

 port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic_vector(31 downto 0));

end component;

component orG_N -- 32 bit AND gate

 port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic_vector(31 downto 0));
end component;



component xorG_N -- 32 bit XOR gate

  port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic_vector(31 downto 0));
end component;


component norG_N

port(
     i_A    : in std_logic_vector(31 downto 0);
     i_B    : in std_logic_vector(31 downto 0); 
     o_O    : out std_logic_vector(31 downto 0));

end component;




--signals

-- after extender before arithmetic/logic
signal s_bitExtended : std_logic_vector(31 downto 0); -- signal coming from bit extender
signal s_muxToLogicGates : std_logic_vector(31 downto 0); -- signal from 2t1 mux to AND/OR/XOR/NOR for imme values or B

-- overflow
signal s_addSubOverFlowOut : std_logic; -- signal for overflow output from add/sub

-- To 16t1 Mux
signal s_AddSubDataOut : std_logic_vector(31 downto 0); -- signal data output from add/sub to 16t1 mux
signal s_AndDataOut : std_logic_vector(31 downto 0); -- signal data output from AND gate to 16t1 mux
signal s_OrDataOut : std_logic_vector(31 downto 0); -- signal data output from OR gate to 16t1 mux
signal s_XorDataOut : std_logic_vector(31 downto 0); -- signal data output from XOR gate to 16t1 mux
signal s_NorDataOut : std_logic_vector(31 downto 0); -- signal data output from Nor gate to 16t1 mux



begin





-- level 0: (extender / mux)
g_bitExtender01 : bit_extenders
  port MAP(i_Din  => i_imme,
           o_Out  => s_bitExtended,
           SEL    => i_zeroSignSEL);  



g_muxGate01 : mux2t1_N
  port MAP(i_D1    => s_bitExtended,
           i_D0    => i_B,
	   i_S    => ALUSrc,
           o_O    => s_muxToLogicGates);


-- level 1: (Add/Sub and Logic Gates)

g_addSub01 : firstALU 
  port MAP(i_A  => i_A,
     i_B        => i_B,
     i_imme     => s_bitExtended,
     i_SEL      => i_SEL,
     ALUSrc     => ALUSrc,
     o_O        => s_AddSubDataOut,
     o_Cout     => s_addSubOverFlowOut);

g_AND32 : andG_N
  port MAP(i_A  => i_A,
       i_B      => s_muxToLogicGates,
       o_F      => s_AndDataOut);

g_OR32 : orG_N
  port MAP(i_A  => i_A,
       i_B      => s_muxToLogicGates,
       o_F      => s_OrDataOut);


g_XOR32 : xorG_N
  port MAP(i_A  => i_A,
       i_B      => s_muxToLogicGates,
       o_F      => s_XorDataOut);


g_NOR32 : norG_N
  port MAP(i_A  => i_A,
       i_B      => s_muxToLogicGates,
       o_O      => s_NorDataOut);




-- level 2: (16t1 mux and overflow mux)

g_16t1Mux : mux16_1
   port MAP(D0 => s_AddSubDataOut,
           D1 => s_AndDataOut, 
           D2 => x"00000000", 
           D3 => s_NorDataOut, 
           D4 => s_XorDataOut, 
           D5 => s_OrDataOut, 
           D6 => x"00000000", 
           D7 => x"00000000", 
           D8 => x"00000000", 
           D9 => x"00000000", 
           D10 => x"00000000", 
           D11 => x"00000000",
           D12 => x"00000000", 
           D13 => x"00000000", 
           D14 => x"00000000",
           D15 => x"00000000",
           o_OUT => o_dataOut,
           SEL => i_ALUOpSel);

g_ovrFlowMux : mux2t1Flow
  port MAP(A    => s_addSubOverFlowOut,
           B    => '0',
	   SEL  => i_sOverFlow,
           m_OUT    => o_overFLow);



end structure;

