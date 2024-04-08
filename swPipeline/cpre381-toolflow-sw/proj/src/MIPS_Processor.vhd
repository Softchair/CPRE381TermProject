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
signal s_RegWrAddrBefore : std_logic_vector(4 downto 0); -- one mux to another
signal s_jalAddnext  :  std_logic_vector(31 downto 0); -- NEW

--------------------
--PipelineSignals
--------------------
--IF/ID reg
signal s_IF_ID_in :  std_logic_vector(95 downto 0); -- signal going into if/id reg
signal s_IF_ID_out : std_logic_vector(95 downto 0); -- signal coming out of if/id reg
--ID stage internal
signal s_ID_inst : std_logic_vector(31 downto 0); -- instructions for ID stage
signal s_ID_PC4 : std_logic_vector(31 downto 0); -- PC+4 for ID stage
signal s_ID_JalAdd : std_logic_vector(31 downto 0); -- JalAdd for ID stage
signal s_ID_RegWrAddr : std_logic_vector(4 downto 0); -- regWrAddr output from muxes
signal s_subtractorOut : std_logic_vector(31 downto 0); -- zero logic subtractor output
signal s_orGateZeroOut : std_logic; -- output of or gate zero logic
signal s_zeroID : std_logic; -- zero signal in ID stage
signal s_IDcontrol : std_logic_vector(21 downto 0); -- control signals ID stage
signal s_ID_imme : std_logic_vector(15 downto 0); -- imme value from instruciton mem for ID stage 
signal s_rsOutID : std_logic_vector(31 downto 0); -- rs out in ID stage
signal s_rtOutID : std_logic_vector(31 downto 0); -- rt out in ID stage

--ID/EX Reg
signal s_ID_EX_in :  std_logic_vector(133 downto 0); -- signal going into ID/EX reg
signal s_ID_EX_out : std_logic_vector(133 downto 0); -- signal coming out of ID/EX reg
--EX stage internal
signal s_aluDataOutEX : std_logic_vector(31 downto 0); -- alu data out EX stage
signal s_OvflEX : std_logic; -- overflow logic EX stage

--EX/MEM Reg
signal s_EX_MEM_in :  std_logic_vector(109 downto 0); -- signal going into EX/MEM reg
signal s_EX_MEM_out : std_logic_vector(109 downto 0); -- signal coming out of EX/MEM reg

--MEM/WB Reg
signal s_MEM_WB_in :  std_logic_vector(108 downto 0); -- signal going into MEM/WB reg
signal s_MEM_WB_out : std_logic_vector(108 downto 0); -- signal coming out of MEM/WB reg

--internal WB signals
signal s_dataInWB : std_logic_vector(31 downto 0); -- reg data in WB stage
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
  o_PCAddress     : OUT STD_LOGIC_VECTOR(31 downto 0); -- PC Address for JAL box
  o_jalAdd  : OUT STD_LOGIC_VECTOR(31 downto 0) -- NEW
);
  end component;

-----------------------
--Zero output "unit"
-----------------------

component adderSubS is 
port(
     i_D0    : in std_logic_vector(31 downto 0); -- reg A input
     i_D1   : in std_logic_vector(31 downto 0); -- reg B input
     i_SEL  : in std_logic;
     o_O    : out std_logic_vector(31 downto 0);
     o_Cout : out std_logic);

     end component;

component orG32b

port(
       D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, D16,
   D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28, D29, D30, D31 : in std_logic;
   o_Out : out std_logic);

end component;

-----------------------
--Branching unit
-----------------------

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



-----------------------
--Pipeline Registers
-----------------------
component IF_ID_Reg is 
port (
i_CLK        : in std_logic;
i_RST         : in std_logic;
i_WE         : in std_logic;
i_D          : in std_logic_vector(95 downto 0);
o_Q       : out std_logic_vector(95 downto 0));

  end component;

component ID_EX_Reg is 
port (
i_CLK        : in std_logic;
i_RST         : in std_logic;
i_WE         : in std_logic;
i_D          : in std_logic_vector(133 downto 0);
o_Q       : out std_logic_vector(133 downto 0));

  end component;


