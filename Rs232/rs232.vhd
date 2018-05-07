library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity rs232 is
port(
SW:in std_logic_vector (17 downto 0); -- switchs
KEY:in std_logic_vector (0 downto 0); --keys
LEDR:out std_logic_vector (17 downto 0); -- led
CLOCK_50: in std_logic;
UART_RXD:in std_logic;
UART_TXD:out std_logic
);
end rs232;

architecture behavor of rs232 is

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

component one 
port(
Key_in:in std_logic; --keys
clock:in std_logic;
Key_out:out std_logic
);
end component;

signal push: std_logic;


begin
Comm : UART port map (CLOCK_50,'0',UART_TXD,UART_RXD,"01100001",push,open,LEDR(7 downto 0),open,open);
push1 :one port map (KEY(0),CLOCK_50,push);
	
end behavor;