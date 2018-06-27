library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DMux_for_ENC is
Port(
 Data_out0 : out  STD_LOGIC_VECTOR (127 downto 0);
 Data_out1 : out  STD_LOGIC_VECTOR (127 downto 0);
 clock : in STD_LOGIC;
 sel : in STD_LOGIC;
 enable : std_LOGIC;
 reset: in std_logic;
 Data_in : in  STD_LOGIC_VECTOR (127 downto 0)
);
end DMux_for_ENC;

architecture beavh of DMux_for_ENC is

component reg is
Generic (size: integer:=128);
port(input :in std_logic_vector(size-1 downto 0);
	  output:out std_logic_vector(size-1 downto 0);
	  clock: in std_logic;
	  reset: in std_logic;
	  enable:in std_logic
);
end component;

begin

Data0 : reg generic map (size=>128) port map (Data_in,Data_out0,clock,reset,not(sel) and enable); -- return to 4 rounds encryption
Data1 : reg generic map (size=>128) port map (Data_in,Data_out1,clock,reset,sel and enable);	   -- Data out
	
end; 