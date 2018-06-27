library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Controller is
port(
Clock : in std_logic; -- clock 50Mhz in 
Reset : in std_logic; -- reset in
Command : out std_logic;
start : out std_logic;
Data_in : buffer std_logic_vector (127 downto 0);
Data_out : in std_logic_vector (127 downto 0);
Key_in : buffer std_logic_vector (127 downto 0);
UART_TXD_C: out std_logic; -- serial transmit data
UART_RXD_C: in  std_logic; -- serial receive data
reset_to_AES: out std_logic;
Leds :out std_logic_vector (17 downto 0); --debug erase
reset_to_Key: out std_logic
);
end Controller;


architecture Final of Controller is

component UART
port(   CLK         : in  std_logic; -- system clock
        RST         : in  std_logic; -- high active synchronous reset
        -- UART INTERFACE
        UART_TXD    : out std_logic; -- serial transmit data
        UART_RXD    : in  std_logic; -- serial receive data
        -- USER DATA INPUT INTERFACE
        DATA_IN     : in  std_logic_vector(7 downto 0); -- input data
        DATA_SEND   : in  std_logic; -- when DATA_SEND = 1, input data are valid and will be transmit
        BUSY        : out std_logic; -- when BUSY = 1, transmitter is busy and you must not set DATA_SEND to 1
        -- USER DATA OUTPUT INTERFACE
        DATA_OUT    : out std_logic_vector(7 downto 0); -- output data
        DATA_VLD    : out std_logic; -- when DATA_VLD = 1, output data are valid
        FRAME_ERROR : out std_logic  -- when FRAME_ERROR = 1, stop bit was invalid
);
end component;


component reg is
Generic (size: integer:=128);
port(input :in std_logic_vector(size-1 downto 0);
	  output:out std_logic_vector(size-1 downto 0);
	  clock: in std_logic;
	  reset: in std_logic;
	  enable:in std_logic
);
end component;

component DMux_for_Controller is
Port(
 Data_in : in  STD_LOGIC_VECTOR (7 downto 0);	 --Data in from the uart
 clock : in STD_LOGIC;
 reset : in STD_LOGIC;
 enable : in std_logic;
 sel : in STD_LOGIC_VECTOR (3 downto 0);
 Data_out0 : out  STD_LOGIC_VECTOR (7 downto 0); -- Data out to "Data in" register in the controller
 Data_out1 : out  STD_LOGIC_VECTOR (7 downto 0);
 Data_out2 : out  STD_LOGIC_VECTOR (7 downto 0);
 Data_out3 : out  STD_LOGIC_VECTOR (7 downto 0);
 Data_out4 : out  STD_LOGIC_VECTOR (7 downto 0);
 Data_out5 : out  STD_LOGIC_VECTOR (7 downto 0);
 Data_out6 : out  STD_LOGIC_VECTOR (7 downto 0);
 Data_out7 : out  STD_LOGIC_VECTOR (7 downto 0);
 Data_out8 : out  STD_LOGIC_VECTOR (7 downto 0);
 Data_out9 : out  STD_LOGIC_VECTOR (7 downto 0);
 Data_out10 : out  STD_LOGIC_VECTOR (7 downto 0);
 Data_out11 : out  STD_LOGIC_VECTOR (7 downto 0);
 Data_out12 : out  STD_LOGIC_VECTOR (7 downto 0);
 Data_out13 : out  STD_LOGIC_VECTOR (7 downto 0);
 Data_out14 : out  STD_LOGIC_VECTOR (7 downto 0);
 Data_out15 : out  STD_LOGIC_VECTOR (7 downto 0)
);
end component;

component Mux_for_Controller is
Port(
 Data_in0 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in1 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in2 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in3 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in4 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in5 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in6 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in7 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in8 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in9 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in10 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in11 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in12 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in13 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in14 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in15 : in  STD_LOGIC_VECTOR (7 downto 0);
 clock : in STD_LOGIC;
 sel : in STD_LOGIC_VECTOR (3 downto 0);
 Data_out : out  STD_LOGIC_VECTOR (7 downto 0)
);
end component;

