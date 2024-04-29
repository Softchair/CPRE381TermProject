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
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY work;
USE work.MIPS_types.ALL;

ENTITY MIPS_Processor IS
  GENERIC (N : INTEGER := DATA_WIDTH);
  PORT (
    iCLK : IN STD_LOGIC;
    iRST : IN STD_LOGIC;
    iInstLd : IN STD_LOGIC;
    iInstAddr : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    iInstExt : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    oALUOut : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

END MIPS_Processor;
ARCHITECTURE structure OF MIPS_Processor IS

  -- Required data memory signals
  SIGNAL s_DMemWr : STD_LOGIC; -- TODO: use this signal as the final active high data memory write enable signal
  SIGNAL s_DMemAddr : STD_LOGIC_VECTOR(N - 1 DOWNTO 0); -- TODO: use this signal as the final data memory address input
  SIGNAL s_DMemData : STD_LOGIC_VECTOR(N - 1 DOWNTO 0); -- TODO: use this signal as the final data memory data input
  SIGNAL s_DMemOut : STD_LOGIC_VECTOR(N - 1 DOWNTO 0); -- TODO: use this signal as the data memory output

  -- Required register file signals 
  SIGNAL s_RegWr : STD_LOGIC; -- TODO: use this signal as the final active high write enable input to the register file
  SIGNAL s_RegWrAddr : STD_LOGIC_VECTOR(4 DOWNTO 0); -- TODO: use this signal as the final destination register address input
  SIGNAL s_RegWrData : STD_LOGIC_VECTOR(N - 1 DOWNTO 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  SIGNAL s_IMemAddr : STD_LOGIC_VECTOR(N - 1 DOWNTO 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  SIGNAL s_NextInstAddr : STD_LOGIC_VECTOR(N - 1 DOWNTO 0); -- TODO: use this signal as your intended final instruction memory address input.
  SIGNAL s_Inst : STD_LOGIC_VECTOR(N - 1 DOWNTO 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  SIGNAL s_Halt : STD_LOGIC; -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  SIGNAL s_Ovfl : STD_LOGIC; -- TODO: this signal indicates an overflow exception would have been initiated
  
  COMPONENT mem IS
    GENERIC (
      ADDR_WIDTH : INTEGER;
      DATA_WIDTH : INTEGER);
    PORT (
      clk : IN STD_LOGIC;
      addr : IN STD_LOGIC_VECTOR((ADDR_WIDTH - 1) DOWNTO 0);
      data : IN STD_LOGIC_VECTOR((DATA_WIDTH - 1) DOWNTO 0);
      we : IN STD_LOGIC := '1';
      q : OUT STD_LOGIC_VECTOR((DATA_WIDTH - 1) DOWNTO 0));
  END COMPONENT;

  -----------------------------------------------
  --SIGNALS
  -----------------------------------------------

  -------------------
  --Fetch related signals
  ------------------
  SIGNAL s_branchUnit : STD_LOGIC; -- branch unit logic output to mux of fetch
  -------------------
  --control logic
  -------------------
  SIGNAL s_controlOut : STD_LOGIC_VECTOR(21 DOWNTO 0); -- control output signals

  -------------------
  --signals from iMEM
  -------------------

  SIGNAL s_opcode : STD_LOGIC_VECTOR(5 DOWNTO 0); -- Opcode signal
  SIGNAL s_rs : STD_LOGIC_VECTOR(4 DOWNTO 0); -- rs signal
  SIGNAL s_rt : STD_LOGIC_VECTOR(4 DOWNTO 0); -- rt signal
  SIGNAL s_rd : STD_LOGIC_VECTOR(4 DOWNTO 0); -- rd signal
  SIGNAL s_jump : STD_LOGIC_VECTOR(25 DOWNTO 0); -- rd signal
  SIGNAL s_imme : STD_LOGIC_VECTOR(15 DOWNTO 0); -- immediate signal
  SIGNAL s_func : STD_LOGIC_VECTOR(5 DOWNTO 0); -- func signal
  -------------------
  --signals between register and ALU
  -------------------
  SIGNAL s_rsOut : STD_LOGIC_VECTOR(31 DOWNTO 0); -- rs out of reg
  SIGNAL s_rtOut : STD_LOGIC_VECTOR(31 DOWNTO 0); -- rt out of reg
  SIGNAL s_extender : STD_LOGIC_VECTOR(31 DOWNTO 0); -- extended value going into mux
  SIGNAL s_regSelMuxOut : STD_LOGIC_VECTOR(4 DOWNTO 0); -- mux out

  -------------------
  --signals from data
  -------------------

  SIGNAL s_databeforeMux : STD_LOGIC_VECTOR(31 DOWNTO 0); -- signal from load byte mux

  -------------------
  --signals after ALU
  -------------------
  SIGNAL s_aluDataOut : STD_LOGIC_VECTOR(31 DOWNTO 0); -- signal for data output of ALU
  SIGNAL s_memRegMuxOut : STD_LOGIC_VECTOR(31 DOWNTO 0); -- signal for data output of memtoregmux
  SIGNAL s_lb : STD_LOGIC_VECTOR(31 DOWNTO 0); -- lb signal from load module
  SIGNAL s_lbu : STD_LOGIC_VECTOR(31 DOWNTO 0); -- lbu signal from load module
  SIGNAL s_lh : STD_LOGIC_VECTOR(31 DOWNTO 0); -- lh signal from load module
  SIGNAL s_lhu : STD_LOGIC_VECTOR(31 DOWNTO 0); -- lhu signal from load module
  SIGNAL s_zero : STD_LOGIC; -- for branching 
  SIGNAL s_afterBEAnd : STD_LOGIC; -- signal going into branch OR
  SIGNAL s_afterBNEINV : STD_LOGIC; -- signal after inv for BNE
  SIGNAL s_afterBNEAnd : STD_LOGIC; -- signal going into OR for branch
  SIGNAL s_RegWrAddrBefore : STD_LOGIC_VECTOR(4 DOWNTO 0); -- one mux to another
  SIGNAL s_jalAddnext : STD_LOGIC_VECTOR(31 DOWNTO 0); -- NEW

  --------------------
  --PipelineSignals
  --------------------
  --IF stage internal
   signal s_Inst_mux :  STD_LOGIC_VECTOR(31 downto 0);
   signal s_flush  : std_logic;


  --IF/ID reg
  SIGNAL s_IFID_PC4_in : STD_LOGIC_VECTOR(31 downto 0); -- Inputs to ID reg
  SIGNAL s_IFID_Inst_in : STD_LOGIC_VECTOR(31 downto 0); -- Inputs to ID reg

  SIGNAL s_IFID_PC4_out : STD_LOGIC_VECTOR(31 downto 0); -- Outputs for ID reg
  SIGNAL s_IFID_Inst_out : STD_LOGIC_VECTOR(31 downto 0); -- Outputs for ID reg
  
  --ID stage internal
  SIGNAL s_ID_RegWrAddr : STD_LOGIC_VECTOR(4 DOWNTO 0); -- regWrAddr output from muxes
  SIGNAL s_subtractorOut : STD_LOGIC_VECTOR(31 DOWNTO 0); -- zero logic subtractor output
  SIGNAL s_orGateZeroOut : STD_LOGIC; -- output of or gate zero logic
  SIGNAL s_zeroID : STD_LOGIC; -- zero signal in ID stage
  SIGNAL s_IDcontrol : STD_LOGIC_VECTOR(21 DOWNTO 0); -- control signals ID stage
  SIGNAL s_rsOutID : STD_LOGIC_VECTOR(31 DOWNTO 0); -- rs out in ID stage
  SIGNAL s_rtOutID : STD_LOGIC_VECTOR(31 DOWNTO 0); -- rt out in ID stage

  --ID/EX Reg
  SIGNAL s_ID_EX_in : STD_LOGIC_VECTOR(133 DOWNTO 0); -- signal going into ID/EX reg
  SIGNAL s_ID_EX_out : STD_LOGIC_VECTOR(133 DOWNTO 0); -- signal coming out of ID/EX reg
  --EX stage internal
  SIGNAL s_aluDataOutEX : STD_LOGIC_VECTOR(31 DOWNTO 0); -- alu data out EX stage
  SIGNAL s_OvflEX : STD_LOGIC; -- overflow logic EX stage

  --EX/MEM Reg
  SIGNAL s_EX_MEM_in : STD_LOGIC_VECTOR(109 DOWNTO 0); -- signal going into EX/MEM reg
  SIGNAL s_EX_MEM_out : STD_LOGIC_VECTOR(109 DOWNTO 0); -- signal coming out of EX/MEM reg

  --MEM/WB Reg
  SIGNAL s_MEM_WB_in : STD_LOGIC_VECTOR(108 DOWNTO 0); -- signal going into MEM/WB reg
  SIGNAL s_MEM_WB_out : STD_LOGIC_VECTOR(108 DOWNTO 0); -- signal coming out of MEM/WB reg

  --internal WB signals
  SIGNAL s_dataInWB : STD_LOGIC_VECTOR(31 DOWNTO 0); -- reg data in WB stage

  -- HW Stall signal
  SIGNAL s_stall : STD_LOGIC; -- hw stall signal 
  SIGNAL s_regStall : STD_LOGIC; -- stall signal must be inverted before pipeline reg's
  -- hazard detection signals
  SIGNAL s_idRs_exWrAdr : STD_LOGIC; -- compare idRs_ex address
  SIGNAL s_idRt_exWrAdr : STD_LOGIC; -- compare idRt_ex address
  SIGNAL s_id_exSameReg : STD_LOGIC; -- both rt/rs to ex comparison signals
  SIGNAL s_id_exStall : STD_LOGIC; -- id_ex stall signal

  SIGNAL s_idRs_memWrAdr : STD_LOGIC; -- compare idRs_mem address
  SIGNAL s_idRt_memWrAdr : STD_LOGIC; -- compare idRt_mem address
  SIGNAL s_id_memSameReg : STD_LOGIC; -- both rt/rs to ex comparison signals
  SIGNAL s_id_memStall : STD_LOGIC; -- id_mem stall signal

  SIGNAL s_controlOutbeforeStall : STD_LOGIC_VECTOR(21 DOWNTO 0);
  SIGNAL s_IDcontrolFinal : STD_LOGIC_VECTOR(21 DOWNTO 0);
  SIGNAL s_ID_EX_zero_andg : STD_LOGIC;
  SIGNAL s_EX_MEM_zero_andg : STD_LOGIC;
  SIGNAL s_ID_EX_zero : STD_LOGIC;
  SIGNAL s_ID_MEM_zero : STD_LOGIC;
  SIGNAL s_id_exStallFinal : STD_LOGIC;
  SIGNAL s_id_memStallFinal : STD_LOGIC;

  -----------------------
  --Large components
  -----------------------
  COMPONENT control_Logic IS -- control unit 
    PORT (
      i_DOpcode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      i_DFunc : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      o_signals : OUT STD_LOGIC_VECTOR(21 DOWNTO 0));
  END COMPONENT;

  COMPONENT MIPSregister IS
    PORT (
      i_CLK : IN STD_LOGIC;
      i_enable : IN STD_LOGIC;
      i_rd : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
      i_rs : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
      i_rt : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
      i_rdindata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      i_reset : IN STD_LOGIC;
      o_rsOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      o_rtOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));

  END COMPONENT;

  COMPONENT ALU IS
    PORT (
      i_A : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- reg a input (rs)
      i_B : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- reg b input  (rt)
      i_imme : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- immediate input
      i_zeroSignSEL : IN STD_LOGIC; -- s_signExt
      i_SEL : IN STD_LOGIC; -- nAdd_Sub
      ALUSrc : IN STD_LOGIC;
      i_ALUOpSel : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- s_ALUOPSel
      o_DataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); -- dataOut
      i_sOverFlow : IN STD_LOGIC; -- overflow signal
      o_overFlow : OUT STD_LOGIC; -- overflow output
      o_zero : OUT STD_LOGIC -- zero output that goes to branch logic
    );
  END COMPONENT;
  
  COMPONENT fetch_logic IS
    PORT (
      i_CLK : IN STD_LOGIC; -- Clock
      i_RST : IN STD_LOGIC; -- Reset
      i_PCWE : IN STD_LOGIC;
      -- Register inputs
      i_JReg : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Jump register input
      -- Control logic inputs
      i_BranchLogic : IN STD_LOGIC; -- Branch logic control, 1 if branch
      i_JumpLogic : IN STD_LOGIC; -- Jump logic control, 1 if jump
      i_JRegLogic : IN STD_LOGIC; -- Jump register logic control, 1 if jump reg
      -- Instruction input
      i_Instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Instruction output
      i_PcLast : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      -- Ouput
      o_PCAddress : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); -- PC Address for JAL box
      o_jalAdd : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT;

  -----------------------
  --Zero output "unit"
  -----------------------

  COMPONENT adderSubS IS
    PORT (
      i_D0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- reg A input
      i_D1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- reg B input
      i_SEL : IN STD_LOGIC;
      o_O : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      o_Cout : OUT STD_LOGIC);

  END COMPONENT;

  COMPONENT orG32b

    PORT (
      D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, D16,
      D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28, D29, D30, D31 : IN STD_LOGIC;
      o_Out : OUT STD_LOGIC);

  END COMPONENT;

  -----------------------
  --Branching unit
  -----------------------

  COMPONENT andg2 IS

    PORT (
      i_A : IN STD_LOGIC;
      i_B : IN STD_LOGIC;
      o_F : OUT STD_LOGIC);

  END COMPONENT;
  COMPONENT invg IS
    PORT (
      i_A : IN STD_LOGIC;
      o_F : OUT STD_LOGIC);

  END COMPONENT;

  COMPONENT org2 IS

    PORT (
      i_A : IN STD_LOGIC;
      i_B : IN STD_LOGIC;
      o_F : OUT STD_LOGIC);

  END COMPONENT;

  -----------------------
  --Pipeline Registers
  -----------------------
  COMPONENT IF_ID_Reg IS
    PORT (
      i_CLK : IN STD_LOGIC;
      i_RST : IN STD_LOGIC;
      i_WE : IN STD_LOGIC;
      -- In Signals
      i_IFID_PC4 : IN STD_LOGIC_VECTOR(31 downto 0); -- PC + 4 (next pc)
      i_IFID_Inst : IN STD_LOGIC_VECTOR(31 downto 0); -- Next Instruction
      -- Out Signals
      o_IFID_PC4 : OUT STD_LOGIC_VECTOR(31 downto 0);
      o_IFID_Inst : OUT STD_LOGIC_VECTOR(31 downto 0));
  END COMPONENT;

  COMPONENT ID_EX_Reg IS
    PORT (
      i_CLK : IN STD_LOGIC;
      i_RST : IN STD_LOGIC;
      i_WE : IN STD_LOGIC;
      i_D : IN STD_LOGIC_VECTOR(133 DOWNTO 0);
      o_Q : OUT STD_LOGIC_VECTOR(133 DOWNTO 0));

  END COMPONENT;
  COMPONENT EX_MEM_Reg IS
    PORT (
      i_CLK : IN STD_LOGIC;
      i_RST : IN STD_LOGIC;
      i_WE : IN STD_LOGIC;
      i_D : IN STD_LOGIC_VECTOR(109 DOWNTO 0);
      o_Q : OUT STD_LOGIC_VECTOR(109 DOWNTO 0));
  END COMPONENT;

  COMPONENT MEM_WB_Reg IS
    PORT (
      i_CLK : IN STD_LOGIC;
      i_RST : IN STD_LOGIC;
      i_WE : IN STD_LOGIC;
      i_D : IN STD_LOGIC_VECTOR(108 DOWNTO 0);
      o_Q : OUT STD_LOGIC_VECTOR(108 DOWNTO 0));
  END COMPONENT;

  -----------------------
  --Extra gates
  -----------------------
  COMPONENT andG5b IS
    PORT (
      i_A : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
      i_B : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
      o_F : OUT STD_LOGIC);
  END COMPONENT;

  ------------------------
  -- bit extender
  ------------------------

  COMPONENT bit_extenders IS
    PORT (
      i_Din : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      o_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      SEL : IN STD_LOGIC);
  END COMPONENT;


  COMPONENT org5b is
    port (
   D0, D1, D2, D3, D4 : in std_logic;
   o_Out : out std_logic);

  end COMPONENT;
  
  -----------------------
  --mux's
  -----------------------
  COMPONENT mux2t1_17b IS -- 5 bit wide 2t1 mux
    PORT (
      i_S : IN STD_LOGIC;
      i_D0 : IN STD_LOGIC_VECTOR(21 DOWNTO 0);
      i_D1 : IN STD_LOGIC_VECTOR(21 DOWNTO 0);
      o_O : OUT STD_LOGIC_VECTOR(21 DOWNTO 0));
  END COMPONENT;

  COMPONENT mux2t1_5b IS -- 5 bit wide 2t1 mux
    PORT (
      i_S : IN STD_LOGIC;
      i_D0 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
      i_D1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
      o_O : OUT STD_LOGIC_VECTOR(4 DOWNTO 0));
  END COMPONENT;

  COMPONENT mux2t1_N IS -- 32 bit wide 2t1 mux
    PORT (
      i_S : IN STD_LOGIC;
      i_D0 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      i_D1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      o_O : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0));
  END COMPONENT;

  COMPONENT mux32b3t1 IS -- 32 bit 3t1 mux
    PORT (
      D0, D1, D2, D3, D4, D5, D6, D7 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      o_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      SEL : IN STD_LOGIC_VECTOR(2 DOWNTO 0));
  END COMPONENT;

  ---------------------
  --load mem module
  --------------------
  COMPONENT loadMemModule IS
    PORT (
      i_memData : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- data from memory address from dmem 
      i_addrData : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- last 2 bit of the memory address
      o_LB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      o_LBU : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      o_LH : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      o_LHU : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;

BEGIN

  WITH iInstLd SELECT
    s_IMemAddr <= s_NextInstAddr WHEN '0',
    iInstAddr WHEN OTHERS;

  IMem : mem
  GENERIC MAP(
    ADDR_WIDTH => ADDR_WIDTH,
    DATA_WIDTH => N)
  PORT MAP(
    clk => iCLK,
    addr => s_IMemAddr(11 DOWNTO 2),
    data => iInstExt,
    we => iInstLd,
    q => s_Inst_mux);

  DMem : mem
  GENERIC MAP(
    ADDR_WIDTH => ADDR_WIDTH,
    DATA_WIDTH => N)
  PORT MAP(
    clk => iCLK,
    addr => s_DMemAddr(11 DOWNTO 2),
    data => s_DMemData,
    we => s_DMemWr,
    q => s_DMemOut);

  -----------------------
  --Fetch logic
  -----------------------

  fetchUnit : fetch_logic
  PORT MAP(
    i_CLK => iCLK,
    i_RST => iRST,
    i_PCWE => s_regStall,
    -- Register inputs
    i_JReg => s_rsOutID,
    -- Control logic inputs
    i_BranchLogic => s_branchUnit,
    i_JumpLogic => s_IDcontrol(13),
    i_JRegLogic => s_IDcontrol(11),
    -- Instruction input
    i_Instruction => s_IFID_Inst_out, -- Output of ID pipeline
    i_PcLast => s_IFID_PC4_out, -- Output of ID pipeline
    -- Ouput
    o_PCAddress => s_NextInstAddr, -- Next instruction address
    o_jalAdd => s_IFID_PC4_in); -- Input into ID pipeline
  
  ------------------
  --between imem and reg
  ------------------

  

  ------------------
  --IF/ID 
  ------------------

  -- Zero logic Subtractor output signals
  g_stallReginvg : invg
  PORT MAP(
    i_A => s_stall,
    o_F => s_regStall);

  IfIdReg : IF_ID_Reg
  PORT MAP(
    i_CLK => iCLK,
    i_RST => iRST,
    i_WE => s_regStall,
    -- In Signals
    i_IFID_PC4 => s_IFID_PC4_in, -- PC + 4 (next pc)
    i_IFID_Inst => s_Inst, -- Next Instruction
    -- Out Signals
    o_IFID_PC4 => s_IFID_PC4_out,
    o_IFID_Inst => s_IFID_Inst_out);

  muxWrAddr : mux2t1_5b
  PORT MAP(
    i_S => s_IDcontrol(16),
    i_D0 => s_IFID_Inst_out(15 DOWNTO 11),
    i_D1 => s_IFID_Inst_out(20 DOWNTO 16),
    o_O => s_RegWrAddrBefore);
  
  muxWrAddr02 : mux2t1_5b
  PORT MAP(
    i_S => s_IDcontrol(12),
    i_D0 => s_RegWrAddrBefore,
    i_D1 => "11111",
    o_O => s_ID_RegWrAddr);
  RegisterMod : MIPSregister

  PORT MAP(
    i_CLK => iCLK,
    i_enable => s_regWr, -- to add
    i_rd => s_RegWrAddr, -- addr
    i_rs => s_IFID_Inst_out(25 DOWNTO 21),
    i_rt => s_IFID_Inst_out(20 DOWNTO 16),
    i_rdindata => s_RegWrData, --to add
    i_reset => iRST,
    o_rsOUT => s_rsOutID,
    o_rtOUT => s_rtOutID);
  controlUnit : control_logic

  PORT MAP(
    i_DOpcode => s_IFID_Inst_out(31 DOWNTO 26),
    i_DFunc => s_IFID_Inst_out(5 DOWNTO 0),
    o_signals => s_IDcontrol);
  
  ------------------
  -- Zero "Unit"
  ------------------
  subtractor : adderSubs
  PORT MAP(

    i_D0 => s_rsOutID, -- reg A input
    i_D1 => s_rtOutID, -- reg B input
    i_SEL => '1',
    o_O => s_subtractorOut,
    o_Cout => OPEN);

  g_orG32 : orG32b
  PORT MAP(
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
    o_Out => s_orGateZeroOut);

  g_invg : invg
  PORT MAP(
    i_A => s_orGateZeroOut,
    o_F => s_zeroID);
  
  ------------------
  -- branch "unit" -- do we need fetch logic in decode unit??
  ------------------
  BranchEqualAnd : andg2
  PORT MAP(
    i_A => s_IDcontrol(15),
    i_B => s_zeroID,
    o_F => s_afterBEAnd);

  BranchNotEqualAnd : andg2
  PORT MAP(
    i_A => s_IDcontrol(14),
    i_B => s_afterBNEINV,
    o_F => s_afterBNEAnd);

  BranchInv : invg
  PORT MAP(
    i_A => s_zeroID,
    o_F => s_afterBNEINV);

  BranchOr : org2
  PORT MAP(
    i_A => s_afterBEAnd,
    i_B => s_afterBNEAnd,
    o_F => s_branchUnit);
  --------------------------------

  stallControlSignalMux : mux2t1_17b
  PORT MAP(
    i_S => s_stall,
    i_D0 => s_controlOutbeforeStall,
    i_D1 => "0000000000000000000000",
    o_O => s_IDcontrolFinal
  );

  s_controlOutbeforeStall(0) <= s_IDcontrol(12); -- JalSel
  s_controlOutbeforeStall(1) <= s_IDcontrol(0); -- Halt
  s_controlOutbeforeStall(4 DOWNTO 2) <= s_IDcontrol(3 DOWNTO 1); -- s_Load
  s_controlOutbeforeStall(5) <= s_IDcontrol(4); -- s_vshift
  s_controlOutbeforeStall(6) <= s_IDcontrol(5); -- s_sign ext (zero/sign)
  s_controlOutbeforeStall(7) <= s_IDcontrol(6); -- s_overflow
  s_controlOutbeforeStall(8) <= s_IDcontrol(17); -- regWrite
  s_controlOutbeforeStall(9) <= s_IDcontrol(18); -- Dmem write
  s_controlOutbeforeStall(10) <= s_IDcontrol(19); -- memToReg
  s_controlOutbeforeStall(11) <= s_IDcontrol(20); -- addSub
  s_controlOutbeforeStall(12) <= s_IDcontrol(21); -- Alu Src
  s_controlOutbeforeStall(16 DOWNTO 13) <= s_IDcontrol(10 DOWNTO 7); -- AluOp sel
  s_controlOutbeforeStall(21 DOWNTO 17) <= s_ID_RegWrAddr; -- Write Addr
  ------------------
  --ID/EX
  ------------------
  --ID/EX input signal
  s_ID_EX_in(0) <= s_IDcontrolFinal(0); -- JalSel
  s_ID_EX_in(1) <= s_IDcontrolFinal(1); -- Halt
  s_ID_EX_in(4 DOWNTO 2) <= s_IDcontrolFinal(4 DOWNTO 2); -- s_Load
  s_ID_EX_in(5) <= s_IDcontrolFinal(5); -- s_vshift
  s_ID_EX_in(6) <= s_IDcontrolFinal(6); -- s_sign ext (zero/sign)
  s_ID_EX_in(7) <= s_IDcontrolFinal(7); -- s_overflow
  s_ID_EX_in(8) <= s_IDcontrolFinal(8); -- regWrite
  s_ID_EX_in(9) <= s_IDcontrolFinal(9); -- Dmem write
  s_ID_EX_in(10) <= s_IDcontrolFinal(10); -- memToReg
  s_ID_EX_in(11) <= s_IDcontrolFinal(11); -- addSub
  s_ID_EX_in(12) <= s_IDcontrolFinal(12); -- Alu Src
  s_ID_EX_in(16 DOWNTO 13) <= s_IDcontrolFinal(16 DOWNTO 13); -- AluOp sel
  s_ID_EX_in(21 DOWNTO 17) <= s_IDcontrolFinal(21 DOWNTO 17); -- Write Addr
  s_ID_EX_in(37 DOWNTO 22) <= s_IFID_Inst_out(15 downto 0); -- Imme 
  s_ID_EX_in(69 DOWNTO 38) <= s_rsOutID; -- rs 
  s_ID_EX_in(101 DOWNTO 70) <= s_rtOutID; -- rt
  s_ID_EX_in(133 DOWNTO 102) <= s_IFID_PC4_out; -- Jal 
  
  IDEXReg : ID_EX_Reg
  PORT MAP(
    i_CLK => iCLK,
    i_RST => iRST,
    i_WE => '1',
    i_D => s_ID_EX_in,
    o_Q => s_ID_EX_out);

  ------------------
  --between reg and ALU
  ------------------

  ALUmod : ALU
  PORT MAP(
    i_A => s_ID_EX_out(69 DOWNTO 38),
    i_B => s_ID_EX_out(101 DOWNTO 70),
    i_imme => s_ID_EX_out(37 DOWNTO 22),
    i_zeroSignSEL => s_ID_EX_out(6),
    i_SEL => s_ID_EX_out(11),
    ALUSrc => s_ID_EX_out(12),
    i_ALUOpSel => s_ID_EX_out(16 DOWNTO 13),
    o_DataOut => s_aluDataOutEX,
    i_sOverFlow => s_ID_EX_out(7),
    o_zero => OPEN,
    o_overFlow => s_OvflEX);

  ------------------
  --EX/MEM
  ------------------
  --EX/MEM input signal
  s_EX_MEM_in(0) <= s_ID_EX_out(0); -- JalSel
  s_EX_MEM_in(1) <= s_ID_EX_out(1); -- Halt
  s_EX_MEM_in(4 DOWNTO 2) <= s_ID_EX_out(4 DOWNTO 2); -- s_load
  s_EX_MEM_in(5) <= s_OvflEX; -- overflow
  s_EX_MEM_in(6) <= s_ID_EX_out(8); -- regWrite
  s_EX_MEM_in(7) <= s_ID_EX_out(9); -- Dmem write
  s_EX_MEM_in(8) <= s_ID_EX_out(10); -- memtoreg
  s_EX_MEM_in(40 DOWNTO 9) <= s_ID_EX_out(133 DOWNTO 102); -- Jal
  s_EX_MEM_in(72 DOWNTO 41) <= s_aluDataOutEX; -- dataOutEX
  s_EX_MEM_in(104 DOWNTO 73) <= s_ID_EX_out(101 DOWNTO 70); -- RT
  s_EX_MEM_in(109 DOWNTO 105) <= s_ID_EX_out(21 DOWNTO 17); -- write addr

  EXMEMReg : EX_MEM_Reg

  PORT MAP(
    i_CLK => iCLK,
    i_RST => iRST,
    i_WE => '1',
    i_D => s_EX_MEM_in,
    o_Q => s_EX_MEM_out);

  s_DMemAddr <= s_EX_MEM_out(72 DOWNTO 41);
  s_DMemData <= s_EX_MEM_out(104 DOWNTO 73);
  s_DMemWr <= s_EX_MEM_out(7);

  ------------------
  --MEM/WB
  ------------------
  --MEM/WB input signal
  s_MEM_WB_in(0) <= s_EX_MEM_out(0); -- JalSel
  s_MEM_WB_in(1) <= s_EX_MEM_out(1); -- Halt
  s_MEM_WB_in(4 DOWNTO 2) <= s_EX_MEM_out(4 DOWNTO 2); -- s_load
  s_MEM_WB_in(5) <= s_EX_MEM_out(5); -- overflow
  s_MEM_WB_in(6) <= s_EX_MEM_out(6); -- regWrite
  s_MEM_WB_in(7) <= s_EX_MEM_out(8); -- mem to reg
  s_MEM_WB_in(39 DOWNTO 8) <= s_EX_MEM_out(40 DOWNTO 9); -- jal
  s_MEM_WB_in(71 DOWNTO 40) <= s_EX_MEM_out(72 DOWNTO 41); -- dataOut
  s_MEM_WB_in(103 DOWNTO 72) <= s_DMemOut; -- Read Data (data out from dmem)
  s_MEM_WB_in(108 DOWNTO 104) <= s_EX_MEM_out(109 DOWNTO 105); -- write addr


  s_Ovfl <= s_MEM_WB_out(5);


  MEMWBReg : MEM_WB_Reg

  PORT MAP(
    i_CLK => iCLK,
    i_RST => iRST,
    i_WE => '1',
    i_D => s_MEM_WB_in,
    o_Q => s_MEM_WB_out);
  s_Halt <= s_MEM_WB_out(1); -- COULD BE WRONG (idk where this can be (ID stage?))
  s_regWr <= s_MEM_WB_out(6);
  oALUOut <= s_MEM_WB_out(71 DOWNTO 40); -- COULD BE WRONG (maybe be at alu out location instead of WB stage)
  s_RegWrAddr <= s_MEM_WB_out(108 DOWNTO 104);

  muxmemToReg : mux2t1_N

  PORT MAP(
    i_S => s_MEM_WB_out(7),
    i_D0 => s_MEM_WB_out(71 DOWNTO 40),
    i_D1 => s_MEM_WB_out(103 DOWNTO 72),
    o_O => s_memRegMuxOut);

  loadMemModuleMod : loadMemModule

  PORT MAP(
    i_memData => s_memRegMuxOut,
    i_addrData => s_MEM_WB_out(41 DOWNTO 40),
    o_LB => s_lb,
    o_LBU => s_lbu,
    o_LH => s_lh,
    o_LHU => s_lhu);
  muxFinalData : mux32b3t1

  PORT MAP(
    D0 => s_memRegMuxOut,
    D1 => s_lb,
    D2 => s_lbu,
    D3 => s_lh,
    D4 => s_lhu,
    D5 => s_memRegMuxOut, --not used
    D6 => s_memRegMuxOut, --not used
    D7 => s_memRegMuxOut, -- not used
    o_OUT => s_databeforeMux,
    SEL => s_MEM_WB_out(4 DOWNTO 2));

  muxjal : mux2t1_N

  PORT MAP(
    i_S => s_MEM_WB_out(0),
    i_D0 => s_databeforeMux,
    i_D1 => s_MEM_WB_out(39 DOWNTO 8), -- was PCnextAddress   
    o_O => s_RegWrData);
  -----------------------
  ---Hazard dection unit 
  -----------------------

  -- ID reg inputs and EX destReg comparisons
  idRs_exWrAdrAND : andG5b
  PORT MAP(
    i_A => s_IFID_Inst_out(25 DOWNTO 21), -- ID rs
    i_B => s_ID_EX_out(21 DOWNTO 17), -- EX wr addr
    o_F => s_idRs_exWrAdr
  );

  idRt_exWrAdrAND : andG5b
  PORT MAP(
    i_A => s_IFID_Inst_out(20 DOWNTO 16), -- ID rt
    i_B => s_ID_EX_out(21 DOWNTO 17), -- EX wr addr
    o_F => s_idRt_exWrAdr
  );

  id_exHazardOr : org2
  PORT MAP(
    i_A => s_idRs_exWrAdr, -- rs comparison
    i_B => s_idRt_exWrAdr, -- rt comparison
    o_F => s_id_exSameReg -- signal if these have same regs
  );

  id_exHazardAnd : andg2
  PORT MAP(
    i_A => s_id_exSameReg, -- --same regs
    i_B => s_ID_EX_out(8), -- see if wb is enabled
    o_F => s_id_exStall -- stall signal for id_ex
  );

  -- ID reg inputs and MEM destReg comparisons

  idRs_memWrAdrAND : andG5b
  PORT MAP(
    i_A => s_IFID_Inst_out(25 DOWNTO 21), -- ID rs
    i_B => s_EX_MEM_out(109 DOWNTO 105), -- MEM wr addr
    o_F => s_idRs_memWrAdr
  );

  idRt_memWrAdrAND : andG5b
  PORT MAP(
    i_A => s_IFID_Inst_out(20 DOWNTO 16), -- ID rt
    i_B => s_EX_MEM_out(109 DOWNTO 105), -- MEM wr addr
    o_F => s_idRt_memWrAdr
  );

  id_memHazardOr : org2
  PORT MAP(
    i_A => s_idRs_memWrAdr, -- rs comparison
    i_B => s_idRt_memWrAdr, -- rt comparison
    o_F => s_id_memSameReg -- signal if these have same regs
  );

  id_memHazardAnd : andg2
  PORT MAP(
    i_A => s_id_memSameReg, -- --same regs
    i_B => s_EX_MEM_out(6), -- see if wb is enabled 
    o_F => s_id_memStall -- stall signal for id_ex
  );

  -- final or gate to combine both stall stages into one signal
  zero_Check_ID_EX : andG5b
  PORT MAP(
    i_A => "00000", -- zero
    i_B => s_ID_EX_out(21 DOWNTO 17), -- EX wr addr
    o_F => s_ID_EX_zero_andg
  );

  zero_Check_ID_MEM : andG5b
  PORT MAP(
    i_A => "00000", -- zero
    i_B => s_EX_MEM_out(109 DOWNTO 105), -- MEM wr addr
    o_F => s_EX_MEM_zero_andg
  );

  zero_check_EX_invg : invg
  PORT MAP(
    i_A => s_ID_EX_zero_andg,
    o_F => s_ID_EX_zero);

  zero_check_MEM_invg : invg
  PORT MAP(
    i_A => s_EX_MEM_zero_andg,
    o_F => s_ID_MEM_zero);

  id_exHazardFinalAnd : andg2
  PORT MAP(
    i_A => s_id_exStall,
    i_B => s_ID_EX_zero,
    o_F => s_id_exStallFinal -- stall signal for id_ex
  );

  id_memHazardFinalAnd : andg2
  PORT MAP(
    i_A => s_id_memStall,
    i_B => s_ID_MEM_zero,
    o_F => s_id_memStallFinal -- stall signal for id_ex
  );

  finalStallOR : org2
  PORT MAP(
    i_A => s_id_exStallFinal, --id_ex stall
    i_B => s_id_memStallFinal, -- id_mem stall
    o_F => s_stall --  stall signal
  );


-----------------
--FLUSHING
-----------------

   flushOrG : org5b
   port map(
    D0 => s_IDcontrol(13), --jump signal
    D1 => s_IDcontrol(11), -- jump reg signal
    D2 => s_IDcontrol(12), -- JAL signal
    D3 => s_afterBNEAnd, -- BNE signal 
    D4 => s_afterBEAnd, -- BE signal
    o_out => s_flush
   );


   flushIF_IDmux : mux2t1_N 
   port map(
    i_S => s_flush,
    i_D0 => s_Inst_mux,
    i_D1 => x"00000000",
    o_O  => s_Inst
   );

   

 
END structure;