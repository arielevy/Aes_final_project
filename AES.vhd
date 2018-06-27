library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity AES is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
Behavior : in std_logic; -- if Behavior=0 act as Encryptor. if Behavior=1 act as Decryptor
reset : in std_logic; -- reset
Round : out std_logic_vector(3 downto 0); -- The round key that AES is need
Key : in std_logic_vector (127 downto 0); -- Key in
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end AES;

architecture Behav of AES is

component Encryptor is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Key : in std_logic_vector (127 downto 0); -- Key in
Round : out std_logic_vector(3 downto 0); -- The round key that Encryptor is need
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end component;

component Decryptor is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Key : in std_logic_vector (127 downto 0); -- Key in
Round : out std_logic_vector(3 downto 0); -- The round key that Encryptor is need
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end component;

signal In_mux_E,Out_mux_E,Key_mux_E :std_logic_vector (127 downto 0); -- wire for mux
signal In_mux_D,Out_mux_D,Key_mux_D :std_logic_vector (127 downto 0); -- wire for mux
signal Round_mux_E :std_logic_vector (3 downto 0); -- wire for mux
signal Round_mux_D :std_logic_vector (3 downto 0); -- wire for mux
signal Clock_mux_E :std_logic; -- wire for mux
signal Clock_mux_D :std_logic; -- wire for mux

begin
Encryptor1 : Encryptor port map(In_mux_E,Clock_mux_E,reset,Key_mux_E,Round_mux_E,Out_mux_E);
Decryptor1 : Decryptor port map(In_mux_D,Clock_mux_D,reset,Key_mux_D,Round_mux_D,Out_mux_D);
Clock_mux_E<=Clock;
Clock_mux_D<=Clock;

process(Behavior,Clock)
	begin
		if (Clock'event and Clock='0' and Behavior='0') then --Encryptor
				In_mux_E<=Data_IN; -- move the data to Encryptor
				Key_mux_E<=Key;    -- move the key to Encryptor
				Round<=Round_mux_E;-- the round from the Encryptor
				Data_OUT<=Out_mux_E;	--data out from Encryptor
		elsif (Clock'event and Clock='0' and Behavior='1') then --Decryptor
				In_mux_D<=Data_IN; -- move the data to Decryptor
				Key_mux_D<=Key; 	 -- move the key to Decryptor
				Round<=Round_mux_D;-- the round from the Decryptor
				Data_OUT<=Out_mux_D;-- data out from Decryptor		
		end if;
end process;
end architecture;



