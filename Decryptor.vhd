library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Decryptor is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Key : in std_logic_vector (127 downto 0); -- Key in
Round : out std_logic_vector(3 downto 0); -- The round key that Decryptor is need
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end Decryptor;

architecture Behav of Decryptor is
begin
end architecture;