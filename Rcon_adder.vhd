library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Rcon_adder is
port(
Key_IN :in std_logic_vector (127 downto 0); -- Data in
W3_org : in std_logic_vector (31 downto 0);
Clock : in std_logic; --Clock in
reset : in std_logic;
Rcon_index: in std_logic_vector (3 downto 0);
Key_OUT : out std_logic_vector (127 downto 0) --Data out
);
end Rcon_adder;

architecture Behav of Rcon_adder is

--	type type_state is (one,two,tree,four,five); -- our state names
--	signal state : type_state ; -- signal
	
	signal W0 : std_logic_vector (31 downto 0);
	signal W1 : std_logic_vector (31 downto 0); 
	signal W2 : std_logic_vector (31 downto 0);
	signal temp : std_logic_vector (31 downto 0); -- this word arrive after shift and Sbox
	signal W4 : std_logic_vector (31 downto 0);
	signal W5 : std_logic_vector (31 downto 0); 
	signal W6 : std_logic_vector (31 downto 0);
	signal W7 : std_logic_vector (31 downto 0);
	signal Rcon : std_logic_vector (31 downto 0);

	
begin

	w0<= Key_IN (31 downto 0);
	w1<= Key_IN (63 downto 32);
	w2<= Key_IN (95 downto 64);
	temp<= Key_IN (127 downto 96);
	
	process (reset,clock)
	begin
		if (reset = '1') then
		elsif (clock'event and clock='0') then
					W4<= temp xor W0 xor Rcon;
					W5<= W1 xor W4; 
					W6<= W2 xor W5;
					W7<= W3_org xor W6;
		end if;
	end process;
	

		Rcon<= x"00000001" when Rcon_index="0001" else
				 x"00000002" when Rcon_index="0010" else
				 x"00000004" when Rcon_index="0011" else
				 x"00000008" when Rcon_index="0100" else
				 x"00000010" when Rcon_index="0101" else
				 x"00000020" when Rcon_index="0110" else
				 x"00000040" when Rcon_index="0111" else
				 x"00000080" when Rcon_index="1000" else
				 x"00000080" when Rcon_index="1000" else
				 x"0000001B" when Rcon_index="1001" else
				 x"00000036" when Rcon_index="1010" else
				 x"00000000" when Rcon_index="0000" else -- rest value
				 x"10000000";

		Key_OUT<=W7&W6&W5&W4;
		
end architecture;