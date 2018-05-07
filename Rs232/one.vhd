library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity one is
port(
Key_in:in std_logic; --keys
clock:in std_logic;
Key_out:out std_logic
);
end one;

architecture behavor of one is

component clk_div
port(
clk_in: in std_logic; --clock from the board
clk_out:out std_logic
);
end component;

signal clk: std_logic;
signal serias : std_logic_vector (3 downto 0);

begin
bamba : clk_div port map (clock,clk);
 
process(clk)
begin
	if clk' event and clk='0' then
		 serias<= serias (3 downto 1) & Key_in;
	end if;
end process;

key_out <= '1' when  serias="0000" else
			  '0'  ;
end;



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clk_div is
port(
clk_in: in std_logic; --clock from the board
clk_out:out std_logic
);
end clk_div;

architecture arc of clk_div is 

signal DD: std_logic;

begin

process(clk_in)
variable  counter: integer:=0;
begin
	if clk_in' event and clk_in='0' then
		if counter = 5000000 then
			counter:=0;
			DD<= not DD;
		else counter:=counter+1;
		end if;
	end if;
end process;
clk_out<=DD;
end architecture;
