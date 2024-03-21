-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

-----------------------------------------------
--SIGNALS
-----------------------------------------------

-------------------
--Fetch related signals
------------------
signal s_branchUnit : std_logic; -- branch unit logic output to mux of fetch


-------------------
--control logic
-------------------
signal s_controlOut : std_logic_vector(21 downto 0); -- control output signals

-------------------
--signals from iMEM
-------------------

signal s_opcode : std_logic_vector(5 downto 0); -- Opcode signal
signal s_rs : std_logic_vector(4 downto 0); -- rs signal
signal s_rt : std_logic_vector(4 downto 0); -- rt signal
signal s_rd : std_logic_vector(4 downto 0); -- rd signal
signal s_jump : std_logic_vector(25 downto 0); -- rd signal
signal s_imme : std_logic_vector(15 downto 0); -- immediate signal
signal s_func : std_logic_vector(5 downto 0); -- func signal
-------------------
--signals between register and ALU
-------------------
signal s_rsOut: std_logic_vector(31 downto 0); -- rs out of reg
signal s_rtOut: std_logic_vector(31 downto 0); -- rt out of reg
signal s_extender : std_logic_vector(31 downto 0); -- extended value going into mux
signal s_regSelMuxOut : std_logic_vector(4 downto 0); -- mux out

-------------------
--signals from data
-------------------

signal s_databeforeMux: std_logic_vector(31 downto 0); -- signal from load byte mux

-------------------
--signals after ALU
-------------------
signal s_aluDataOut : std_logic_vector(31 downto 0); -- signal for data output of ALU
signal s_memRegMuxOut : std_logic_vector(31 downto 0); -- signal for data output of memtoregmux
signal s_lb :  std_logic_vector(31 downto 0); -- lb signal from load module
signal s_lbu :  std_logic_vector(31 downto 0); -- lbu signal from load module
signal s_lh :  std_logic_vector(31 downto 0); -- lh signal from load module
signal s_lhu :  std_logic_vector(31 downto 0); -- lhu signal from load module
signal s_zero : std_logic; -- for branching 
signal s_afterBEAnd : std_logic; -- signal going into branch OR
signal s_afterBNEINV : std_logic; -- signal after inv for BNE
signal s_afterBNEAnd : std_logic; -- signal going into OR for branch
-----------------------
--Large components
-----------------------


  component control_Logic is -- control unit 
    port ( 
      i_DOpcode : in std_logic_vector(5 downto 0);
      i_DFunc : in std_logic_vector(5 downto 0);
      o_signals : out std_logic_vector(21 downto 0));
      end component;

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
     o_rtOUT : out std_logic_vector(31 downto 0));

     end component;

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
     o_overFlow : out std_logic; -- overflow output
     o_zero : out std_logic -- zero output that goes to branch logic
     );

     end component;




component fetch_logic is 
port (
  i_CLK           : IN STD_LOGIC; -- Clock
  i_RST           : IN STD_LOGIC; -- Reset
  -- Register inputs
  i_JReg          : IN STD_LOGIC_VECTOR(31 downto 0); -- Jump register input
  -- Control logic inputs
  i_BranchLogic   : IN STD_LOGIC; -- Branch logic control, 1 if branch
  i_JumpLogic     : IN STD_LOGIC; -- Jump logic control, 1 if jump
  i_JRegLogic     : IN STD_LOGIC; -- Jump register logic control, 1 if jump reg
  
  -- Instruction input
  i_Instruction   : IN STD_LOGIC_VECTOR(31 downto 0); -- Instruction output
  -- Ouput
  o_PCAddress     : OUT STD_LOGIC_VECTOR(31 downto 0) -- PC Address for JAL box
);
  end component;










------------------------
-- bit extender
------------------------



  component bit_extenders is
    port ( 
      i_Din : in std_logic_vector(15 downto 0);
      o_OUT : out std_logic_vector(31 downto 0);
      SEL : in std_logic);
      end component;


 

-----------------------
--mux's
-----------------------

   component mux2t1_5b is -- 5 bit wide 2t1 mux
   port(i_S          : in std_logic;
   i_D0         : in std_logic_vector(4 downto 0);
   i_D1         : in std_logic_vector(4 downto 0);
   o_O          : out std_logic_vector(4 downto 0));
     end component;


     component mux2t1_N is -- 32 bit wide 2t1 mux
   port(i_S          : in std_logic;
   i_D0         : in std_logic_vector(N-1 downto 0);
   i_D1         : in std_logic_vector(N-1 downto 0);
   o_O          : out std_logic_vector(N-1 downto 0));
     end component;
  

     component mux32b3t1 is -- 32 bit 3t1 mux
     port ( D0, D1, D2, D3, D4, D5, D6, D7: in std_logic_vector(31 downto 0);
     o_OUT : out std_logic_vector(31 downto 0);
     SEL : in std_logic_vector(2 downto 0));
     end component;


