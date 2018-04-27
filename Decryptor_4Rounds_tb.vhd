library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
--use STD.ENV.ALL;

entity Decryptor_4Rounds_tb is
end Decryptor_4Rounds_tb;

architecture Behav of Decryptor_4Rounds_tb is

component Decryptor_4Rounds is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Key : in std_logic_vector (127 downto 0); -- Key in
first_round : in std_logic;
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end component;

signal Data_IN,Data_OUT,Key:STD_LOGIC_VECTOR(127 downto 0);
signal clock:std_logic:='0';
signal reset:std_logic:='1';
signal first_round:std_logic:='0';
constant clk:time :=10ns;

begin

test : Decryptor_4Rounds port map(Data_IN=>Data_IN,clock=>clock,reset=>reset,Key=>Key,first_round=>first_round,Data_OUT=>Data_OUT);
	
	process
	begin
	clock<=not clock;
	wait for 10 ns;
	end process;
	
	process
	begin
	wait for clk;
	reset<='0';
	first_round<='1';
	wait for 4*clk;
	Data_IN <= x"2E2B34CA59FA4C883B2C8AEFD44BE966";-- first round
	Key <= x"8e188f6fcf51e92311e2923ecb5befb4"; 
	wait for 4*clk;
	first_round<='0';
	wait for clk;
	Data_IN <= x"cbec2929477c340e3566a551950efe7f";-- first round
	Key <= x"4149664cdeb37b1ddab97d8ae2d8d4b1";
	wait for 4*clk;
--	stop(0);
	end process;

end architecture;