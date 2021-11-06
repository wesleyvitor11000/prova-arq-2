LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
--Testbench--
ENTITY MIC_Project_Testbench IS
	
END MIC_Project_Testbench;
--------------------------------
ARCHITECTURE Type_01 OF MIC_Project_Testbench IS

CONSTANT Clk_period 		: time := 40 ns;
SIGNAL Clk_count 			: integer := 0;

SIGNAl CLK_Signal			: STD_LOGIC;
SIGNAl RESET_Signal			: STD_LOGIC;
SIGNAl AMUX_Signal			: STD_LOGIC;
SIGNAl MBR_Signal			: STD_LOGIC;
SIGNAl MAR_Signal 			: STD_LOGIC;
SIGNAL RD_Signal			: STD_LOGIC;
SIGNAl WR_Signal			: STD_LOGIC;
SIGNAl ENC_Signal 			: STD_LOGIC;
SIGNAL A_Signal				: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAl B_Signal				: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAl C_Signal 			: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL A_MUX_Signal				: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL B_MUX_Signal				: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL C_MUX_Signal				: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAl ALU_Signal 			: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL MBR_TO_MEM_Signal	: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAl MEM_TO_MBR_Signal 	: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL MAR_OUTPUT_Signal 	: STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL RD_OUTPUT_Signal		: STD_LOGIC := '0';
SIGNAl WR_OUTPUT_Signal		: STD_LOGIC := '0';
SIGNAl Z_Signal				: STD_LOGIC;
SIGNAl N_Signal 			: STD_LOGIC;
SIGNAL DATA_OK_Signal 		: STD_LOGIC := '0';

COMPONENT MIC_Project IS
	PORT (
		 RESET 			: IN STD_LOGIC;
		 CLK 			: IN STD_LOGIC;
		 AMUX  			: IN STD_LOGIC;
		 ALU   			: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 MBR   			: IN STD_LOGIC;
		 MAR   			: IN STD_LOGIC;
		 RD    			: IN STD_LOGIC;
		 WR    			: IN STD_LOGIC;
		 ENC   			: IN STD_LOGIC;
		 C     			: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 B     			: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 A     			: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 MUX_A	        : IN std_logic_vector(1 DOWNTO 0);
		 MUX_B		    : IN std_logic_vector(1 DOWNTO 0);
		 MUX_C		    : IN std_logic_vector(1 DOWNTO 0);
		 MEM_TO_MBR 	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 DATA_OK 		: IN STD_LOGIC;
		
		 MBR_TO_MEM 	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 MAR_OUTPUT 	: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		 RD_OUTPUT 		: OUT STD_LOGIC;
		 WR_OUTPUT 		: OUT STD_LOGIC;
		 Z         		: OUT STD_LOGIC;
		 N         		: OUT STD_LOGIC);
END COMPONENT;
--------------------------------
BEGIN
MIC : MIC_Project
	PORT MAP (
		CLK				=> CLK_Signal,
		RESET 			=> RESET_Signal,
		AMUX 			=> AMUX_Signal,
		MBR 			=> MBR_Signal,
		MAR 			=> MAR_Signal,
		RD 				=> RD_Signal,
		WR 				=> WR_Signal,
		ENC 			=> ENC_Signal,
		DATA_OK 		=> DATA_OK_Signal,
		A 				=> A_Signal,
		B 				=> B_Signal,
		C 				=> C_Signal,
		A_MUX_Signal	=> MUX_A,
		B_MUX_Signal	=> MUX_B,
		C_MUX_Signal	=> MUX_C,
		SH 				=> SH_Signal,
		MBR_TO_MEM 		=> MBR_TO_MEM_Signal,
		MEM_TO_MBR	 	=> MEM_TO_MBR_Signal,
		MAR_OUTPUT 		=> MAR_OUTPUT_Signal,
		RD_OUTPUT 		=> RD_OUTPUT_Signal,
		WR_OUTPUT 		=> WR_OUTPUT_Signal,
		Z 				=> Z_Signal,
		N 				=> N_Signal,
		ALU 			=> ALU_Signal
		);
--------------------------------		


