library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Top_AES is
port(
SW : in std_logic_vector (2 downto 0);
CLOCK_50 : in std_logic;
LEDR : out std_logic_vector (1 downto 0)
);
end Top_AES;

architecture Final of Top_AES is

component AES is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
Behavior : in std_logic; -- if Behavior=0 act as Encryptor. if Behavior=1 act as Decryptor
reset : in std_logic; -- reset
enable_aes: in std_LOGIC; -- when the key ready send enable to Encryptor/Decryptor
Round : out std_logic_vector(3 downto 0); -- The round key that AES is need
Key : in std_logic_vector (127 downto 0); -- Key in
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end component;

component Key_generator is
port(
Key_IN :in std_logic_vector (127 downto 0); -- Key in
Clock : in std_logic; --Clock in
reset : in std_logic; -- reset
start :in std_logic; -- enable to start the process of the key
enable_aes: out std_LOGIC; -- when the key ready send enable to Encryptor/Decryptor
Key_req1 : in std_logic_vector(3 downto 0); -- The round key that first moudle of AES is need
Key_req2 : in std_logic_vector(3 downto 0); -- The round key that second module of AES is need
Data_OUT1 : out std_logic_vector (127 downto 0); --Data out for the first moudle of AES
Data_OUT2 : out std_logic_vector (127 downto 0) --Data out for the second moudle of AES
);
end component;


signal key1:std_logic_vector (127 downto 0); -- Wire between Key_generator to AES1
signal key2:std_logic_vector (127 downto 0); -- Wire between Key_generator to AES2

signal Awire:std_logic_vector (127 downto 0); -- Wire between Key_generator to AES1

signal wire_enable_aes: std_LOGIC;

signal req_round1 : std_logic_vector (3 downto 0); -- Wire between AES1 to Key_generator for round key
signal req_round2 : std_logic_vector (3 downto 0); -- Wire between AES2 to Key_generator for round key

begin

AES1 : AES port map (x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"&"000"&SW(0),CLOCK_50,SW(0),SW(1),wire_enable_aes,req_round1,key1,Awire);
--AES2 : AES port map (Awire,SW(0),SW(0),SW(1),req_round2,key2,open);
Key_generator1: Key_generator port map(x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"&"000"&SW(0),CLOCK_50,SW(1),SW(2),wire_enable_aes,req_round1,req_round2,key1,key2);

LEDR <=Awire(1)&Awire(0);
end architecture;