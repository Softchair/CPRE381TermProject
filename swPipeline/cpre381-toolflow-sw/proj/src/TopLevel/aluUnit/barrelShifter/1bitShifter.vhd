-- -------------------------------------------------------------------------
-- -- Emil Kosic and Camden Fergen
-- -- Department of Electrical and Computer Engineering
-- -- Iowa State University
-- -------------------------------------------------------------------------


-- -- 1bitShifter.vhd
-- -------------------------------------------------------------------------
-- -- DESCRIPTION: This file implements a generic 1 bit shifter
-- -------------------------------------------------------------------------

-- library IEEE;
-- use IEEE.std_logic_1164.all;

-- entity 1bitShifter is
--     generic(N : integer := 32);
--     port(
--         i_Sel   : in std_logic; -- Shift direction: '0' for left, '1' for right
--         i_Shamt : in std_logic; -- Shift ammount (1 or 0)
--         i_Data  : in std_logic; -- Input bit
--         o_Data  : out std_logic -- Output bit after shifting
--  );
-- end 1bitShifter;

-- architecture structural of 1bitShifter is

--     component mux2t1_N is
--        generic(N : integer := 1);
--        port(
--          i_S : in std_logic;
--          i_D0 : in std_logic_vector(N-1 downto 0);
--          i_D1 : in std_logic_vector(N-1 downto 0);
--          o_O : out std_logic_vector(N-1 downto 0)
--        );
--     end component;

--     component invg is
--         port(
--           i_D : in std_logic;
--           o_O : out std_logic
--         );
--     end component;

--     component andgN is
--         generic(N: integer := 32);
--         port(
--             i_A : in std_logic_vector(N-1 downto 0);
--             i_B : in std_logic_vector(N-1 downto 0);
--             o_F : in std_logic_vector(N-1 downto 0)
--         );
--     end component;

--     signal s_inverted         : std_logic_vector(N-1 downto 0);

--     signal s_shift

--     signal s_leftShiftMux     : std_logic_vector(N-1 downto 0);
--     signal s_rightShiftMux    : std_logic_vector(N-1 downto 0);

--     begin

--         -- Invert for right shift
--         g_NBit_inv: for i in N-1 downto 0 generate
--             invgi: invg port map (
--                 i_D     => i_Data(i),
--                 o_O     => s_inverted(i)
--             );
--         end generate g_NBit_inv;

--         -- Shifting left
--         g_shiftLeftMux: mux2t1_N
--             port map(
--                 i_S     => i_Shamt,
--                 i_D0    => i_Data,
--                 i_D1    => i_Data(N-1 downto 1),
--                 o_Out   => s_leftShiftMux
--             )

--         -- Shifting left
--         g_shiftRightMux: mux2t1_N
--             port map(
--                 i_S     => i_Shamt,
--                 i_D0    => i_Data,
--                 i_D1    => i_Data(N-2 downto 0),
--                 o_Out   => s_leftShiftMux
--             )
        
