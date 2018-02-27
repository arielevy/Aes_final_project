library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Key_Schedlear is
port(
Key_IN :in std_logic_vector (127 downto 0); -- Key in
Clock : in std_logic; --Clock in
reset :in std_logic;
Key_OUT : out std_logic_vector (127 downto 0) --Data out for the second moudle of AES
);
end Key_Schedlear;