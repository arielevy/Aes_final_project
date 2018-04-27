library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Decryptor_4Rounds is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Key : in std_logic_vector (127 downto 0); -- Key in
first_round : in std_logic;
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end Decryptor_4Rounds;

architecture Behav of Decryptor_4Rounds is

component Inv_SBox128 is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end component;

component Inv_Mix_Column is
port(
Data_IN :in std_logic_vector (31 downto 0); -- Data in
clock : in std_logic;
reset : in std_logic;
Data_OUT : out std_logic_vector (31 downto 0) --Data out
);
end component;

component Inv_Shift_rows is
Port(
 Data_in : in  STD_LOGIC_VECTOR (127 downto 0);
 Data_out : out  STD_LOGIC_VECTOR (127 downto 0)
);
end component;

signal Awire : std_logic_vector (127 downto 0); -- the wire after the key
signal Bwire : std_logic_vector (127 downto 0); -- the wire after the Inv_Mix_Column
signal Cwire : std_logic_vector (127 downto 0); -- the wire the enter the Inv_Shift_rows , can get Awire or Bwire
signal Dwire : std_logic_vector (127 downto 0); -- the wire after the after the Inv_Shift_rows;

begin

Awire <= Data_IN xor Key;

Inv_MiX3 : Inv_Mix_Column port map(Awire(127 downto 96),Clock,reset,Bwire (127 downto 96));
Inv_MiX2 : Inv_Mix_Column port map(Awire(95 downto 64),Clock,reset,Bwire (95 downto 64));
Inv_MiX1 : Inv_Mix_Column port map(Awire(63 downto 32),Clock,reset,Bwire (63 downto 32));
Inv_MiX0 : Inv_Mix_Column port map(Awire(31 downto 0),Clock,reset,Bwire (31 downto 0));
Inv_Shift: Inv_Shift_rows port map(Cwire,Dwire);
Inv_Sbox : Inv_Sbox128 port map (Dwire,Clock,reset,Data_OUT);

Cwire <=Bwire when first_round='0' else
		  Awire when first_round='1';


end architecture;