library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity SBox32_key is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end SBox32_key;

architecture Behav of SBox32_key is
component SBox8 is
port(
Data_IN :in std_logic_vector (7 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Data_OUT : out std_logic_vector (7 downto 0) --Data out
);
end component;

signal w1,w2,w3,w4 : std_logic_vector(7 downto 0);

begin

S1 : Sbox8 port map(Data_IN(103 downto 96),Clock,reset,w1); --done Sbox for the last word after the shift
S2 : Sbox8 port map(Data_IN(111 downto 104),Clock,reset,w2);
S3 : Sbox8 port map(Data_IN(119 downto 112),Clock,reset,w3);
S4 : Sbox8 port map(Data_IN(127 downto 120),Clock,reset,w4);

Data_OUT<= w4&w3&w2&w1&Data_IN(95 downto 0); -- add the last word after Sbox to the general Key

end architecture;