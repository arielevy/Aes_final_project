library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
 
entity reg is
Generic (size: integer:=128);
port(input :in std_logic_vector(size-1 downto 0);
	  output:out std_logic_vector(size-1 downto 0);
	  clock: in std_logic;
	  reset: in std_logic;
	  enable:in std_logic
);
end;

architecture Behavioral of reg is
begin

	process (clock,enable,reset)
	begin
	if (reset='1') then
	output<=x"00000000000000000000000000000000";
	elsif (clock'event and clock='0' and enable='1') then
	output<=input;
	end if;
	end process;

end;