-- wires for Rs-232
signal Wire_send : STD_LOGIC;
signal Wire_Busy : STD_LOGIC;
signal Uart_DATA_OUT : STD_LOGIC_VECTOR (7 downto 0);
signal Uart_DATA_IN : STD_LOGIC_VECTOR (7 downto 0);
signal Wire_DATA_VLD : std_LOGIC;
signal Wire_FRAME_ERROR : std_LOGIC;
signal Flag_Error : std_LOGIC;

signal wire_enable :std_logic;

--wires for register
signal Wire_enable_Reg_Data_in , Wire_rst_Reg_Data_in : STD_LOGIC;

-- wires for Dmux data in
signal wire_select_Dmux : STD_LOGIC_VECTOR (3 downto 0) :="0000";

signal Wire_reset_Dmux,Wire_enable_Dmux: STD_LOGIC := '0';
signal Wire_Dmux0,Wire_Dmux1,Wire_Dmux2,Wire_Dmux3,Wire_Dmux4,Wire_Dmux5,Wire_Dmux6,Wire_Dmux7 :STD_LOGIC_VECTOR (7 downto 0);
signal Wire_Dmux8,Wire_Dmux9,Wire_Dmux10,Wire_Dmux11,Wire_Dmux12,Wire_Dmux13,Wire_Dmux14,Wire_Dmux15 :STD_LOGIC_VECTOR (7 downto 0);

-- wires for Dmux Key in
signal wire_select_Key : STD_LOGIC_VECTOR (3 downto 0) :="0000";
signal Wire_reset_Key,Wire_enable_Key: STD_LOGIC := '0';
signal Wire_Key0,Wire_Key1,Wire_Key2,Wire_Key3,Wire_Key4,Wire_Key5,Wire_Key6,Wire_Key7 :STD_LOGIC_VECTOR (7 downto 0);
signal Wire_Key8,Wire_Key9,Wire_Key10,Wire_Key11,Wire_Key12,Wire_Key13,Wire_Key14,Wire_Key15 :STD_LOGIC_VECTOR (7 downto 0);

-- wires for mux data out
signal wire_select_DataOut : STD_LOGIC_VECTOR (3 downto 0);
signal Wire_reset_DataOut,Wire_enable_DataOut: STD_LOGIC := '0';
signal Wire_data_out :STD_LOGIC_VECTOR (127 downto 0);

alias Wire_Mux0 :STD_LOGIC_VECTOR (7 downto 0) is Wire_data_out (7 downto 0);
alias Wire_Mux1 :STD_LOGIC_VECTOR (7 downto 0) is Wire_data_out (15 downto 8);
alias Wire_Mux2 :STD_LOGIC_VECTOR (7 downto 0) is Wire_data_out (23 downto 16);
alias Wire_Mux3 :STD_LOGIC_VECTOR (7 downto 0) is Wire_data_out (31 downto 24);
alias Wire_Mux4 :STD_LOGIC_VECTOR (7 downto 0) is Wire_data_out (39 downto 32);
alias Wire_Mux5 :STD_LOGIC_VECTOR (7 downto 0) is Wire_data_out (47 downto 40);
alias Wire_Mux6 :STD_LOGIC_VECTOR (7 downto 0) is Wire_data_out (55 downto 48);
alias Wire_Mux7 :STD_LOGIC_VECTOR (7 downto 0) is Wire_data_out (63 downto 56);
alias Wire_Mux8 :STD_LOGIC_VECTOR (7 downto 0) is Wire_data_out (71 downto 64);
alias Wire_Mux9 :STD_LOGIC_VECTOR (7 downto 0) is Wire_data_out (79 downto 72);
alias Wire_Mux10 :STD_LOGIC_VECTOR (7 downto 0) is Wire_data_out (87 downto 80);
alias Wire_Mux11 :STD_LOGIC_VECTOR (7 downto 0) is Wire_data_out (95 downto 88);
alias Wire_Mux12 :STD_LOGIC_VECTOR (7 downto 0) is Wire_data_out (103 downto 96);
alias Wire_Mux13 :STD_LOGIC_VECTOR (7 downto 0) is Wire_data_out (111 downto 104);
alias Wire_Mux14 :STD_LOGIC_VECTOR (7 downto 0) is Wire_data_out (119 downto 112);
alias Wire_Mux15 :STD_LOGIC_VECTOR (7 downto 0)  is Wire_data_out (127 downto 120);


