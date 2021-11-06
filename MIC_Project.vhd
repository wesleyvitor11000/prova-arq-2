LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY MIC_Project IS
PORT (
    CLK             :   IN STD_LOGIC;
    RESET           :   IN STD_LOGIC;
    AMUX            :   IN STD_LOGIC;
    ALU             :   IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    MBR             :   IN STD_LOGIC;
    MAR             :   IN STD_LOGIC;
    RD              :   IN STD_LOGIC;
    WR              :   IN STD_LOGIC;
    ENC             :   IN STD_LOGIC;  
    C               :   IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    B               :   IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    A               :   IN STD_LOGIC_VECTOR(3 DOWNTO 0);    
    MEM_TO_MBR      :   IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    DATA_OK         :   IN STD_LOGIC;
	MUX_A	        :   IN std_logic_vector(1 DOWNTO 0);
	MUX_B		    :   IN std_logic_vector(1 DOWNTO 0);
	MUX_C		    :   IN std_logic_vector(1 DOWNTO 0);
    MBR_TO_MEM      :   OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    MAR_OUTPUT      :   OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
    RD_OUTPUT       :   OUT STD_LOGIC;
    WR_OUTPUT       :   OUT STD_LOGIC;
    Z               :   OUT STD_LOGIC;
    N               :   OUT STD_LOGIC);

END MIC_Project;

ARCHITECTURE comportamental OF MIC_Project IS
    SIGNAL A_BUS : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL B_BUS : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL C_BUS : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL REG_MBR_IN : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL REG_MBR_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL REG_MAR : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL RD_OUT, WR_OUT : STD_LOGIC;

COMPONENT MIC_Banck_Registers
	PORT (
	Reset       : IN STD_LOGIC;
	Clk         : IN STD_LOGIC;
	Enc         : IN STD_LOGIC;
	A_Address   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	B_Address   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	C_Address   : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
	MUX_A	    : IN std_logic_vector(1 DOWNTO 0);
	MUX_B		: IN std_logic_vector(1 DOWNTO 0);
	MUX_C		: IN std_logic_vector(1 DOWNTO 0);   
	C_Input     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	A_Output    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	B_Output    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END COMPONENT;

COMPONENT MIC_amux_alu
	PORT (
	amux        : IN std_logic;
	alu         : IN std_logic_vector(1 downto 0);
	A_Input     : IN std_logic_vector(15 DOWNTO 0);
	B_Input     : IN std_logic_vector(15 DOWNTO 0);
	MBR_Input   : IN std_logic_vector(15 DOWNTO 0);
	N           : OUT std_logic;
	Z           : OUT std_logic;
	ULA_Output  : INOUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;
BEGIN

    MAR_OUTPUT  <= REG_MAR(11 DOWNTO 0);
    MBR_TO_MEM  <= REG_MBR_OUT(15 DOWNTO 0);
    WR_OUTPUT   <= WR_OUT;
    RD_OUTPUT   <= RD_OUT;

Registers: MIC_Banck_Registers
    PORT MAP (
    Reset     => RESET,
    Clk       => CLK,
    Enc       => ENC,
    A_Address => A,
    B_Address => B,
    C_Address => C,
    A_MUX     => MUX_A,
    B_MUX     => MUX_B,
    C_MUX     => MUX_C,
    C_Input   => C_BUS,
    A_Output  => A_BUS,
    B_Output  => B_BUS
    );

MUX_ALU_DESLOCADOR: MIC_amux_alu
    PORT MAP (
    amux        => AMUX,
    alu         => ALU,
    A_Input     => A_BUS,
    B_Input     => B_BUS,
    MBR_Input   => REG_MBR_IN, 
    N           => N,
    Z           => Z,
    ALU_Output  => C_BUS
    );

MAR_Process : PROCESS (Clk, Reset, MAR)
    BEGIN
        IF Reset = '1' THEN
        REG_MAR <= "000000000000"; --(12 bits)
        ELSIF (rising_edge(Clk) AND MAR = '1') THEN
        REG_MAR <= B_BUS(11 DOWNTO 0);
        ELSE
        REG_MAR <= REG_MAR;
        END IF;
    End Process MAR_Process;

MBR_OUT_Process : PROCESS (Clk, Reset, MBR)
    BEGIN
        IF Reset = '1' THEN
        REG_MBR_OUT <= "0000000000000000";
        ELSIF (rising_edge(Clk) AND MBR = '1') THEN
        REG_MBR_OUT <= C_BUS(15 DOWNTO 0);
        ELSE
        REG_MBR_OUT <= REG_MBR_OUT;
        END IF;
    End Process MBR_OUT_Process;

MBR_IN_Process : PROCESS (Clk, Reset, DATA_OK)
    BEGIN
        IF Reset = '1' THEN
        REG_MBR_IN <= "0000000000000000";
        ELSIF (rising_edge(Clk) AND DATA_OK = '1') THEN
        REG_MBR_IN <= MEM_TO_MBR(15 DOWNTO 0);
        ELSE
        REG_MBR_IN <= REG_MBR_IN;
        END IF;
    End Process MBR_IN_Process;

WR_OUT_Process : PROCESS (Clk, Reset, WR)
    BEGIN
        IF Reset = '1' THEN
        WR_OUT <= '0';
        ELSIF (rising_edge(Clk)) THEN
        WR_OUT <= WR;
        ELSE
        WR_OUT <= WR_OUT;
        END IF;
    End Process WR_OUT_Process;

END comportamental;
