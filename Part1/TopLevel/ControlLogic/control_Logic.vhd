-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- control_Logic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a test bench for 
-- bit extenders
--
-- NOTES:
-- 2/28/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all; -- For logic types I/O
library std;
use std.env.all; -- For hierarchical/external signals
use std.textio.all; -- For basic I/O





entity control_Logic is 
   port ( 
         i_DOpcode : in std_logic_vector(5 downto 0);
         i_DFunc : in std_logic_vector(5 downto 0);
         o_signals : out std_logic_vector(21 downto 0));
      
end control_Logic;





architecture flow of control_Logic is
--signals 

begin  

 	o_signals <=   "1000110000000001100000" when i_DOpcode = "001000" else                        -- addi
                     "0000100000000001100000" when i_DOpcode = "000000" and i_DFunc = "100000" else -- add
                     "1000110000000000100000" when i_DOpcode = "001001" else                        -- addiu
                     "0000100000000000000000" when i_DOpcode = "000000" and i_DFunc = "100001" else -- 1000100000000000X0 addu
                     "0000100000000010000000" when i_DOpcode = "000000" and i_DFunc = "100100" else -- 0X00100000000010X0 and
                     "1000110000000010000000" when i_DOpcode = "001100" else                        -- 1X0011000000001000 andi
		         "0000110000000100000000" when i_DOpcode = "001111" else                        -- XX0011000000010000 lui
  		         "1010110000000000100000" when i_DOpcode = "100011" else                        -- 101011000000000010 lw
		         "0000100000000110000000" when i_DOpcode = "000000" and i_DFunc = "100111" else -- XX00100000000110X0 nor
                     "0000100000001000000000" when i_DOpcode = "000000" and i_DFunc = "100110" else -- XX00100000001000X0 xor
		         "1000110000001000000000" when i_DOpcode = "001110" else                        -- 1X0011000000100000 xori
                     "0000100000001010000000" when i_DOpcode = "000000" and i_DFunc = "100101" else -- XX00100000001010X0 or
                     "1000110000001010000000" when i_DOpcode = "001101" else                        -- 1X0011000000101000 ori
                     "0100100000001100000000" when i_DOpcode = "000000" and i_DFunc = "101010" else -- 0100100000001100X0 slt
                     "1100110000001100100000" when i_DOpcode = "001010" else                        -- 110011000000110010 slti
                     "0000100000001110000000" when i_DOpcode = "000000" and i_DFunc = "000000" else -- 000010000000111000 sll (exluding dont cares)
                     "0000100000010000000000" when i_DOpcode = "000000" and i_DFunc = "000010" else -- XX00100000010000X0 srl
                     "0000100000010010000000" when i_DOpcode = "000000" and i_DFunc = "000011" else -- XX00100000010010X0 sra
                     "1001000000000000100000" when i_DOpcode = "101011" else                        -- 10010X000000000010 sw
                     "0100100000000001000000" when i_DOpcode = "000000" and i_DFunc = "100010" else -- 0100100000000001X0 sub
                     "0100100000000000000000" when i_DOpcode = "000000" and i_DFunc = "100011" else -- 0100100000000000X0 subu
                     "0100001000000000000000" when i_DOpcode = "000100" else                        -- 01000X1000000000X0 beq
                     "0100000100000000000000" when i_DOpcode = "000101" else                        -- 01000X0100000000X0 bne
                     "0000000010000000000000" when i_DOpcode = "000010" else                        -- XX000X00100XXXX0X0 j
                     "0000100011000000000000" when i_DOpcode = "000011" else                        -- XX001X(R31)00110XXXX0X0 jal
                     "0000000000100000000000" when i_DOpcode = "000000" and i_DFunc = "001000" else -- XX000X00001XXXX0X0 jr
                     "1010110000000000100010" when i_DOpcode = "100000" else                        -- 101011000000000010 lb
                     "1010110000000000100110" when i_DOpcode = "100001" else                        -- 101011000000000010 lh
                     "1010110000000000000100" when i_DOpcode = "100100" else                        -- 101011000000000000 lbu
                     "1010110000000000001000" when i_DOpcode = "100101" else                        -- 101011000000000000 lhu
                     "0000100000001110010000" when i_DOpcode = "000000" and i_DFunc = "000100" else -- XX00100000001110X1 sllv
                     "0000100000010000010000" when i_DOpcode = "000000" and i_DFunc = "000110" else -- XX00100000010000X1 srlv
                     "0000100000010010010000" when i_DOpcode = "000000" and i_DFunc = "000111" else -- XX00100000010010X1 srav
                     "0000000000000000000001" when i_DOpcode = "010100" else                        -- 0000000000000000000001 halt
                     "0000000000000000000000";

end flow;