library IEEE;
use ieee.std_logic_1164.all;

entity CPU is
port(
         clock,reset: in std_logic;
		 address: out std_logic_vector(7 downto 0);
		 from_memory: in std_logic_vector(7 downto 0);
		 write : out std_logic;
		 to_memmory: out std_logic_vector(7 downto 0)
		 
	);
end CPU;
architecture behavioral of CPU is
component control_unit
port(
       clock,reset: in std_logic;
       IR_Load,MAR_Load,PC_Load: out std_logic;
       IR: in std_logic_vector(7 downto 0);
	   PC_Inc,A_Load,B_Load: out std_logic;
	   ALU_Sel: out std_logic_vector(2 downto 0);
	   CCR_Result: in std_logic_vector(3 downto 0);
	   CCR_Load,write: out std_logic;
	   BUS1_Sel,BUS2_Sel: out std_logic_vector(1 downto)
	 );

end component control_unit;

component data_path
port(
      clock,reset,IR_Load,MAR_Load,PC_Load,PC_Inc,A_Load,B_Load,CCR_Load: in std_logic;
	  IR,address: out std_logic_vector(7 downto 0);
	  ALU_Sel: in std_logic_vector(2 downto 0);
	  CCR_Result: out std_logic_vector(3 downto 0);
	  BUS1_Sel,BUS2_Sel: in std_logic_vector(1 downto 0);
	  from_memory: in std_logic_vector(7 downto 0);
	  to_memmory: out std_logic_vector(7 downto 0)
	  
	);
end component data_path;
  
signal  IR_Load: std_logic;
signal  IR: std_logic_vector(7 downto 0);
signal  MAR_Load: std_logic;
signal  PC_Load: std_logic;
signal  PC_Inc: std_logic;
signal  A_Load: std_logic;
signal  B_Load: std_logic;
signal  ALU_Sel: std_logic_vector( 2 downto 0);
signal  CCR_Load:std_logic;
signal  CCR_Result: std_logic_vector(3 downto 0);
signal  BUS1_Sel:std_logic_vector(1 downto 0);
signal  BUS2_Sel: std_logic_vector(1 downto 0);

begin
      -- CONTROL UNIT PORT MAP CONFIGURATION --
			
control_unit_module: control_unit port map
(
    clock => clock,
    reset => reset,
    IR_Load => IR_Load,
	IR  => IR
	MAR_Load => MAR_Load,
	PC_Load => PC_Load,
	PC_Inc => PC_Inc,
	A_Load => A_Load,
	B_Load => B_Load,
	ALU_Sel => ALU_Sel,
	CCR_Load => CCR_Load,
	CCR_Result => CCR_Result,
	BUS1_Sel => BUS1_Sel,
	BUS2_Sel => BUS2_Sel,
    write    => write
	
);
    --DATA PATH PORT MAP CONFIGURATION--
	
data_path_u: data_path port map
(
    clock => clock,
	reset => reset,
	IR_Load => IR_Load,
	IR => IR,
	MAR_Load => MAR_Load,
	address =>address,
	PC_Load => PC_Load,
	PC_Inc => PC_Inc,
	A_Load => A_Load,
	B_Load => B_Load,
	ALU_Sel => ALU_Sel,
	CCR_Result => CCR_Result,
	CCR_Load => CCR_Load,
	BUS2_Sel => BUS2_Sel,
	BUS1_Sel =>  BUS1_Sel,
	from_memory => from_memory,
	to_memmory => to_memmory
   
);	
end behavioral;