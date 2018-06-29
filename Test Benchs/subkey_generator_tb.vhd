library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use STD.ENV.ALL;

entity subkey_generator_tb is
end subkey_generator_tb;

architecture Behav of subkey_generator_tb is

component subkey_generator is
port(
Key_IN :in std_logic_vector (127 downto 0); -- Key in
Clock : in std_logic; --Clock in
reset :in std_logic;
Rcon_index: in std_logic_vector (3 downto 0);
Key_out : out std_logic_vector (127 downto 0)
);
end component;

signal Key_IN,Key_out:STD_LOGIC_VECTOR(127 downto 0);
signal Rcon_index: std_logic_vector (3 downto 0);
signal Clock:std_logic:='0';
signal reset:std_logic:='1';
constant clk:time :=10ns;

begin

test : subkey_generator port map(Key_IN=>Key_IN,Clock=>Clock,reset=>reset,Rcon_index=>Rcon_index,Key_out=>Key_out);
	
	process
	begin
	Clock<=not Clock;
	wait for 10 ns;
	end process;
	
	process
	begin
	reset<='0';
	wait for clk;
	Key_IN <= x"63636362636363626363636263636362";
	Rcon_index <= "0001";
--	stop(0);
	end process;

end architecture;