--wires for command
signal wire_Command_reg : STD_LOGIC_VECTOR (7 downto 0);
signal Wire_reset_Command_reg : std_LOGIC;
signal Wire_enable_Command_reg : std_LOGIC;

signal wakeup : STD_LOGIC :='1';
signal valid_data : STD_LOGIC :='0';


begin
RS232 : UART port map(Clock,reset,UART_TXD_C,UART_RXD_C,Uart_DATA_IN,Wire_send,Wire_Busy,Uart_DATA_OUT,Wire_DATA_VLD,Wire_FRAME_ERROR);

reg_Data_in : reg generic map (size=>128) port map(Wire_Dmux15 & Wire_Dmux14 & Wire_Dmux13 & Wire_Dmux12 & Wire_Dmux11 & Wire_Dmux10 & Wire_Dmux9 & Wire_Dmux8
									& Wire_Dmux7 & Wire_Dmux6 & Wire_Dmux5 & Wire_Dmux4 & Wire_Dmux3 & Wire_Dmux2 & Wire_Dmux1 & Wire_Dmux0
				,Data_in,Clock,Wire_rst_Reg_Data_in,wire_enable);

--reg_Data_in : reg generic map (size=>128) port map(x"00000000000000000000000000000000"
--				,Data_in,Clock,Wire_rst_Reg_Data_in,Wire_enable_Reg_Data_in);
				
Dmux_Data_in : DMux_for_Controller port map(Uart_DATA_OUT,Clock,reset,Wire_enable_Key,wire_select_Dmux,
									Wire_Dmux0,Wire_Dmux1,Wire_Dmux2,Wire_Dmux3,Wire_Dmux4,Wire_Dmux5,Wire_Dmux6,Wire_Dmux7,
									Wire_Dmux8,Wire_Dmux9,Wire_Dmux10,Wire_Dmux11,Wire_Dmux12,Wire_Dmux13,Wire_Dmux14,Wire_Dmux15);
									
reg_Key_in : reg generic map (size=>128) port map(Wire_Key15 & Wire_Key14 & Wire_Key13 & Wire_Key12 & Wire_Key11 & Wire_Key10 & Wire_Key9 & Wire_Key8
									& Wire_Key7 & Wire_Key6 & Wire_Key5 & Wire_Key4 & Wire_Key3 & Wire_Key2 & Wire_Key1 & Wire_Key0
				,Key_in,Clock,Wire_reset_Key,wire_enable);
				
--reg_Key_in : reg generic map (size=>128) port map(x"00000000000000000000000000000000"
--				,Key_in,Clock,Wire_reset_Key,Wire_enable_Key);
				
Dmux_Key_in : DMux_for_Controller port map(Uart_DATA_OUT,Clock,reset,Wire_enable_Key,wire_select_Key,
									Wire_Key0,Wire_Key1,Wire_Key2,Wire_Key3,Wire_Key4,Wire_Key5,Wire_Key6,Wire_Key7,
									Wire_Key8,Wire_Key9,Wire_Key10,Wire_Key11,Wire_Key12,Wire_Key13,Wire_Key14,Wire_Key15);
									
reg_Data_out_to_comp : reg generic map (size=>128) port map(Data_out,Wire_data_out,
									Clock,Wire_reset_DataOut,Wire_enable_DataOut);
									
