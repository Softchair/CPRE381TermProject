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
     o_overFlow : out std_logic; -- overflow output
     o_zero : out std_logic -- zero output that goes to branch logic
     
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
-- LUI
-----------------------------------------


component lui

 port ( 
         i_Din : in std_logic_vector(15 downto 0);
         o_OUT : out std_logic_vector(31 downto 0));

end component;

-----------------------------------------
-- SLT/SLTI
-----------------------------------------


component slt
 port ( 
         i_Din : in std_logic_vector(31 downto 0);
         o_OUT : out std_logic_vector(31 downto 0));

      
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

-----------------------------------------
-- Zero output gates
-----------------------------------------

component orG32b

port(
       D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, D16,
   D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28, D29, D30, D31 : in std_logic;
   o_Out : out std_logic);

end component;


component invg

port(
       i_A          : in std_logic;
       o_F          : out std_logic);

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
signal s_LuiDataOut : std_logic_vector(31 downto 0); -- signal data output from LUI to 16t1 mux
signal s_sltDataOut : std_logic_vector(31 downto 0); -- signal for output of SLT/SLTI to 16t1 mux
signal s_orGateZeroOut : std_logic; --signal from or gate to inverter for zero logic

begin





-- level 0: (extender / mux / LUI)
g_bitExtender01 : bit_extenders
  port MAP(i_Din  => i_imme,
           o_Out  => s_bitExtended,
           SEL    => i_zeroSignSEL);  



g_muxGate01 : mux2t1_N
  port MAP(i_D1    => s_bitExtended,
           i_D0    => i_B,
	   i_S    => ALUSrc,
           o_O    => s_muxToLogicGates);


g_lui01 : lui
  port MAP(
            i_Din => i_imme,
            o_OUT => s_LuiDataOut);


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



-- level 2:(slt/slti gates)
g_slt : slt
   port MAP(i_Din => s_AddSubDataOut,
            o_OUT => s_sltDataOut);



-- level 3: (16t1 mux and overflow mux and Zero output)

g_16t1Mux : mux16_1
   port MAP(D0 => s_AddSubDataOut,
           D1 => s_AndDataOut, 
           D2 => s_LuiDataOut, 
           D3 => s_NorDataOut, 
           D4 => s_XorDataOut, 
           D5 => s_OrDataOut, 
           D6 => s_sltDataOut, 
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


g_orG32b01 : orG32b
  port MAP(
    D0 => s_AddSubDataOut(0),
    D1 => s_AddSubDataOut(1), 
    D2 => s_AddSubDataOut(2), 
    D3 => s_AddSubDataOut(3), 
    D4 => s_AddSubDataOut(4), 
    D5 => s_AddSubDataOut(5), 
    D6 => s_AddSubDataOut(6), 
    D7 => s_AddSubDataOut(7), 
    D8 => s_AddSubDataOut(8), 
    D9 => s_AddSubDataOut(9), 
    D10 => s_AddSubDataOut(10), 
    D11 => s_AddSubDataOut(11), 
    D12 => s_AddSubDataOut(12), 
    D13 => s_AddSubDataOut(13), 
    D14 => s_AddSubDataOut(14), 
    D15 => s_AddSubDataOut(15), 
    D16 => s_AddSubDataOut(16),
    D17 => s_AddSubDataOut(17), 
    D18 => s_AddSubDataOut(18),
          D19 => s_AddSubDataOut(19),
           D20 => s_AddSubDataOut(20),
           D21 => s_AddSubDataOut(21), 
           D22 => s_AddSubDataOut(22),
           D23 => s_AddSubDataOut(23),
           D24 => s_AddSubDataOut(24),
           D25 => s_AddSubDataOut(25),
           D26 => s_AddSubDataOut(26),
           D27 => s_AddSubDataOut(27),
           D28 => s_AddSubDataOut(28), 
           D29 => s_AddSubDataOut(29),
           D30 => s_AddSubDataOut(30),
           D31 => s_AddSubDataOut(31),
           o_Out        => s_orGateZeroOut);


g_invgG01 : invg 
  port MAP(
         i_A   => s_orGateZeroOut,
         o_F   => o_Zero);

end structure;

