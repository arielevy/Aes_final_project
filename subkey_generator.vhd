library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity subkey_generator is
port(
Key_IN :in std_logic_vector (127 downto 0); -- Key in
Clock : in std_logic; --Clock in
reset :in std_logic;
Rcon_index: in std_logic_vector (3 downto 0);
Key_out : out std_logic_vector (127 downto 0)
);
end subkey_generator;

architecture Behav of subkey_generator is

signal wire1 : std_logic_vector (127 downto 0);
signal wire2 : std_logic_vector (127 downto 0);

component SBox32_key is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end component;

component Shift_rows_key is
Port(
 Key_in : in  STD_LOGIC_VECTOR (127 downto 0);
 Key_out : out  STD_LOGIC_VECTOR (127 downto 0)
);
end component;

component Rcon_adder is
port(
Key_IN :in std_logic_vector (127 downto 0); -- Data in
W3_org : in std_logic_vector (31 downto 0);
Clock : in std_logic; --Clock in
reset : in std_logic;
Rcon_index: in std_logic_vector (3 downto 0);
Key_OUT : out std_logic_vector (127 downto 0) --Data out
);
end component;


begin

	shift :Shift_rows_key port map(Key_IN,wire1);
	s01   :SBox32_key port map (wire1,Clock,reset,wire2);
	Rcon_a:Rcon_adder port map (wire2,Key_IN (127 downto 96),Clock,reset,Rcon_index,Key_out);
 
end architecture;