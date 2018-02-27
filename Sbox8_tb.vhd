library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use STD.ENV.ALL;

entity Sbox8_tb is
end Sbox8_tb;

architecture Behav of Sbox8_tb is

component SBox8 is
port(
Data_IN :in std_logic_vector (7 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Data_OUT : out std_logic_vector (7 downto 0) --Data out
);
end component;

signal Data_IN,Data_OUT:STD_LOGIC_VECTOR(7 downto 0);
signal Clock,reset:std_logic;
constant clk:time :=10ns;
begin
test : Sbox8 port map(Data_IN=>Data_IN,Clock=>clock,reset=>reset,Data_OUT=>Data_OUT);

	process
	begin
	wait for 2*clk;
	Data_IN <= "01110111";
	wait for 2*clk;
--	stop(0);
	end process;

end architecture;