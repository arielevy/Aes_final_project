library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Encryptor_4Rounds is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Key : in std_logic_vector (127 downto 0); -- Key in
last_round : in std_logic;
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end Encryptor_4Rounds;

architecture Behav of Encryptor_4Rounds is

component SBox128 is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end component;

component Mix_Column is
port(
Data_IN :in std_logic_vector (31 downto 0); -- Data in
clock : in std_logic;
reset : in std_logic;
Data_OUT : out std_logic_vector (31 downto 0) --Data out
);
end component;

component Shift_rows is
Port(
 Data_in : in  STD_LOGIC_VECTOR (127 downto 0);
 Data_out : out  STD_LOGIC_VECTOR (127 downto 0)
);
end component Shift_rows;

signal Bwire : std_logic_vector (127 downto 0); -- the wire after the sbox128
signal Cwire : std_logic_vector (127 downto 0); -- the wire after the Shift_rows;
signal Dwire : std_logic_vector (127 downto 0); -- the wire after the Mix_Column;
signal Ewire : std_logic_vector (127 downto 0); -- the wire after the Mix_Column;

begin

Sbox : Sbox128 port map (Data_IN,Clock,reset,Bwire);
Shift: Shift_rows port map(Bwire,Cwire);
MiX3 : Mix_Column port map(Cwire(127 downto 96),Clock,reset,Dwire (127 downto 96));
MiX2 : Mix_Column port map(Cwire(95 downto 64),Clock,reset,Dwire (95 downto 64));
MiX1 : Mix_Column port map(Cwire(63 downto 32),Clock,reset,Dwire (63 downto 32));
MiX0 : Mix_Column port map(Cwire(31 downto 0),Clock,reset,Dwire (31 downto 0));


Ewire <=Dwire when last_round='0' else
		  Cwire when last_round='1';

Data_OUT <= Key Xor Ewire;
end architecture;