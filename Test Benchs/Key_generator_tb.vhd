library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use STD.ENV.ALL;

entity Key_generator_tb is
end Key_generator_tb;

architecture Behav of Key_generator_tb is

component Key_generator is
port(
Key_IN :in std_logic_vector (127 downto 0); -- Key in
Clock : in std_logic; --Clock in
reset :in std_logic;
Key_req1 : in std_logic_vector(3 downto 0); -- The round key that first moudle of AES is need
Data_OUT1 : out std_logic_vector (127 downto 0) --Data out for the first moudle of AES
);
end component;

signal Key_IN:STD_LOGIC_VECTOR(127 downto 0);
signal Data_OUT1:STD_LOGIC_VECTOR(127 downto 0);
signal Key_req1: std_logic_vector (3 downto 0);
signal Clock:std_logic:='0';
signal reset:std_logic:='1';
constant clk:time :=5ns;

begin

test : Key_generator port map(Key_IN=>Key_IN,Clock=>Clock,reset=>reset
							,Key_req1=>Key_req1,Data_OUT1=>Data_OUT1);
	
	process
	begin
	Clock<=not Clock;
	wait for 5 ns;
	end process;
	
	process
	begin
	reset<='0';
	Key_IN <= x"00000000000000000000000000000000";
	wait for 122*clk;
	Key_req1 <= "0000";
	wait for 2*clk;
	Key_req1 <= "0000"; -- round 0
	wait for 2*clk;
	Key_req1 <= "0001"; --round 1
	wait for 2*clk;
	Key_req1 <= "0010"; -- round 2
	wait for 2*clk;
	Key_req1 <= "0011"; -- round 3
	wait for 2*clk;
	Key_req1 <= "0100"; -- round 4
	wait for 2*clk;
	Key_req1 <= "0101"; -- round 5
	wait for 2*clk;
	Key_req1 <= "0110"; -- round 6
	wait for 2*clk;
	Key_req1 <= "0111"; -- round 7
	wait for 2*clk;
	Key_req1 <= "1000"; -- round 8
	wait for 2*clk;
	Key_req1 <= "1001"; -- round 9
	wait for 2*clk;
	Key_req1 <= "1010"; -- round 10
	wait for 2*clk;
--	stop(0);
	end process;

end architecture;