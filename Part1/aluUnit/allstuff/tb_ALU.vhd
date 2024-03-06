-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_ALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the MIPS single cycle 
-- ALU
--              
-- 03/5/2024
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all; -- For logic types I/O
library std;
use std.env.all; -- For hierarchical/external signals
use std.textio.all; -- For basic I/O


entity tb_ALU is
  generic(gCLK_HPER   : time := 10 ns; N : integer := 32);   -- Generic for half of the clock cycle period
end tb_ALU;



architecture mixed of tb_ALU is
-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;


component ALU is

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
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';


-- outside wires
signal s_A            : std_logic_vector(31 downto 0); -- A input 
signal s_B            : std_logic_vector(31 downto 0); -- B input
signal s_imme            : std_logic_vector(15 downto 0); -- immediate input
signal s_zeroSignSEL : std_logic; -- zeroSignSEL signal
signal s_SEL          : std_logic; -- SEL signal
signal s_ALUSrc       : std_logic; -- ALUSrc signal
signal s_ALUOpSel : std_logic_vector(3 downto 0); -- ALUOpSel signal
signal s_DataOut            : std_logic_vector(31 downto 0); -- ALU data output
signal s_sOverFlow : std_logic; -- overflow mux logic
signal s_overFlow : std_logic; -- overflow output






begin 

DUT0: ALU
  port map(
            i_B        => s_B,
            i_A        => s_A,
            i_imme    => s_imme,
            i_zeroSignSEL => s_zeroSignSEL,
            i_SEL        => s_SEL,
            ALUSrc       => s_ALUSrc,
            i_ALUOpSel   => s_ALUOpSel,
            o_DataOut  => s_DataOut,
            i_sOverFlow => s_sOverFlow,
            o_overFLow => s_overFlow);

  
    
    P_TEST_CASES: process
  begin
   
----------------------------------
-- ADD
----------------------------------

  
    -- values to add 
    s_A <= x"00000064"; -- rs
    s_B <= x"00000028"; -- rt
    s_imme <= "0000000100000000";
    
    --signals
    s_ALUSrc  <= '0'; --  (0) A+B, (1) A+imme
    s_SEL     <= '0'; -- sel (add(0)-sub(1))
    s_ALUOpSel  <= "0000"; -- ALUOpSel signal
    s_sOverFlow <= '1'; -- overflow mux logic
    s_zeroSignSEL <= '0'; -- select 0/1 infront of immediate
    

  wait for gCLK_HPER*2;

    s_A <= x"00000064"; -- rs
    s_B <= x"FFFFFFD8"; -- rt
    s_imme <= "0000000100011000";
    
   
 
    
    wait for gCLK_HPER*2;
    
  
    s_A <= x"FFFFFC18"; -- rs
    s_B <= x"FFFFF060"; -- rt
    s_imme <= "1111000100011000";
    
-- Expected outputs:
-- 8c
-- 3c 
-- ffffec78


  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;

-----------------------------------------------
-- ADDI
-----------------------------------------------

-- values to addi
    s_A <= x"00000000"; -- rs
    s_B <= x"00000028"; -- rt
    s_imme <= "0000000001100100";
    
    --signals
    s_ALUSrc  <= '1'; --  (0) A+B, (1) A+imme
    s_SEL     <= '0'; -- sel (add(0)-sub(1))
    s_ALUOpSel  <= "0000"; -- ALUOpSel signal
    s_sOverFlow <= '1'; -- overflow mux logic
    s_zeroSignSEL <= '1'; -- select 0/1 infront of immediate
    
  wait for gCLK_HPER*2;

    s_A <= x"00000064"; -- rs
    s_B <= x"00000028"; -- rt
    s_imme <= "0000000001100100";


 wait for gCLK_HPER*2;

    s_A <= x"00000064"; -- rs
    s_B <= x"00000028"; -- rt
    s_imme <= "1111111110010111";

 wait for gCLK_HPER*2;

    s_A <= x"fffffEC0"; -- rs
    s_B <= x"00000028"; -- rt
    s_imme <= "1101100000011111";


