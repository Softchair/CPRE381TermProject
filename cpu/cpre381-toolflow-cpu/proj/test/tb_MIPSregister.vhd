-------------------------------------------------------------------------
-- Emil Kosic
-- College of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_MIPSregister.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a MIPS register file
--              
-- 02/7/2024
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
library std;

entity tb_MIPSregister is
  generic(gCLK_HPER   : time := 50 ns);   -- Generic for half of the clock cycle period
end tb_MIPSregister;



architecture mixed of tb_MIPSregister is

 -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


component MIPSregister is

port(
     i_CLK : in std_logic;
     i_enable    : in std_logic;
     i_rd    : in std_logic_vector(4 downto 0);
     i_rs  : in std_logic_vector(4 downto 0);
     i_rt    : in std_logic_vector(4 downto 0);
     i_rdindata : in std_logic_vector(31 downto 0);
     i_reset : in std_logic;
     o_rsOUT : out std_logic_vector(31 downto 0);
     o_rtOUT : out std_logic_vector(31 downto 0)
);

end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';


-- outside wires
signal s_CLK, s_enable, s_reset   : std_logic;
signal s_rt : std_logic_vector(4 downto 0) := "00000";
signal s_rd : std_logic_vector(4 downto 0) := "00000";
signal s_rs : std_logic_vector(4 downto 0) := "00000";
signal s_rsOUT, s_rtOUT, s_rdindata  : std_logic_vector(31 downto 0);


begin 

DUT0: MIPSregister
  port map(
            i_CLK       => s_CLK,
            i_enable    => s_enable,
            i_rd        => s_rd,
            i_rs        => s_rs,
            i_rt        => s_rt,
            i_rdindata     => s_rdindata,
            i_reset     =>  s_reset,
            o_rsOUT     => s_rsOUT,
            o_rtOUT     => s_rtOUT);




 P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
    
    P_TEST_CASES: process
  begin
    -- Test case 1:
    s_enable  <= '0';
    s_rs <= "00000";
    wait for gCLK_HPER*2;
    s_enable <= '1';
    s_rd <= "00001";
    s_rdindata <= x"FFFFFFFF";
    wait for gCLK_HPER*2;
    s_rt <= "00001";
    wait for gCLK_HPER*2;
    s_rd <= "10010";
    s_enable <= '0';
    s_rdindata <= x"12345678";
    wait for gCLK_HPER*2;
    s_rt <= "10010";
    s_rs <= "00001";
    wait for gCLK_HPER*2;
    s_reset <= '1';
    s_enable <= '0';
    wait for gCLK_HPER*2;
    s_reset <= '0';
  
wait;
  end process;

end mixed;