component EX_MEM_Reg is 
port (
i_CLK        : in std_logic;
i_RST         : in std_logic;
i_WE         : in std_logic;
i_D          : in std_logic_vector(109 downto 0);
o_Q       : out std_logic_vector(109 downto 0));

  end component;

  component MEM_WB_Reg is 
port (
i_CLK        : in std_logic;
i_RST         : in std_logic;
i_WE         : in std_logic;
i_D          : in std_logic_vector(108 downto 0);
o_Q       : out std_logic_vector(108 downto 0));

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
  i_JumpLogic   => s_IDcontrol(13),
  i_JRegLogic   => s_IDcontrol(11),   
 
  -- Instruction input
  i_Instruction => s_Inst,-- Instruction output
  -- Ouput
  o_PCAddress   => s_NextInstAddr,
  o_jalAdd      => s_jalAddnext); -- NEW


 

------------------
--between imem and reg
------------------

------------------
--IF/ID 
------------------

--IF/ID input signal
s_IF_ID_in(31 downto 0) <= s_Inst;
s_IF_ID_in(63 downto 32) <= s_jalAddnext; -- same as PC+4
s_IF_ID_in(95 downto 64) <= s_jalAddnext; -- save jal instruction (duplicate)

-- IF/ID output signal
s_ID_inst <= s_IF_ID_out(31 downto 0);
s_ID_PC4 <= s_IF_ID_out(63 downto 32);
s_ID_JalAdd <= s_IF_ID_out(95 downto 64);
s_ID_imme <= s_ID_inst(15 downto 0);
-- Zero logic Subtractor output signals


IfIdReg : IF_ID_Reg
 
 port map(
  i_CLK  => iCLK,
  i_RST  => iRST,
  i_WE   => '1',   
  i_D    => s_IF_ID_in,
  o_Q      => s_IF_ID_out);
 

muxWrAddr : mux2t1_5b

port map(
             i_S  => s_IDcontrol(16), 
             i_D0 => s_ID_inst(15 downto 11), 
             i_D1 => s_ID_inst(20 downto 16),   
             o_O  => s_RegWrAddrBefore);


muxWrAddr02 : mux2t1_5b

port map(
             i_S  => s_IDcontrol(12), 
             i_D0 => s_RegWrAddrBefore, 
             i_D1 => "11111",   
             o_O  => s_ID_RegWrAddr);


 RegisterMod : MIPSregister 

 port map(i_CLK => iCLK,
          i_enable  => s_regWr, -- to add
          i_rd      => s_RegWrAddr, -- addr
          i_rs      => s_ID_inst(25 downto 21), 
          i_rt      => s_ID_inst(20 downto 16), 
          i_rdindata => s_RegWrData, --to add
          i_reset    => iRST, 
          o_rsOUT    => s_rsOutID,
          o_rtOUT    => s_rtOutID);


  controlUnit : control_logic 

  port map(i_DOpcode   => s_ID_inst(31 downto 26),
           i_DFunc     => s_ID_inst(5 downto 0),
           o_signals =>  s_IDcontrol);


------------------
-- Zero "Unit"
------------------

subtractor : adderSubs
 port map(

     i_D0  => s_rsOutID, -- reg A input
     i_D1  => s_rtOutID, -- reg B input
     i_SEL => '1',
     o_O   => s_subtractorOut,
     o_Cout => open);
 

     g_orG32 : orG32b
     port MAP(
       D0 => s_subtractorOut(0),
       D1 => s_subtractorOut(1), 
       D2 => s_subtractorOut(2), 
       D3 => s_subtractorOut(3), 
       D4 => s_subtractorOut(4), 
       D5 => s_subtractorOut(5), 
       D6 => s_subtractorOut(6), 
       D7 => s_subtractorOut(7), 
       D8 => s_subtractorOut(8), 
       D9 => s_subtractorOut(9), 
       D10 => s_subtractorOut(10), 
       D11 => s_subtractorOut(11), 
       D12 => s_subtractorOut(12), 
       D13 => s_subtractorOut(13), 
       D14 => s_subtractorOut(14), 
       D15 => s_subtractorOut(15), 
       D16 => s_subtractorOut(16),
       D17 => s_subtractorOut(17), 
       D18 => s_subtractorOut(18),
             D19 => s_subtractorOut(19),
              D20 => s_subtractorOut(20),
              D21 => s_subtractorOut(21), 
              D22 => s_subtractorOut(22),
              D23 => s_subtractorOut(23),
              D24 => s_subtractorOut(24),
              D25 => s_subtractorOut(25),
              D26 => s_subtractorOut(26),
              D27 => s_subtractorOut(27),
              D28 => s_subtractorOut(28), 
              D29 => s_subtractorOut(29),
              D30 => s_subtractorOut(30),
              D31 => s_subtractorOut(31),
              o_Out        => s_orGateZeroOut);
   
   
   g_invg : invg 
     port MAP(
            i_A   => s_orGateZeroOut,
            o_F   => s_zeroID);
   

