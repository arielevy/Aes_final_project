library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
--use STD.ENV.ALL;

entity Encryptor_4Rounds_tb is
end Encryptor_4Rounds_tb;

architecture Behav of Encryptor_4Rounds_tb is

component Encryptor_4Rounds is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Key : in std_logic_vector (127 downto 0); -- Key in
last_round : in std_logic;
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end component;

signal Data_IN,Data_OUT,Key:STD_LOGIC_VECTOR(127 downto 0);
signal clock:std_logic:='0';
signal reset:std_logic:='1';
signal last_round: std_logic:='1';
constant clk:time :=10ns;

begin

test : Encryptor_4Rounds port map(Data_IN=>Data_IN,clock=>clock,reset=>reset,Key=>Key,last_round=>last_round,Data_OUT=>Data_OUT);
	
	process
	begin
	clock<=not clock;
	wait for 10 ns;
	end process;
	
	process
	begin
	reset<='0';
	wait for 1*clk;
	Data_IN <= x"cbec2929477c340e3566a551950efe7f";
	Key <= x"8e188f6fcf51e92311e2923ecb5befb4";
--	stop(0);
	end process;

end architecture;