library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Encryptor is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Key : in std_logic_vector (127 downto 0); -- Key in
Round : out std_logic_vector(3 downto 0); -- The round key that Encryptor is need
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end Encryptor;

architecture Behav of Encryptor is

component Encryptor_4Rounds is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Key : in std_logic_vector (127 downto 0); -- Key in
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end component Encryptor_4Rounds;

component Encryptor_3Rounds is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Key : in std_logic_vector (127 downto 0); -- Key in
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end component Encryptor_3Rounds;

signal Awire : std_logic_vector (127 downto 0); 
signal Bwire : std_logic_vector (127 downto 0); 
signal Cwire : std_logic_vector (127 downto 0); 
signal Dwire : std_logic_vector (127 downto 0);  

begin

Enc : Encryptor_4Rounds port map (Data_IN,Clock,reset,Key,Data_OUT);

end architecture;