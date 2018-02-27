library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
--use STD.ENV.ALL;

entity Mix_Column_tb is
end Mix_Column_tb;

architecture Behav of Mix_Column_tb is

component Mix_Column is
port(
Data_IN :in std_logic_vector (31 downto 0); -- Data in
clock : in std_logic;
reset : in std_logic;
Data_OUT : out std_logic_vector (31 downto 0) --Data out
);
end component;

signal Data_IN,Data_OUT:STD_LOGIC_VECTOR(31 downto 0);
signal clock:std_logic:='0';
signal reset: std_logic;
constant clk:time :=10ns;

begin

test : Mix_Column port map(Data_IN=>Data_IN,clock=>clock,reset=>reset,Data_OUT=>Data_OUT);
	
	process
	begin
	clock<=not clock;
	wait for 10 ns;
	end process;
	
	process
	begin
	wait for 4*clk;
	Data_IN <= x"305dbfd4";
--	stop(0);
	end process;



end architecture;