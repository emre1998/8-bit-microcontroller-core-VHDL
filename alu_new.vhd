library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE_STD_LOGIC_UNSIGNED.ALL;


entity ALU is
port(

        A,B: in std_logic_vector(7 downto 0);
		ALU_sel: in std_logic_vector(2 downto 0);
		NZVC: out std_logic_vector(3 downto 0);
		Result: out std_logic_vector(7 downto 0);
		
		);
		
	end ALU;
     	
architecture behavioral of ALU is
signal ALU_result:std_logic_vector(7 downto 0);
signal ALU_ADD:std_logic_vector(8 downto 0);
signal C,V,Z,V,N,add_ov,sub_ov:std_logic;

begin
process(ALU_sel,A,B)
begin
         ALU_ADD <= "000000000";
	 case(ALU_sel) is
     
        when "000" => -- ADD
		ALU_ADD <= ('0' & A) + ('0' & B);
		ALU_result <= A+B;
		when "001" => --SUB
		ALU_ADD <= ('0' & B) -('0' & A);
		ALU_result <= B-A;
		when "010" => --AND
        ALU_result <= A and B;
        when "011" => -- OR		
		ALU_result <= A or B;
		when "100" => -- INCREMENT
	    ALU_result <= A + x"01";
		when "101" => --DECREMENT
		ALU_result <= A - x"01";
		
		when others =>
		   ALU_result <= A+B;
		   
	end case;
end process;
	
	Result <= ALU_result;
	N <= ALU_result(7);
	Z <= '1' when ALU_result = x"00" else '0';
	--Overflow flag condition
	add_ov <= (A(7) and B(7) and (not ALU_result(7))) or ((not A(7)) and (not B(7));
	sub_ov <= (A(7) and (not B(7) and (not ALU_result(7)))) or (not A(7)) and B(7);
	with ALU_sel select
	V <= add_ov when "000",
	sub_ov when "001",
	'0' when others;
	--Carry out flag condition
	with ALU_sel select
	C <= ALU_ADD(8) when "000",
	ALU_ADD(8) when "001",
	'0' when others;
	NZVC <= N & Z & V & C;
end behavioral;	