Mux_Data_out_to_comp : Mux_for_Controller port map(Wire_Mux0,Wire_Mux1,Wire_Mux2,Wire_Mux3,Wire_Mux4,Wire_Mux5,Wire_Mux6,Wire_Mux7,
									Wire_Mux8,Wire_Mux9,Wire_Mux10,Wire_Mux11,Wire_Mux12,Wire_Mux13,Wire_Mux14,Wire_Mux15
							,Clock,wire_select_DataOut,Uart_DATA_IN);	
							
reg_Command : reg generic map (size=>8) port map(Uart_DATA_OUT,wire_Command_reg,Clock,reset,Wire_enable_Command_reg); --Wire_reset_Command_reg
							
			
Recive_Data_process:process(Clock,Wire_DATA_VLD,reset)
						variable I : integer range 0 to 70 :=0;	
						begin
						
						if(reset = '1') then
						I := 0;
						leds(16 downto 0)<="00000000000000000";
						wire_select_Dmux <="0000";
						wire_select_Key  <="0000";
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='0';
						Flag_Error<='0';
						valid_data<='0';
						leds(17) <='0';
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and wakeup='1') then
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and wakeup='1') then
						wakeup<='0'; --the rs232 wakeup with Wire_DATA_VLD =0 and then Wire_DATA_VLD=1, this two linas are "filter" 
						
						-- Command_reg
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=0 and wakeup='0') then
						Wire_enable_Command_reg<= '1' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0000";
						wire_select_Dmux <="0000";
						valid_data<='0';
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=1 and wakeup='0') then
						Wire_enable_Command_reg<= '1' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0000";
						wire_select_Dmux <="0000";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						
						-- Key 0
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=2 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0000";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=3 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0000";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						-- key1
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=4 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0001";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=5 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0001";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						--key2
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=6 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0010";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=7 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0010";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						--key3
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=8 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0011";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=9 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0011";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						--key4
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=10 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0100";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=11 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0100";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						--key5
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=12 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0101";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=13 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0101";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						--key6
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=14 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0110";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=15 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0110";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						--key7
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=16 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0111";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=17 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="0111";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						--key8
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=18 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="1000";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=19 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="1000";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1; 
						--key9
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=20 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="1001";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=21 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="1001";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1; 
						--key10
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=22 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="1010";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=23 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="1010";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1; 
						--key11
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=24 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="1011";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=25 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="1011";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1; 
						--key12
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=26 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="1100";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=27 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="1100";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1; 
						--key13
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=28 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="1101";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=29 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="1101";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						--key14
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=30 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="1110";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=31 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="1110";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						--key15
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=32 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="1111";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=33 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '1';
						Wire_enable_Reg_Data_in <='0';
						wire_select_Key  <="1111";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;

						-- Data 0
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=34 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="0000";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=35 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="0000";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						-- Data 1
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=36 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="0001";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=37 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="0001";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						-- Data 2
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=38 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="0010";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=39 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="0010";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						-- Data 3
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=40 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="0011";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=41 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="0011";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						-- Data 4
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=42 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="0100";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=43 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="0100";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						-- Data 5
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=44 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="0101";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=45 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="0101";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						-- Data 6
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=46 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="0110";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=47 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="0110";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						-- Data 7
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=48 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="0111";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=49 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="0111";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						-- Data 8
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=50 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="1000";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=51 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="1000";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						-- Data 9
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=52 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="1001";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=53 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="1001";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						-- Data 10
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=54 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="1010";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=55 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="1010";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						-- Data 11
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=56 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="1011";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=57 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="1011";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						-- Data 12
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=58 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="1100";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=59 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="1100";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						-- Data 13
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=60 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="1101";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=61 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="1101";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						-- Data 14
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=62 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="1110";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=63 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="1110";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						-- Data 15
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='1' and I=64 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="1111";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=65 and wakeup='0') then
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='1';
						wire_select_Dmux  <="1111";
						if(Wire_FRAME_ERROR = '1') then Flag_Error<='1'; end if;
						I := I+1;
						elsif (Clock'event and Clock='1' and Wire_DATA_VLD ='0' and I=66 and wakeup='0') then			         	
						if(Wire_FRAME_ERROR = '0' ) then valid_data<='1'; else valid_data<='0'; leds(0)<='1'; end if;
						I:=0;
						Wire_enable_Command_reg<= '0' ;
						Wire_enable_Key <= '0';
						Wire_enable_Reg_Data_in <='0';
						end if;				
						end process;



Send_Data_process:process(Clock,reset,valid_data)
						variable k : integer range 0 to 10*8388608 :=0;	
						begin
						if(reset = '1' or valid_data ='0') then
						reset_to_AES<='1';
						reset_to_Key<='1';
						wire_enable<='0';
						k := 0;
						elsif (Clock'event and Clock = '0' and k<2) then
						Command<=wire_Command_reg(0);
						reset_to_AES<='0';
						reset_to_Key<='0';
						k := k+1;
						wire_enable<='1';
						elsif (Clock'event and Clock = '0' and k<200) then
						wire_enable<='1';
						k := k+1;
						start<='1';
						elsif (Clock'event and Clock = '0' and k<2175) then --4340
						start<='0';
						Wire_enable_DataOut<='1';
						Wire_send<='0';
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <2*2175 ) then
						Wire_enable_DataOut<='1';						
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <3*2175) then --0
						Wire_send<=('1'  and not (Wire_Busy));
						wire_select_DataOut<="0000";
						Wire_enable_DataOut<='0';
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <5*2175) then --1
						Wire_send<=('1'  and not (Wire_Busy));
						wire_select_DataOut<="0001";
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <7*2175) then --2
						Wire_send<=('1'  and not (Wire_Busy));
						wire_select_DataOut<="0010";
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <9*2175) then --3
						Wire_send<=('1'  and not (Wire_Busy));
						wire_select_DataOut<="0011";
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <11*2175) then --4
						Wire_send<=('1'  and not (Wire_Busy));
						wire_select_DataOut<="0100";
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <13*2175) then --5
						Wire_send<=('1'  and not (Wire_Busy));
						wire_select_DataOut<="0101";
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <15*2175) then --6
						Wire_send<=('1'  and not (Wire_Busy));
						wire_select_DataOut<="0110";
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <17*2175) then --7
						Wire_send<=('1'  and not (Wire_Busy));
						wire_select_DataOut<="0111";
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <19*2175) then --8
						Wire_send<=('1'  and not (Wire_Busy));
						wire_select_DataOut<="1000";
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <21*2175) then -- 9
						Wire_send<=('1'  and not (Wire_Busy));
						wire_select_DataOut<="1001";
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <23*2175 ) then --10
						Wire_send<=('1'  and not (Wire_Busy));
						wire_select_DataOut<="1010";
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <25*2175) then --11
						Wire_send<=('1'  and not (Wire_Busy));
						wire_select_DataOut<="1011";
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <27*2175) then --12
						Wire_send<=('1'  and not (Wire_Busy));
						wire_select_DataOut<="1100";
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <29*2175) then --13
						Wire_send<=('1'  and not (Wire_Busy));
						wire_select_DataOut<="1101";
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <31*2175) then --14
						Wire_send<=('1'  and not (Wire_Busy));
						wire_select_DataOut<="1110";
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <33*2175) then --15
						Wire_send<=('1'  and not (Wire_Busy));
						wire_select_DataOut<="1111";
						k := k+1;
						elsif (Clock'event and Clock = '0' and k <34*2175) then
						k := k+1;
						Wire_send<='0';
						elsif (Clock'event and Clock = '0' and k =34*2175) then
						k :=34*2175;
						end if;
						end process;
					
end architecture;
