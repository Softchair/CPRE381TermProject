------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_stallFlush.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the first Data Path
--              
-- 02/14/2024
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all; -- For logic types I/O
library std;
use std.env.all; -- For hierarchical/external signals
use std.textio.all; -- For basic I/O


entity tb_stallFlush is
  generic(gCLK_HPER   : time := 10 ns; N : integer := 32);   -- Generic for half of the clock cycle period
end tb_stallFlush;



architecture mixed of tb_stallFlush is
-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;


component stallFLush is

port(i_CLK        : in std_logic;
       i_stall      : in std_logic;
       i_flush      : in std_logic;
       i_dataIn          : in std_logic_vector(31 downto 0);
       o_dataOut    : out std_logic_vector(31 downto 0));

     
     

end component;




-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';


-- outside wires
signal s_dataIn : std_logic_vector(31 downto 0);
signal s_stall  : std_logic;
signal s_flush  : std_logic;
signal s_dataOut : std_logic_vector(31 downto 0);
signal s_CLK         : std_logic; 





begin 

DUT0: stallFLush
  port map( i_stall       => s_stall,
            i_flush       => s_flush,
            i_dataIn      => s_dataIn,
            o_dataOut     => s_dataOut,
            i_CLK     => s_CLK);


 P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
    
    P_TEST_CASES: process
  begin
   
 

  ---load data in
 s_dataIn <= x"FFFFFFFF";
 s_stall <= '0';
 s_flush <= '0';

wait for gCLK_HPER*2;

-- 3 cycle stall

  

 s_dataIn <= x"0000000F";
 s_stall <= '1';
 s_flush <= '0';

  wait for gCLK_HPER*2;

 s_dataIn <= x"0000000F";
 s_stall <= '1';
 s_flush <= '0';

  wait for gCLK_HPER*2;

 s_dataIn <= x"0000000F";
 s_stall <= '1';
 s_flush <= '0';


  wait for gCLK_HPER*2;
-- load new data in

 s_dataIn <= x"0000000F";
 s_stall <= '0';
 s_flush <= '0';

  wait for gCLK_HPER*2;
-- flush 1 cycle

 s_dataIn <= x"EEEEEEEE";
 s_stall <= '0';
 s_flush <= '1';

  wait for gCLK_HPER*2;
-- stall and flush 1 cycle

 s_dataIn <= x"ABCABCAB";
 s_stall <= '1';
 s_flush <= '1';

  wait for gCLK_HPER*2;
-- stall 1 cycle

 s_dataIn <= x"ABCABCAB";
 s_stall <= '1';
 s_flush <= '0';


  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;
-- load new data in

 s_dataIn <= x"ABCABCAB";
 s_stall <= '0';
 s_flush <= '0';

wait;

  end process;

end mixed;