-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_andG32b.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a N bit And gate (Generic version)
--              
-- 03/18/2024
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all; -- For logic types I/O
library std;
use std.env.all; -- For hierarchical/external signals
use std.textio.all; -- For basic I/O


entity tb_andG32b is
 
  generic(gCLK_HPER   : time := 10 ns; N : integer := 32);   -- Generic for half of the clock cycle period
end tb_andG32b;



architecture mixed of tb_andG32b is
-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;


component andG32b is

port(
      D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, D16,
   D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28, D29, D30, D31 : in std_logic;
   o_Out : out std_logic);

end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';


-- outside wires
signal s_D0           : std_logic;
signal s_D1           : std_logic;
signal s_D2           : std_logic;
signal s_D3           : std_logic;
signal s_D4           : std_logic;
signal s_D5           : std_logic;
signal s_D6           : std_logic;
signal s_D7           : std_logic;
signal s_D8           : std_logic;
signal s_D9           : std_logic;
signal s_D10           : std_logic;
signal s_D11           : std_logic;
signal s_D12           : std_logic;
signal s_D13          : std_logic;
signal s_D14           : std_logic;
signal s_D15           : std_logic;
signal s_D16           : std_logic;
signal s_D17           : std_logic;
signal s_D18           : std_logic;
signal s_D19           : std_logic;
signal s_D20           : std_logic;
signal s_D21           : std_logic;
signal s_D22           : std_logic;
signal s_D23           : std_logic;
signal s_D24           : std_logic;
signal s_D25          : std_logic;
signal s_D26           : std_logic;
signal s_D27           : std_logic;
signal s_D28           : std_logic;
signal s_D29           : std_logic;
signal s_D30          : std_logic;
signal s_D31           : std_logic;
signal s_O            : std_logic;



begin 

DUT0: andG32b
  port map(
    D0 => s_D0,
    D1 => s_D1, 
    D2 => s_D2, 
    D3 => s_D3, 
    D4 => s_D4, 
    D5 => s_D5, 
    D6 => s_D6, 
    D7 => s_D7, 
    D8 => s_D8, 
    D9 => s_D9, 
    D10 => s_D10, 
    D11 => s_D11, 
    D12 => s_D12, 
    D13 => s_D13, 
    D14 => s_D14, 
    D15 => s_D15, 
    D16 => s_D16,
    D17 => s_D17, 
    D18 => s_D18,
          D19 => s_D19,
           D20 => s_D20,
           D21 => s_D21, 
           D22 => s_D22,
           D23 => s_D23,
           D24 => s_D24,
           D25 => s_D25,
           D26 => s_D26,
           D27 => s_D27,
           D28 => s_D28, 
           D29 => s_D29,
           D30 => s_D30,
           D31 => s_D31,
           o_Out        => s_O);


P_TEST_CASES: process
  begin
    -- Test case 1:
    s_D0 <= '1';
    s_D1 <= '1';
    s_D2 <= '1';
    s_D3 <= '1';
    s_D4 <= '1';
    s_D5 <= '1';
    s_D6 <= '1';
    s_D7 <= '1';
    s_D8 <= '1';
    s_D9 <= '1';
    s_D10 <= '1';
    s_D11 <= '1';
    s_D12 <= '1';
    s_D13 <= '1';
    s_D14 <= '1';
    s_D15 <= '1';
    s_D16 <= '1';
    s_D17 <= '1';
    s_D18 <= '1';
    s_D19 <= '1';
    s_D20 <= '1';
    s_D21 <= '1';
    s_D22 <= '1';
    s_D23 <= '1';
    s_D24 <= '1';
    s_D25 <= '1';
    s_D26 <= '1';
    s_D27 <= '1';
    s_D28 <= '1';
    s_D29 <= '1';
    s_D30 <= '1';
    s_D31 <= '1';

     wait for gCLK_HPER;
    -- Expect:
    -- 1
    
 -- Test case 2:
    s_D0 <= '1';
    s_D1 <= '1';
    s_D2 <= '0';
    s_D3 <= '1';
    s_D4 <= '1';
    s_D5 <= '1';
    s_D6 <= '1';
    s_D7 <= '1';
    s_D8 <= '1';
    s_D9 <= '1';
    s_D10 <= '1';
    s_D11 <= '1';
    s_D12 <= '1';
    s_D13 <= '1';
    s_D14 <= '1';
    s_D15 <= '1';
    s_D16 <= '1';
    s_D17 <= '1';
    s_D18 <= '1';
    s_D19 <= '1';
    s_D20 <= '1';
    s_D21 <= '1';
    s_D22 <= '1';
    s_D23 <= '1';
    s_D24 <= '1';
    s_D25 <= '1';
    s_D26 <= '1';
    s_D27 <= '1';
    s_D28 <= '1';
    s_D29 <= '1';
    s_D30 <= '1';
    s_D31 <= '1';

     wait for gCLK_HPER;
    -- Expect:
    -- 0

 -- Test case 3:
    s_D0 <= '1';
    s_D1 <= '1';
    s_D2 <= '1';
    s_D3 <= '1';
    s_D4 <= '1';
    s_D5 <= '1';
    s_D6 <= '1';
    s_D7 <= '1';
    s_D8 <= '1';
    s_D9 <= '1';
    s_D10 <= '0';
    s_D11 <= '1';
    s_D12 <= '1';
    s_D13 <= '1';
    s_D14 <= '1';
    s_D15 <= '1';
    s_D16 <= '1';
    s_D17 <= '0';
    s_D18 <= '1';
    s_D19 <= '1';
    s_D20 <= '0';
    s_D21 <= '1';
    s_D22 <= '1';
    s_D23 <= '1';
    s_D24 <= '1';
    s_D25 <= '1';
    s_D26 <= '1';
    s_D27 <= '1';
    s_D28 <= '1';
    s_D29 <= '1';
    s_D30 <= '1';
    s_D31 <= '1';

 wait for gCLK_HPER;
    
    -- Expect:
    -- 0
  


wait;
  end process;

end mixed;