------------------
-- branch "unit" -- do we need fetch logic in decode unit??
------------------
 BranchEqualAnd : andg2
  port map(
    i_A     =>  s_IDcontrol(15),
    i_B     =>  s_zeroID,
    o_F     => s_afterBEAnd);

    BranchNotEqualAnd : andg2
    port map(
      i_A     =>  s_IDcontrol(14),
      i_B     =>  s_afterBNEINV,
      o_F     => s_afterBNEAnd);


   BranchInv : invg 
   port map(
    i_A  => s_zeroID,     
    o_F  =>  s_afterBNEINV);
   

    BranchOr : org2
    port map(
      i_A    => s_afterBEAnd,
      i_B    => s_afterBNEAnd,
      o_F    => s_branchUnit);
           

  


------------------
--ID/EX
------------------
--ID/EX input signal
s_ID_EX_in(0) <= s_IDcontrol(12); -- JalSel
s_ID_EX_in(1) <= s_IDcontrol(0); -- Halt
s_ID_EX_in(4 downto 2) <= s_IDcontrol(3 downto 1); -- s_Load
s_ID_EX_in(5) <= s_IDcontrol(4); -- s_vshift
s_ID_EX_in(6) <= s_IDcontrol(5); -- s_sign ext (zero/sign)
s_ID_EX_in(7) <= s_IDcontrol(6); -- s_overflow
s_ID_EX_in(8) <= s_IDcontrol(17); -- regWrite
s_ID_EX_in(9) <= s_IDcontrol(18); -- Dmem write
s_ID_EX_in(10) <= s_IDcontrol(19); -- memToReg
s_ID_EX_in(11) <= s_IDcontrol(20); -- addSub
s_ID_EX_in(12) <= s_IDcontrol(21); -- Alu Src
s_ID_EX_in(16 downto 13) <= s_IDcontrol(10 downto 7); -- AluOp sel
s_ID_EX_in(21 downto 17) <= s_ID_RegWrAddr; -- Write Addr
s_ID_EX_in(37 downto 22) <= s_ID_imme; -- Imme 
s_ID_EX_in(69 downto 38) <= s_rsOutID; -- rs 
s_ID_EX_in(101 downto 70) <= s_rtOutID; -- rt
s_ID_EX_in(133 downto 102) <= s_ID_JalAdd; -- Jal 




IDEXReg : ID_EX_Reg
 
 port map(
  i_CLK  => iCLK,
  i_RST  => iRST,
  i_WE   => '1',   
  i_D    => s_ID_EX_in,
  o_Q      => s_ID_EX_out);

------------------
--between reg and ALU
------------------

ALUmod : ALU
 
 port map(
      i_A => s_ID_EX_out(69 downto 38),  
      i_B => s_ID_EX_out(101 downto 70),   
      i_imme => s_ID_EX_out(37 downto 22),
      i_zeroSignSEL => s_ID_EX_out(6),  
      i_SEL         => s_ID_EX_out(11),
      ALUSrc        => s_ID_EX_out(12),
      i_ALUOpSel    => s_ID_EX_out(16 downto 13), 
      o_DataOut     => s_aluDataOutEX,
      i_sOverFlow   => s_ID_EX_out(7),
      o_zero        => open,
      o_overFlow    => s_OvflEX);



