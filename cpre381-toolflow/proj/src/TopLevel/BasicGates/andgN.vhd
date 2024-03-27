-------------------------------------------------------------------------
-- Camden Fergen
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- andgN.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a generic and gate
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity andgN is
    generic(N : integer := 32); -- Generic size of 32
    port(i_A    : in std_logic_vector(N-1 downto 0);
         i_B    : in std_logic_vector(N-1 downto 0);
         o_F    : out std_logic_vector(N-1 downto 0);
    )

end andgN;

architecture structural of andgN is

    component andg2 is
        port(
            i_A          : in std_logic;
            i_B          : in std_logic;
            o_F          : out std_logic);
    end component;

    begin

        -- INstantiate N and instances
        G_NBit_and: for i in 0 to N-1 generate
            andgi: andg2 port map(
                i_A     => i_A(i),
                i_B     => i_B(i),
                o_F     => o_F(i)
            );
        end generate G_Nbit_and;

    end structural;
 