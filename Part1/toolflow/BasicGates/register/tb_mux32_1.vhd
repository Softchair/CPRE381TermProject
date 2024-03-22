-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_mux32_1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a test bench for 
-- a 32 bit 31:1 mux
--
-- NOTES:
-- 2/4/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_mux32_1 is
  generic(gCLK_HPER   : time := 50 ns; N : integer := 32);
end tb_mux32_1;

architecture behavior of tb_mux32_1 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component mux32_1
    port(
          D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11,
          D12, D13, D14, D15, D16, D17, D18, D19, D20, D21, D22,
          D23, D24, D25, D26, D27, D28, D29, D30, D31 : in std_logic_vector(31 downto 0);
         o_OUT : out std_logic_vector(31 downto 0);
         SEL : in std_logic_vector(4 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_SEL : std_logic_vector(4 downto 0);
  signal s_OUT : std_logic_vector(31 downto 0);
  signal s_D0, s_D1, s_D2, s_D3, s_D4, s_D5, s_D6, s_D7, s_D8, s_D9, s_D10, s_D11,
          s_D12, s_D13, s_D14, s_D15, s_D16, s_D17, s_D18, s_D19, s_D20, s_D21, s_D22,
          s_D23, s_D24, s_D25, s_D26, s_D27, s_D28, s_D29, s_D30, s_D31 : std_logic_vector(31 downto 0);

begin

  DUT: mux32_1 
  port map(SEL => s_SEL, 
           o_OUT => s_OUT,
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
           D31 => s_D31);




 
P_TEST_CASES: process
  begin
    -- Test cases:
    
    
    s_D1 <= x"0000000F";
    s_D5 <= x"FFFFFFFF";
    s_D0 <= x"01FF000F";
    s_D12 <= x"00000000";
    s_D31 <= x"ABCDEF12";
    s_D20 <= x"0BF10900";
    s_D24 <= x"B2500000";
    s_D9 <= x"000CE293";
    s_D28 <= x"32813243";

    s_SEL <= "00000";

   wait for gCLK_HPER;

    s_SEL <= "00001";
   wait for gCLK_HPER;

    s_SEL <= "00101";
   wait for gCLK_HPER;

    s_SEL <= "10100";
   wait for gCLK_HPER;

    s_SEL <= "11100";
   wait for gCLK_HPER;

    s_SEL <= "11111";

wait;
  end process;


  
end behavior;