---------------------
--load mem module
--------------------


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

----------------------
--branching "unit"
----------------------

component andg2 is 

port(i_A          : in std_logic;
i_B          : in std_logic;
o_F          : out std_logic);

  end component;


component invg is 
port(i_A          : in std_logic;
o_F          : out std_logic);

  end component;

component org2 is 

port(i_A          : in std_logic;
i_B          : in std_logic;
o_F          : out std_logic);

  end component;



begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);


  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

-----------------------
--Fetch logic
-----------------------

fetchUnit : fetch_logic
port map(
  i_CLK  => iCLK,       
  i_RST  => iRST,        
  -- Register inputs
  i_JReg =>  s_rsOut,
  -- Control logic inputs
  i_BranchLogic => s_branchUnit,
  i_JumpLogic   => s_controlOut(14),
  i_JRegLogic   => s_controlOut(12),   
 
  -- Instruction input
  i_Instruction => s_Inst,-- Instruction output
  -- Ouput
  o_PCAddress   => s_NextInstAddr);


  BranchEqualAnd : andg2
  port map(
    i_A     =>  s_controlOut(15),
    i_B     =>  s_zero,
    o_F     => s_afterBEAnd);

    BranchNotEqualAnd : andg2
    port map(
      i_A     =>  s_controlOut(14),
      i_B     =>  s_afterBNEINV,
      o_F     => s_afterBNEAnd);


   BranchInv : invg 
   port map(
    i_A  => s_zero,     
    o_F  =>  s_afterBNEINV);
   

    BranchOr : org2
    port map(
      i_A    => s_afterBEAnd,
      i_B    => s_afterBNEAnd,
      o_F    => s_branchUnit);

------------------
--between imem and reg
------------------


muxWrAddr : mux2t1_5b

port map(
             i_S  => s_controlOut(17), 
             i_D0 => s_Inst(15 downto 11), 
             i_D1 => s_Inst(20 downto 16),   
             o_O  => s_RegWrAddr);

muxjal : mux2t1_N

port map(
             i_S  => s_controlOut(13), 
             i_D0 => s_databeforeMux, 
             i_D1 => s_NextInstAddr,   
             o_O  => s_RegWrData);



 RegisterMod : MIPSregister 

 port map(i_CLK => iCLK,
          i_enable  => s_RegWr,
          i_rd      => s_Inst(15 downto 11), 
          i_rs      => s_Inst(25 downto 21), 
          i_rt      => s_Inst(20 downto 16), 
          i_rdindata => s_RegWrData,
          i_reset    => iRST, 
          o_rsOUT    => s_rsOut,
          o_rtOUT    => s_rtOut);


  controlUnit : control_logic 

  port map(i_DOpcode   => s_Inst(31 downto 26),
           i_DFunc     => s_Inst(5 downto 0),
           o_signals =>  s_controlOut);


  
------------------
--between reg and ALU
------------------

ALUmod : ALU
 
 port map(
      i_A => s_rsOut,  
      i_B => s_rtOut,   
      i_imme => s_Inst(15 downto 0),
      i_zeroSignSEL => s_controlOut(5),  
      i_SEL         => s_controlOut(20),
      ALUSrc        => s_controlOut(21),
      i_ALUOpSel    => s_controlOut(10 downto 7), 
      o_DataOut     => s_aluDataOut,
      i_sOverFlow   => s_controlOut(6),
      o_overFlow    => s_Ovfl);


s_DMemAddr <= s_aluDataOut ;
oALUOut <= s_aluDataOut  ;
s_DMemData       <= s_rtOut  ;
s_DMemWr <= s_controlOut(18);
s_rd            <= s_Inst(15 downto 11);
s_rt            <= s_Inst(20 downto 16);
s_rs            <= s_Inst(25 downto 21);

muxmemToReg : mux2t1_N

port map(
             i_S  => s_controlOut(19), 
             i_D0 => s_rtOut, 
             i_D1 => s_aluDataOut,   
             o_O  => s_memRegMuxOut);

 loadMemModuleMod : loadMemModule
 
 port map(
     i_memData   =>  s_memRegMuxOut,
     i_addrData  =>  s_aluDataOut(1 downto 0),
     o_LB        => s_lb, 
     o_LBU       => s_lbu,
     o_LH        => s_lh,
     o_LHU       => s_lhu);
 

  muxFinalData : mux32b3t1

  port map(
    D0 => s_memRegMuxOut, 
    D1 => s_lb, 
    D2 => s_lbu, 
    D3 => s_lh, 
    D4 => s_lhu, 
    D5 => s_memRegMuxOut, --not used
    D6 => s_memRegMuxOut, --not used
    D7 => s_memRegMuxOut, -- not used
    o_OUT => s_databeforeMux,
    SEL => s_controlOut(3 downto 1));

  

 




  -- TODO: Implement the rest of your processor below this comment! 

end structure;