------------------
--EX/MEM
------------------
--EX/MEM input signal
s_EX_MEM_in(0) <= s_ID_EX_out(0); -- JalSel
s_EX_MEM_in(1) <= s_ID_EX_out(1); -- Halt
s_EX_MEM_in(4 downto 2) <= s_ID_EX_out(4 downto 2); -- s_load
s_EX_MEM_in(5) <= s_ID_EX_out(7); -- overflow
s_EX_MEM_in(6) <= s_ID_EX_out(8); -- regWrite
s_EX_MEM_in(7) <= s_ID_EX_out(9); -- Dmem write
s_EX_MEM_in(8) <= s_ID_EX_out(10); -- memtoreg
s_EX_MEM_in(40 downto 9) <= s_ID_EX_out(133 downto 102); -- Jal
s_EX_MEM_in(72 downto 41) <= s_aluDataOutEX; -- dataOutEX
s_EX_MEM_in(104 downto 73) <= s_ID_EX_out(101 downto 70); -- RT
s_EX_MEM_in(109 downto 105) <= s_ID_EX_out(21 downto 17); -- write addr

EXMEMReg : EX_MEM_Reg
 
 port map(
  i_CLK  => iCLK,
  i_RST  => iRST,
  i_WE   => '1',   
  i_D    => s_EX_MEM_in,
  o_Q      => s_EX_MEM_out);



  s_DMemAddr      <= s_EX_MEM_out(72 downto 41);
  s_DMemData       <= s_EX_MEM_out(104 downto 73);
  s_DMemWr        <= s_EX_MEM_out(7);

------------------
--MEM/WB
------------------
--MEM/WB input signal
s_MEM_WB_in(0) <= s_EX_MEM_out(0); -- JalSel
s_MEM_WB_in(1) <= s_EX_MEM_out(1); -- Halt
s_MEM_WB_in(4 downto 2) <= s_EX_MEM_out(4 downto 2); -- s_load
s_MEM_WB_in(5) <= s_EX_MEM_out(5); -- overflow
s_MEM_WB_in(6) <= s_EX_MEM_out(6); -- regWrite
s_MEM_WB_in(7) <= s_EX_MEM_out(8); -- mem to reg
s_MEM_WB_in(39 downto 8) <= s_EX_MEM_out(40 downto 9); -- jal
s_MEM_WB_in(71 downto 40) <= s_EX_MEM_out(72 downto 41); -- dataOut
s_MEM_WB_in(103 downto 72) <= s_DMemOut; -- Read Data (data out from dmem)
s_MEM_WB_in(108 downto 104) <= s_EX_MEM_out(109 downto 105); -- write addr


MEMWBReg : MEM_WB_Reg
 
 port map(
  i_CLK  => iCLK,
  i_RST  => iRST,
  i_WE   => '1',   
  i_D    => s_MEM_WB_in,
  o_Q      => s_MEM_WB_out);




s_Halt          <= s_MEM_WB_out(1); -- COULD BE WRONG (idk where this can be (ID stage?))
s_regWr         <= s_MEM_WB_out(6);
oALUOut         <= s_MEM_WB_out(71 downto 40); -- COULD BE WRONG (maybe be at alu out location instead of WB stage)
s_RegWrAddr     <= s_MEM_WB_out(108 downto 104);

muxmemToReg : mux2t1_N

port map(
             i_S  => s_MEM_WB_out(7), 
             i_D0 => s_MEM_WB_out(71 downto 40), 
             i_D1 => s_MEM_WB_out(103 downto 72),   
             o_O  => s_memRegMuxOut);

 loadMemModuleMod : loadMemModule
 
 port map(
     i_memData   =>  s_memRegMuxOut,
     i_addrData  =>  s_MEM_WB_out(41 downto 40),
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
    SEL => s_MEM_WB_out(4 downto 2));

  

    muxjal : mux2t1_N

    port map(
                 i_S  => s_MEM_WB_out(0), 
                 i_D0 => s_databeforeMux, 
                 i_D1 => s_MEM_WB_out(39 downto 8), -- was PCnextAddress   
                 o_O  => s_RegWrData);




  -- TODO: Implement the rest of your processor below this comment! 

end structure;