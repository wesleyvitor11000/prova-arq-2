library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity MIC_amux_alu is
port (
    AMUX        : in std_logic;
    ALU         : in std_logic_vector(3 downto 0);
    A_Input     : in std_logic_vector(15 downto 0);
    B_Input     : in std_logic_vector(15 downto 0);
    MBR_Input   : in std_logic_vector(15 downto 0);
    N           : out std_logic;
    Z           : out std_logic;
    ALU_Output  : inout std_logic_vector(15 downto 0)
    );
end MIC_amux_alu;

architecture behavioral of MIC_amux_alu is

signal Input_A : std_logic_vector(15 downto 0);

begin

Input_A <= A_Input(15 downto 0) when AMUX ='0' else
			  MBR_Input(15 downto 0);


ALU_Output <= Input_A(15 downto 0) + B_Input(15 downto 0) when ALU = "0000" else
              Input_A(15 downto 0) and B_Input(15 downto 0) when ALU = "0001" else
              Input_A(15 downto 0) when ALU = "0010" else
              not Input_A(15 downto 0) when ALU ="0011" else
              Input_A(15 downto 0) or B_Input(15 downto 0) when ALU = "0100" else
              "0000000000000001" when ALU = "0101" and (Input_A < B_Input) else
              "0000000000000000" when ALU = "0101" and (Input_A >= B_Input) else
              Input_A(15 downto 0) - B_Input(15 downto 0) when ALU = "0110" else
              Input_A(15 downto 0) xor B_Input(15 downto 0) when ALU = "0111" else
              Input_A(15 downto 0) when ALU = "1000" else
              Input_A(14 downto 0) & '0' when ALU = "1001" else
              (Input_A(13 downto 0) & '0') & '0' when ALU = "1010" else
              ((Input_A(12 downto 0) & '0') & '0') & '0' when ALU = "1011" else
              Input_A(15 downto 0) when ALU = "1100" else
              '0' & Input_A(15 downto 1) when ALU = "1101" else
              '0' & ( '0' & Input_A(15 downto 2)) when ALU = "1110" else
              '0' & ('0' & ('0' & Input_A(15 downto 3)));
	  

Z <= '1' when ALU_Output = "0000000000000000" else
'0';

N <= ALU_Output(15);

end behavioral;