wait for gCLK_HPER*2;

    s_A <= x"00000000"; -- rs
    s_B <= x"00000028"; -- rt
    s_imme <= "0000000000000000";


-- Expecting
-- 00000064
-- 000000c8
-- fffffffb
-- ffffd6df
-- 00000000

 

-----------------------------------------------
-- AND
-----------------------------------------------
  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;


-- values to and
    s_A <= x"00000000"; -- rs
    s_B <= x"0000041A"; -- rt
    s_imme <= "0000000001100100";
    
    --signals
    s_ALUSrc  <= '0'; --  (0) A+B, (1) A+imme
    s_SEL     <= '0'; -- sel (add(0)-sub(1))
    s_ALUOpSel  <= "0001"; -- ALUOpSel signal
    s_sOverFlow <= '0'; -- overflow mux logic
    s_zeroSignSEL <= '0'; -- select 0/1 infront of immediate
    
  wait for gCLK_HPER*2;

    s_A <= x"0000041A"; -- rs
    s_B <= x"0000005C"; -- rt
    s_imme <= "0000000001100100";

  wait for gCLK_HPER*2;

    s_A <= x"0000041A"; -- rs
    s_B <= x"0000041A"; -- rt
    s_imme <= "0000000001100100";


  wait for gCLK_HPER*2;

    s_A <= x"FFFE93EC"; -- rs
    s_B <= x"0000005C"; -- rt
    s_imme <= "0000000001100100";    


  wait for gCLK_HPER*2;

    s_A <= x"FFFFF6D3"; -- rs
    s_B <= x"FFFE93EC"; -- rt
    s_imme <= "0000000001100100";    


-- Expecting
-- "00000000"
-- "00000018"
-- "0000041A"
-- "0000004C"
-- "FFFE92C0

-----------------------------------------------
-- ANDI (NOT DONE)
-----------------------------------------------
  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;


-- values to andi
    s_A <= x"00000000"; -- rs
    s_B <= x"0000041A"; -- rt
    s_imme <= "0000000001100100";
    
    --signals
    s_ALUSrc  <= '1'; --  (0) A+B, (1) A+imme
    s_SEL     <= '0'; -- sel (add(0)-sub(1))
    s_ALUOpSel  <= "0001"; -- ALUOpSel signal
    s_sOverFlow <= '0'; -- overflow mux logic
    s_zeroSignSEL <= '0'; -- select 0/1 infront of immediate
    
  wait for gCLK_HPER*2;

    s_A <= x"0000B331"; -- rs
    s_B <= x"0000041A"; -- rt
    s_imme <= "0000000001100100";



-----------------------------------------------
-- LUI
-----------------------------------------------
  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;


-- values to lui
    s_A <= x"00000000"; -- rs
    s_B <= x"0000041A"; -- rt
    s_imme <= "0000000000001010";
              
    --signals
    s_ALUSrc  <= '0'; --  (0) A+B, (1) A+imme
    s_SEL     <= '0'; -- sel (add(0)-sub(1))
    s_ALUOpSel  <= "0010"; -- ALUOpSel signal
    s_sOverFlow <= '0'; -- overflow mux logic
    s_zeroSignSEL <= '0'; -- select 0/1 infront of immediate


wait for gCLK_HPER*2;
    s_A <= x"000F0000"; -- rs
    s_B <= x"0F00041A"; -- rt
    s_imme <= "1111111111111111";

wait for gCLK_HPER*2;
    s_A <= x"000F0000"; -- rs
    s_B <= x"0F00041A"; -- rt
    s_imme <= "0000100100100110";

wait for gCLK_HPER*2;
    s_A <= x"000F0000"; -- rs
    s_B <= x"0F00041A"; -- rt
    s_imme <= "0000000000000000";

wait for gCLK_HPER*2;
    s_A <= x"000F0000"; -- rs
    s_B <= x"0F00041A"; -- rt
    s_imme <= "0100011110100110";


-- expecting
-- 000a0000
-- ffff0000
-- 09260000
-- 00000000
-- 47a60000

wait;

  end process;

end mixed;