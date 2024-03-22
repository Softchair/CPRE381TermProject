-------------------------------------------------------------------------
-- Emil Kosic
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPSregister.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a MIPS register file
-- using structures
-- NOTES:
-- 2/7/24
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.register_package.all;


entity MIPSregister is
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

end MIPSregister;





architecture structure of MIPSregister is

component decoder5_32

  port(D_IN : in std_logic_vector(4 downto 0);
       F_OUT : out std_logic_vector(31 downto 0)
      );


end component;






component dffgN

  port(i_CLK        : in std_logic;
       i_RST         : in std_logic;
       i_WE         : in std_logic;
       i_D          : in std_logic_vector(31 downto 0);
       o_Q       : out std_logic_vector(31 downto 0));

end component;


component mux32_1

  port(D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11,
          D12, D13, D14, D15, D16, D17, D18, D19, D20, D21, D22,
          D23, D24, D25, D26, D27, D28, D29, D30, D31 : in std_logic_vector(31 downto 0);
         o_OUT : out std_logic_vector(31 downto 0);
         SEL : in std_logic_vector(4 downto 0));

end component;


component andg2

port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);


end component;




-- Signals
signal s_DOUT : std_logic_vector(31 downto 0);
signal s_ANDOUT : std_logic_vector(31 downto 0);
signal s_R0 : std_logic_vector(31 downto 0); 
signal s_R1 : std_logic_vector(31 downto 0);  
signal s_R2 : std_logic_vector(31 downto 0); 
signal s_R3 : std_logic_vector(31 downto 0); 
signal s_R4 : std_logic_vector(31 downto 0); 
signal s_R5 : std_logic_vector(31 downto 0); 
signal s_R6 : std_logic_vector(31 downto 0); 
signal s_R7 : std_logic_vector(31 downto 0); 
signal s_R8 : std_logic_vector(31 downto 0); 
signal s_R9 : std_logic_vector(31 downto 0); 
signal s_R10 : std_logic_vector(31 downto 0); 
signal s_R11 : std_logic_vector(31 downto 0);
signal s_R12 : std_logic_vector(31 downto 0); 
signal s_R13 : std_logic_vector(31 downto 0);
signal s_R14 : std_logic_vector(31 downto 0);
signal s_R15 : std_logic_vector(31 downto 0); 
signal s_R16 : std_logic_vector(31 downto 0);
signal s_R17 : std_logic_vector(31 downto 0);  
signal s_R18 : std_logic_vector(31 downto 0);   
signal s_R19 : std_logic_vector(31 downto 0); 
signal s_R20 : std_logic_vector(31 downto 0);
signal s_R21 : std_logic_vector(31 downto 0);
signal s_R22 : std_logic_vector(31 downto 0);    
signal s_R23 : std_logic_vector(31 downto 0); 
signal s_R24 : std_logic_vector(31 downto 0); 
signal s_rsOUT      : std_logic_vector(31 downto 0); 
signal s_rtOUT      : std_logic_vector(31 downto 0); 
signal s_REG : t_bus_32x32;



begin


-- level 0: the decoder
g_decoder: decoder5_32
  port MAP(D_IN   => i_rd,
          F_OUT   =>  s_DOUT);

-- level 1: write enable




  
  G_NBit_AND: for i in 0 to 31 generate
    DEC: andg2 port map(
              i_A      => i_enable,      -- All instances share the same select input.
	      i_B      => s_DOUT(i),
              o_F      => s_ANDOUT(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_AND;
  
 

-- Level 2: Registers


G_NBit_REGISTER: for i in 0 to 31 generate
    REG: dffgN port map(
   --    i_CLK        : in std_logic;
   --    i_RST         : in std_logic;
   --    i_WE         : in std_logic;
   --    i_D          : in std_logic_vector(31 downto 0);
    --   o_Q       : out std_logic_vector(31 downto 0));  
              i_CLK      => i_CLK,      -- All instances share the same select input.
	      i_RST      => i_reset,
              i_WE      => s_ANDOUT(i),
              i_D       => i_rdindata,
              o_Q       => s_REG(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_REGISTER;



-- Level 3: Mux's
g_mux01: mux32_1 -- rs mux
  port MAP(D0 => s_REG(0),
           D1 => s_REG(1), 
           D2 => s_REG(2), 
           D3 => s_REG(3), 
           D4 => s_REG(4), 
           D5 => s_REG(5), 
           D6 => s_REG(6), 
           D7 => s_REG(7), 
           D8 => s_REG(8), 
           D9 => s_REG(9), 
           D10 => s_REG(10), 
           D11 => s_REG(11),
           D12 => s_REG(12), 
           D13 => s_REG(13), 
           D14 => s_REG(14),
           D15 => s_REG(15), 
           D16 => s_REG(16), 
           D17 => s_REG(17), 
           D18 => s_REG(18), 
           D19 => s_REG(19), 
           D20 => s_REG(20), 
           D21 => s_REG(21), 
           D22 => s_REG(22),
           D23 => s_REG(23), 
           D24 => s_REG(24), 
           D25 => s_REG(25), 
           D26 => s_REG(26), 
           D27 => s_REG(27), 
           D28 => s_REG(28), 
           D29 => s_REG(29), 
           D30 => s_REG(30), 
           D31 => s_REG(31),
           o_OUT => o_rsOUT,
           SEL => i_rs);


g_mux02: mux32_1 -- rt mux
  port MAP(D0 => s_REG(0),
           D1 => s_REG(1), 
           D2 => s_REG(2), 
           D3 => s_REG(3), 
           D4 => s_REG(4), 
           D5 => s_REG(5), 
           D6 => s_REG(6), 
           D7 => s_REG(7), 
           D8 => s_REG(8), 
           D9 => s_REG(9), 
           D10 => s_REG(10), 
           D11 => s_REG(11),
           D12 => s_REG(12), 
           D13 => s_REG(13), 
           D14 => s_REG(14),
           D15 => s_REG(15), 
           D16 => s_REG(16), 
           D17 => s_REG(17), 
           D18 => s_REG(18), 
           D19 => s_REG(19), 
           D20 => s_REG(20), 
           D21 => s_REG(21), 
           D22 => s_REG(22),
           D23 => s_REG(23), 
           D24 => s_REG(24), 
           D25 => s_REG(25), 
           D26 => s_REG(26), 
           D27 => s_REG(27), 
           D28 => s_REG(28), 
           D29 => s_REG(29), 
           D30 => s_REG(30), 
           D31 => s_REG(31),
           o_OUT => o_rtOUT,
           SEL => i_rt);



		
end structure;
