library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Encryptor_3Rounds is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Key : in std_logic_vector (127 downto 0); -- Key in
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end Encryptor_3Rounds;

architecture Behav of Encryptor_3Rounds is

component SBox128 is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Data_OUT : out std_logic_vector (127 downto 0) --Data out
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


begin

Sbox : Sbox128 port map (Data_IN,Clock,reset,Bwire);
Shift: Shift_rows port map(Bwire,Cwire);


Data_OUT <= Key XOR Cwire;
end architecture;