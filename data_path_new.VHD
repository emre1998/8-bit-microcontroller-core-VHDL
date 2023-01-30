library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--DATA PATH--
entity data_path is 
port(
      clock,reset: in std_logic;
	  IR_Load: in std_logic;
	  IR: out std_logic_vector(7 downto 0);
	  MAR_Load: in std_logic;
	  address: out std_logic_vector(7 downto 0);
	  PC_Load: in std_logic;
	  PC_Inc: in std_logic;
	  A_Load: in std_logic;
	  B_Load: in std_logic;
	  ALU_Sel: in std_logic_vector(2 downto 0);
	  CCR_Result: out std_logic_vector(7 downto 0);
	  CCR_Load: in std_logic;
	  Bus2_Sel: in std_logic_vector(1 downto 0);
	  Bus1_Sel: in std_logic_vector(1 downto 0);
	  from_memory: in std_logic_vector(7 downto 0);
	  to_memory: out std_logic_vector(7 downto 0)
	  
	  
	 );
	 
	 end data_path;
	 
architecture behavioral of data_path is 

component ALU
port(
        A,B: in std_logic_vector(7 downto 0);
		ALU_Sel:in std_logic_vector(2 downto 0);
		NVZC:out std_logic_vector(7 downto 0);
		Result: out std_logic_vector(7 downto 0)
			);
		end component ALU;
		
	signal BUS1,BUS2,ALU_Result:std_logic_vector(7 downto 0);
	signal IR_Reg,MAR,PC,A_Reg,B_Reg: std_logic_vector(7 downto 0);
	signal CCR_in,CCR: std_logic_vector(3 downto 0);
	begin
	--INSTRUCTION REGISTER--
	process(clock,reset)
	begin
	     if(reset='0') then
		     IR_Reg <= x"00";
			 elsif(rising_edge(clock)) then
                 if(IR_Load = '1') then
                    IR_Reg <= BUS2;
			end if;		
		end if;			
	end process;		
	
	IR <= IR_Reg;
	      --MAR REGISTER--
	process(clock,reset)
	begin
	     if(reset='0') then
            MAR <= x"00";
		elsif(rising_edge(clock)) then	
		     if(MAR_Load= '1') then 
			
			end if;
		end if;
	end process;
	
	address <= MAR;
	
	     --PC--
		 
	process(clock,reset)
    begin
         if(reset='0') then
		    PC <= x"00";
		elsif(rising_edge(clock)) then
           if(PC_Load= '1')    then
		      PC <= BUS2;
			elsif(PC_Inc= '1') then
              PC <= PC + x"01";
			 end if;
		end if;	
	end process;
 
      --A REGISTER--
	process(clock,reset)
    begin 
        if(reset='0') then 
           A_Reg <= x"00";
        elsif(rising_edge(clock)) then
            if(A_Load='1') then
                 A_Reg <= BUS2;
			end if;
		end if;
	end process;

      --B REGISTER--
	  
	process(clock,reset)
    begin 
	    if(reset='0') then
		   B_Reg <= x"00";
		elsif(rising_edge(clock)) then
            if(B_Load='1') then
              B_Reg <= BUS2;
			end if;
		end if;	
	end process;
	
	     --ALU UNIT--
	ALU_unit: ALU port map
	(
         A => B_Reg,
         B => BUS1,
		 ALU_Sel => ALU_Sel,
 	     NVZC => CCR_in,
		 Result => ALU_Result
	);	 
	     --CCR REGISTER--
	process(clock,reset)
    begin  
        if(reset='0') then
             CCR <= x"0";
        elsif(rising_edge(clock)) then
            if(CCR_Load='1') then
			   CCR <= CCR_in;
			end if;
		end if;
	end process;
	
	CCR_Result <= CCR;
	 
	     --MUX BUS2--
	BUS2 <=  ALU_Result  when Bus2_Sel = "00" else
             BUS1        when BUS2_Sel = "01" else
             from_memory when Bus2_Sel = "10" else
             x"00";

         --MUX BUS1--
    BUS1 <=  PC    when Bus1_Sel = "00" else
	         A_Reg when Bus1_Sel = "01" else
			 B_Reg when Bus1_Sel = "10" else
		     x"00";
	to_memory <= BUS1;
 
end behavioral;