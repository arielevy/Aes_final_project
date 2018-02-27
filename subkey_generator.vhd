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

signal W0 : std_logic_vector (7 downto 0);
signal W1 : std_logic_vector (7 downto 0); 
signal W2 : std_logic_vector (7 downto 0);
signal W3 : std_logic_vector (7 downto 0);
signal W4 : std_logic_vector (7 downto 0);
signal W5 : std_logic_vector (7 downto 0); 
signal W6 : std_logic_vector (7 downto 0);
signal W7 : std_logic_vector (7 downto 0);
signal temp : std_logic_vector (7 downto 0);
signal Rcon : std_logic_vector (31 downto 0);

begin
	w0<=Key_IN (31 downto 0);
	w1<=Key_IN (63 downto 32);
	w2<=Key_IN (95 downto 64);
	w3<=Key_IN (127 downto 96);
	temp<=Key_IN (103 downto 96) &  Key_IN (127 downto 104);
 process
	
 begin
	if (reset='1') then Key_out<=x"00000000000000000000000000000000";
							  Rcon<=x"00000000";
	elsif (clock'event and clock='0') then
			if (Rcon_index="0001") then Rcon<=x"00000001";
			elsif	(Rcon_index="0010") then Rcon<=x"00000002";
			elsif	(Rcon_index="0011") then Rcon<=x"00000004";
			elsif	(Rcon_index="0100") then Rcon<=x"00000008";
			elsif	(Rcon_index="0101") then Rcon<=x"00000010";
			elsif	(Rcon_index="0110") then Rcon<=x"00000020";
			elsif	(Rcon_index="0111") then Rcon<=x"00000040";
			elsif	(Rcon_index="1000") then Rcon<=x"00000080";
			elsif	(Rcon_index="1001") then Rcon<=x"0000001B";
			elsif	(Rcon_index="1010") then Rcon<=x"00000036";
			end if;
		W4<= W0 xor Rcon xor temp;
		W5<= W1 xor W4;
		W6<= W2 xor W5;
		W7<= W3 xor W6;
	end if;
 end process;

 Key_out<=W7&W6&W5&W4;
 
end architecture;