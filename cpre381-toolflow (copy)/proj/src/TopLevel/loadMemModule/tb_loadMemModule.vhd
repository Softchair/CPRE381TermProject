-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_loadMemModule.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the MIPS single cycle 
-- ALU
--              
-- 03/18/2024
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all; -- For logic types I/O
library std;
use std.env.all; -- For hierarchical/external signals
use std.textio.all; -- For basic I/O


entity tb_loadMemModule is
  generic(gCLK_HPER   : time := 10 ns; N : integer := 32);   -- Generic for half of the clock cycle period
end tb_loadMemModule;



architecture mixed of tb_loadMemModule is
-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;


component loadMemModule is

port(
     i_memData    : in std_logic_vector(31 downto 0); -- data from memory address from dmem 
     i_addrData   : in std_logic_vector(1 downto 0); -- last 2 bit of the memory address
     o_LB    : out std_logic_vector(31 downto 0);
     o_LBU    : out std_logic_vector(31 downto 0);
     o_LH    : out std_logic_vector(31 downto 0);
     o_LHU    : out std_logic_vector(31 downto 0)
        
     
);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';


-- outside wires
signal s_memData            : std_logic_vector(31 downto 0); -- data from memory address from dmem 
signal s_addrData            : std_logic_vector(1 downto 0); -- last 2 bit of the memory address
signal s_LB                 : std_logic_vector(31 downto 0); -- LB output
signal s_LBU                 : std_logic_vector(31 downto 0); -- LBU output
signal s_LH                 : std_logic_vector(31 downto 0); -- LH output
signal s_LHU                 : std_logic_vector(31 downto 0); -- LHU output




begin 

DUT0: loadMemModule
  port map(
            i_memData        => s_memData,
            i_addrData        => s_addrData,
            o_LB    => s_LB,
            o_LBU => s_LBU,
            o_LH        => s_LH,
            o_LHU      => s_LHU);

  
    
    P_TEST_CASES: process
  begin
   
----------------------------------
-- LB
----------------------------------

  

    s_memData <= x"12345678"; -- rs
    s_addrData <= "00"; -- rt
    
    -- Expected outputs:
    -- LB : x00000078
    -- LBU : x00000078
    -- LH : x00005678
    -- LHU : x00005678


  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;

  
    s_memData <= x"1234F6F8"; -- rs
    s_addrData <= "00"; -- rt
    
    -- Expected outputs:
    -- LB : xFFFFFFF8
    -- LBU : x000000F8
    -- LH : xFFFFF678
    -- LHU : x0000F6F8


  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;

    s_memData <= x"12345678"; -- rs
    s_addrData <= "01"; -- rt
    
    -- Expected outputs:
    -- LB : x00000056
    -- LBU : x00000056
    -- LH : x00005678
    -- LHU : x00005678


  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;

    s_memData <= x"12345678"; -- rs
    s_addrData <= "10"; -- rt
    
    -- Expected outputs:
    -- LB : x00000034
    -- LBU : x00000034
    -- LH : x00001234
    -- LHU : x00001234


  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;


    s_memData <= x"12345678"; -- rs
    s_addrData <= "11"; -- rt
    
    -- Expected outputs:
    -- LB : x00000012
    -- LBU : x00000012
    -- LH : x00001234
    -- LHU : x00001234


  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;


   s_memData <= x"F2345678"; -- rs
    s_addrData <= "11"; -- rt
    
    -- Expected outputs:
    -- LB : xFFFFFFF2
    -- LBU : x000000F2
    -- LH : xFFFFF234
    -- LHU : x0000F234


  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;


wait;

  end process;

end mixed;