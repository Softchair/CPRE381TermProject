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
-- File finished - 3/6/24 
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
         o_signals : out std_logic_vector(17 downto 0));
      
end control_Logic;


architecture flow of control_Logic is

      -- Dont care is a 0, dont forget!!

      begin  
 	o_signals <= "100011000000000110" when i_DOpcode = "001000" else                          --                    | addi
                   "000010000000000110" when i_DOpcode = "000000" and i_DFunc = "010100" else   --                    | add
                   "100011000000000010" when i_DOpcode = "001001" else                          --                    | addiu
                   "100010000000000010" when i_DOpcode = "000000" and i_DFunc = "010101" else   -- 1000100000000000X0 | addu
                   "000010000000001000" when i_DOpcode = "000000" and i_DFunc = "011000" else   -- 0X00100000000010X0 | and
                   "100011000000001000" when i_DOpcode = "001100" else                          -- 1X0011000000001000 | andi
	             "000011000000010000" when i_DOpcode = "001111" else                          -- XX0011000000010000 | lui
  		       "101011000000000010" when i_DOpcode = "100111" else                          -- 101011000000000010 | lw
		       "000010000000011000" when i_DOpcode = "000000" and i_DFunc = "100111" else   -- XX00100000000110X0 | nor
                   "000010000000100000" when i_DOpcode = "000000" and i_DFunc = "100110" else   -- XX00100000001000X0 | xor
	             "100011000000100000" when i_DOpcode = "001110" else                          -- 1X0011000000100000 | xori
                   "000010000000101000" when i_DOpcode = "000000" and i_DFunc = "100101" else   -- XX00100000001010X0 | or
                   "100011000000101000" when i_DOpcode = "001101" else                          -- 1X0011000000101000 | ori
                   "010010000000110000" when i_DOpcode = "000000" and i_DFunc = "101010" else   -- 0100100000001100X0 | slt
                   "110011000000110010" when i_DOpcode = "001010" else                          -- 110011000000110010 | slti
                   "000010000000111000" when i_DOpcode = "000000" and i_DFunc = "000000" else   -- 000010000000111000 | sll (exluding dont cares)
                   "000010000001000000" when i_DOpcode = "000000" and i_DFunc = "000010" else   -- XX00100000010000X0 | srl
                   "000010000001001000" when i_DOpcode = "000000" and i_DFunc = "000011" else   -- XX00100000010010X0 | sra
                   "100100000000000010" when i_DOpcode = "101011" else                          -- 10010X000000000010 | sw
                   "010010000000000100" when i_DOpcode = "000000" and i_DFunc = "100010" else   -- 0100100000000001X0 | sub
                   "010010000000000000" when i_DOpcode = "000000" and i_DFunc = "100011" else   -- 0100100000000000X0 | subu
                   "010000100000000000" when i_DOpcode = "000100" else                          -- 01000X1000000000X0 | beq
                   "010000010000000000" when i_DOpcode = "000101" else                          -- 01000X0100000000X0 | bne
                   "000000001000000000" when i_DOpcode = "000010" else                          -- XX000X00100XXXX0X0 | j
                   "000010001100000000" when i_DOpcode = "000011" else                          -- XX001X(R31)00110XXXX0X0 | jal
                   "000000000010000000" when i_DOpcode = "000000" and i_DFunc = "001000" else   -- XX000X00001XXXX0X0 | jr
                   "101011000000000010" when i_DOpcode = "100000" else                          -- 101011000000000010 | lb
                   "101011000000000010" when i_DOpcode = "100001" else                          -- 101011000000000010 | lh
                   "101011000000000000" when i_DOpcode = "100100" else                          -- 101011000000000000 | lbu
                   "101011000000000000" when i_DOpcode = "100101" else                          -- 101011000000000000 | lhu
                   "000010000000111001" when i_DOpcode = "000000" and i_DFunc = "000100" else   -- XX00100000001110X1 | sllv
                   "000010000001000001" when i_DOpcode = "000000" and i_DFunc = "000110" else   -- XX00100000010000X1 | srlv
                   "000010000001001001" when i_DOpcode = "000000" and i_DFunc = "000111" else   -- XX00100000010010X1 | srav
                   "000000000000000000";

end flow;