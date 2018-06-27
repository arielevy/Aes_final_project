library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Top_AES is
port(
SW : in std_logic_vector (0 downto 0);
LEDR : out std_logic_vector (17 downto 0);
CLOCK_50 : in std_logic;
UART_TXD : out std_logic; -- serial transmit data
UART_RXD : in  std_logic -- serial receive data
);
end Top_AES;

architecture Final of Top_AES is

component AES is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
Behavior : in std_logic; -- if Behavior=0 act as Encryptor. if Behavior=1 act as Decryptor
reset : in std_logic; -- reset
Round : out std_logic_vector(3 downto 0); -- The round key that AES is need
Key : in std_logic_vector (127 downto 0); -- Key in
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end component;

component Key_generator is
port(
Key_IN :in std_logic_vector (127 downto 0); -- Key in
Clock : in std_logic; --Clock in
reset : in std_logic; -- reset
Key_req1 : in std_logic_vector(3 downto 0); -- The round key that first moudle of AES is need
Data_OUT1 : out std_logic_vector (127 downto 0) --Data out for the first moudle of AES
);
end component;


component Controller is
port(
Clock : in std_logic; -- clock 50Mhz in 
Reset : in std_logic; -- reset in
Command : out std_logic; 
start : out std_logic;
Data_in : out std_logic_vector (127 downto 0);
Data_out : in std_logic_vector (127 downto 0);
Key_in : out std_logic_vector (127 downto 0);
UART_TXD_C: out std_logic; -- serial transmit data
UART_RXD_C: in  std_logic; -- serial receive data
reset_to_AES: out std_logic;
Leds :out std_logic_vector (17 downto 0); --debug erase
reset_to_Key: out std_logic
);
end component;

signal key1:std_logic_vector (127 downto 0); -- Wire between Key_generator AES1
signal Key_C2G:std_logic_vector (127 downto 0); -- Wire between Controller to Key_generator Data in

signal reset_aes: std_logic;
signal reset_key: std_logic;

signal DataIn_C2A :std_logic_vector (127 downto 0); -- wire between Controller to AES Data In
signal DataOut_C2A :std_logic_vector (127 downto 0); -- wire between Controller to AES Data Out

signal wire_enable_aes: std_LOGIC;
signal wire_Behavior:std_logic;
signal wire_start:std_logic;

signal req_round1 : std_logic_vector (3 downto 0); -- Wire between AES1 to Key_generator for round key

begin

AES1 : AES port map (DataIn_C2A,CLOCK_50,wire_Behavior,reset_aes,req_round1,key1,DataOut_C2A);
Key_generator1: Key_generator port map(Key_C2G,CLOCK_50,reset_key,req_round1,key1);
ControllerOne : Controller port map(CLOCK_50,SW(0),wire_Behavior,wire_start,DataIn_C2A,DataOut_C2A,Key_C2G,UART_TXD,UART_RXD
					,reset_aes,LEDR(17 downto 0),reset_key);

--LEDR(17) <= '1' when Key_C2G =   X"3c4fcf098815f7aba6d2ae2816157e2b" else
--				'0';						--X"2e2b34ca59fa4c883b2c8aefd44be966"	
					
end architecture;