Clock_Process : PROCESS 
  Begin
    CLK_Signal <= '0';
    wait for Clk_period/2;  --for 0.5 ns signal is '0'.
    CLK_Signal  <= '1';
    Clk_count <= Clk_count + 1;
    wait for Clk_period/2;  --for next 0.5 ns signal is '1'.


IF (Clk_count = 12) THEN     
REPORT "Stopping simulkation after 34 cycles";
    	  Wait;       
END IF;

End Process Clock_Process;

--------------------------------	

Reset_Process : PROCESS 
  Begin
    RESET_Signal <= '0';
    Wait for 10 ns;
    RESET_Signal <= '1';
    Wait for 30 ns;
    RESET_Signal <= '0';
    wait;

End Process Reset_Process;

--------------------------------	

PROCESS
	BEGIN
		-- Recebe o valor de dois endereços da memória e guarda no MBR.
		wait for 40ns;
		 
		 AMUX_Signal  		<= '1';
		 ALU_Signal   		<= "00";
		 MBR_Signal   		<= '0';
		 MAR_Signal   		<= '0';
		 RD_Signal    		<= '0';
		 WR_Signal    		<= '0';
		 ENC_Signal   		<= '0';
		 C_Signal     		<= "0000";
		 B_Signal    		<= "0000";
		 A_Signal    		<= "0000";
		 A_MUX_Signal		<= "00";
		 B_MUX_Signal		<= "00";
		 C_MUX_Signal		<= "00";
		 MEM_TO_MBR_Signal 	<= "00000000010101011";-- RA = A e RB = B
		 DATA_OK_Signal 	<= '1';
		 
		 -- Coloca o valor de MBR em IR e MBR novamente.
		 wait for 40ns;

		 AMUX_Signal  		<= '1';
		 ALU_Signal   		<= "0010";
		 MBR_Signal   		<= '1';
		 MAR_Signal   		<= '0';
		 RD_Signal    		<= '0';
		 WR_Signal    		<= '0';
		 ENC_Signal   		<= '1';
		 C_Signal     		<= "0011";
		 B_Signal    		<= "1011";
		 A_Signal    		<= "1010";
		 A_MUX_Signal		<= "00";
		 B_MUX_Signal		<= "00";
		 C_MUX_Signal		<= "00";
		 DATA_OK_Signal 	<= '0';
		 
		 
		-- Colocar o valor de IR - 1 em AC e MBR.
		 wait for 40ns;

		 AMUX_Signal 		<= '0';
		 ALU_Signal  		<= "0011";
		 MBR_Signal			<= '1';
		 MAR_Signal  		<= '0';
		 RD_Signal			<= '0';
		 WR_Signal			<= '0';
		 ENC_Signal			<= '1';
		 C_Signal			<= "0001"; --AC
		 B_Signal			<= "0110"; --(1)
		 A_Signal			<= "0011"; --IR
		 A_MUX_Signal		<= "00";
		 B_MUX_Signal		<= "00";
		 C_MUX_Signal		<= "00";
		 DATA_OK_Signal		<= '0';

		 --Colocar AC AND AM em RA e MBR.
		 wait for 40ns;

		 AMUX_Signal 		<= '0';
		 ALU_Signal  		<= "0001";
		 MBR_Signal			<= '1';
		 MAR_Signal  		<= '0';
		 RD_Signal			<= '0';
		 WR_Signal			<= '0';
		 ENC_Signal			<= '1';
		 C_Signal			<= "0000";
		 B_Signal			<= "1000"; --AM
		 A_Signal			<= "0001"; --AC
		 A_MUX_Signal		<= "00";
		 B_MUX_Signal		<= "00";
		 C_MUX_Signal		<= "01";
		 DATA_OK_Signal		<= '0';
		 
		 --Colocar RA OR AC em RB e MBR;
		 wait for 40ns;

		 AMUX_Signal 		<= '0';
		 ALU_Signal  		<= "0100";
		 MBR_Signal			<= '1';
		 MAR_Signal  		<= '0';
		 RD_Signal			<= '0';
		 WR_Signal			<= '0';
		 ENC_Signal			<= '1';
		 C_Signal			<= "0000";
		 B_Signal			<= "0001"; --AC
		 A_Signal			<= "0000"; 
		 A_MUX_Signal		<= "01"; --RA
		 B_MUX_Signal		<= "00";
		 C_MUX_Signal		<= "10"; --RB
		 DATA_OK_Signal		<= '0';


		 --Multiplicar RA por RB e colocar em AC e MBR
		 wait for 40ns;

         AMUX_Signal 		<= '0';
		 ALU_Signal  		<= "0010";
		 MBR_Signal			<= '1';
		 MAR_Signal  		<= '0';
		 RD_Signal			<= '0';
		 WR_Signal			<= '0';
		 ENC_Signal			<= '1';
		 C_Signal			<= "0001"; --AC
		 B_Signal			<= "0000"; 
		 A_Signal			<= "0101"; --(0)
		 A_MUX_Signal		<= "00"; 
		 B_MUX_Signal		<= "00";
		 C_MUX_Signal		<= "00"; 
		 DATA_OK_Signal		<= '0';
		 
		 wait for 40ns;
		 
		 --Zerar AC
		 AMUX_Signal 		<= '0';
		 ALU_Signal  		<= "0010";
		 MBR_Signal			<= '1';
		 MAR_Signal  		<= '0';
		 RD_Signal			<= '0';
		 WR_Signal			<= '0';
		 ENC_Signal			<= '0';
		 C_Signal			<= "0001"; --AC
		 B_Signal			<= "0000"; 
		 A_Signal			<= "0101"; --0
		 A_MUX_Signal		<= "00";
		 B_MUX_Signal		<= "00";
		 C_MUX_Signal		<= "00";
		 DATA_OK_Signal		<= '0';
		 
		 L1: LOOP
		
			EXIT L1 WHEN N_Signal = '1';
				wait for 40ns;
				--Colocar RA - 1 em RA e MBR
				AMUX_Signal 		<= '0';
				ALU_Signal  		<= "0110";
				MBR_Signal			<= '1';
				MAR_Signal  		<= '0';
				RD_Signal			<= '0';
				WR_Signal			<= '0';
				ENC_Signal			<= '0';
				C_Signal			<= "0000";
				B_Signal			<= "0110"; -- 1
				A_Signal			<= "0000"; 
				A_MUX_Signal		<= "01";
				B_MUX_Signal		<= "00";
				C_MUX_Signal		<= "01";
				DATA_OK_Signal		<= '0';

				wait for 40ns;
				--Colocar AC + RB em AC e MBR
				AMUX_Signal 		<= '0';
				ALU_Signal  		<= "0000";
				MBR_Signal			<= '1';
				MAR_Signal  		<= '0';
				RD_Signal			<= '0';
				WR_Signal			<= '0';
				ENC_Signal			<= '0';
				C_Signal			<= "0000";
				B_Signal			<= "0000";
				A_Signal			<= "0001"; 
				A_MUX_Signal		<= "00";
				B_MUX_Signal		<= "10";
				C_MUX_Signal		<= "00";
				DATA_OK_Signal		<= '0';
	
		END LOOP;

		wait for 40ns;
		 
		--Zerar AC
		AMUX_Signal 		<= '0';
		ALU_Signal  		<= "0010";
		MBR_Signal			<= '1';
		MAR_Signal  		<= '0';
		RD_Signal			<= '0';
		WR_Signal			<= '0';
		ENC_Signal			<= '0';
		C_Signal			<= "0001"; --AC
		B_Signal			<= "0000"; 
		A_Signal			<= "0101"; --0
		A_MUX_Signal		<= "00";
		B_MUX_Signal		<= "00";
		C_MUX_Signal		<= "00";
		DATA_OK_Signal		<= '0';

		wait for 40ns;
		 
		--Colocar IR - 1 em RA
		AMUX_Signal 		<= '0';
		ALU_Signal  		<= "0110";
		MBR_Signal			<= '1';
		MAR_Signal  		<= '0';
		RD_Signal			<= '0';
		WR_Signal			<= '0';
		ENC_Signal			<= '0';
		C_Signal			<= "0000"; 
		B_Signal			<= "0000"; --(1)
		A_Signal			<= "0011"; --IR
		A_MUX_Signal		<= "00";
		B_MUX_Signal		<= "00";
		C_MUX_Signal		<= "01";
		DATA_OK_Signal		<= '0';

		L2: LOOP
		
			EXIT L1 WHEN N_Signal = '1';
				wait for 40ns;
				--Colocar RA - RB em RA e MBR
				AMUX_Signal 		<= '0';
				ALU_Signal  		<= "0110";
				MBR_Signal			<= '1';
				MAR_Signal  		<= '0';
				RD_Signal			<= '0';
				WR_Signal			<= '0';
				ENC_Signal			<= '0';
				C_Signal			<= "0000";
				B_Signal			<= "0000"; 
				A_Signal			<= "0000"; 
				A_MUX_Signal		<= "01";
				B_MUX_Signal		<= "10";
				C_MUX_Signal		<= "01";
				DATA_OK_Signal		<= '0';

				wait for 40ns;
				--Colocar AC + 1 em AC e MBR
				AMUX_Signal 		<= '0';
				ALU_Signal  		<= "0000";
				MBR_Signal			<= '1';
				MAR_Signal  		<= '0';
				RD_Signal			<= '0';
				WR_Signal			<= '0';
				ENC_Signal			<= '0';
				C_Signal			<= "0001"; --AC
				B_Signal			<= "0110"; --(1)
				A_Signal			<= "0001"; --AC 
				A_MUX_Signal		<= "00";
				B_MUX_Signal		<= "00";
				C_MUX_Signal		<= "00";
				DATA_OK_Signal		<= '0';
	
		END LOOP;
		--AND de AC com SM e coloca em B e MBR.
		 wait for 40ns;

		 AMUX_Signal 		<= '0';
		 ALU_Signal  		<= "01";
		 MBR_Signal			<= '1';
		 MAR_Signal  		<= '0';
		 RD_Signal			<= '0';
		 WR_Signal			<= '0';
		 ENC_Signal			<= '1';
		 C_Signal			<= "1011"; --B
		 B_Signal			<= "1001"; --SM
		 A_Signal			<= "0001"; --AC
		 SH_Signal			<= "00";
		 DATA_OK_Signal		<= '0';

		 -- Tenta colocar AC em AMask.
		 wait for 40ns;

		 AMUX_Signal 		<= '0';
		 ALU_Signal  		<= "10";
		 MBR_Signal			<= '0';
		 MAR_Signal  		<= '0';
		 RD_Signal			<= '0';
		 WR_Signal			<= '0';
		 ENC_Signal			<= '1';
		 C_Signal			<= "1000"; --AM
		 B_Signal			<= "0000";
		 A_Signal			<= "0001"; --AC
		 SH_Signal			<= "00";
		 DATA_OK_Signal		<= '0';

		 -- Verifica AM colocando o valor em MBR
		 wait for 40ns;

		 AMUX_Signal 		<= '0';
		 ALU_Signal  		<= "10";
		 MBR_Signal			<= '1';
		 MAR_Signal  		<= '0';
		 RD_Signal			<= '0';
		 WR_Signal			<= '0';
		 ENC_Signal			<= '0';
		 C_Signal			<= "0000"; 
		 B_Signal			<= "0000";
		 A_Signal			<= "1000"; --AM
		 SH_Signal			<= "00";
		 DATA_OK_Signal		<= '0';
		 
		  -- Soma A e B e coloca em MBR.
		  wait for 40ns;

		  AMUX_Signal 		<= '0';
		  ALU_Signal  		<= "00";
		  MBR_Signal		<= '1';
		  MAR_Signal  		<= '0';
		  RD_Signal			<= '0';
		  WR_Signal			<= '0';
		  ENC_Signal		<= '0';
		  C_Signal			<= "0000"; 
		  B_Signal			<= "1011";
		  A_Signal			<= "1010"; 
		  SH_Signal			<= "00";
		  DATA_OK_Signal	<= '0';
		  
		  -- Colocar AC em MAR.
		  wait for 40ns;

		  AMUX_Signal 		<= '0';
		  ALU_Signal  		<= "10";
		  MBR_Signal		<= '0';
		  MAR_Signal  		<= '1';
		  RD_Signal			<= '0';
		  WR_Signal			<= '0';
		  ENC_Signal		<= '0';
		  C_Signal			<= "0000"; 
		  B_Signal			<= "0001";
		  A_Signal			<= "1010"; 
		  SH_Signal			<= "00";
		  DATA_OK_Signal	<= '0';
		  wait;
END process;


END Type_01;
