library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DMux_for_ENC is
Port(
 Data_out0 : out  STD_LOGIC_VECTOR (127 downto 0);
 Data_out1 : out  STD_LOGIC_VECTOR (127 downto 0);
 clock : in STD_LOGIC;
 sel : in STD_LOGIC;
 enable : std_LOGIC;
 Data_in : in  STD_LOGIC_VECTOR (127 downto 0)
);
end DMux_for_ENC;

architecture beavh of DMux_for_ENC is


begin
	process (sel,clock,enable)
	begin
	if (clock'event and clock='0' and enable='1') then
		case sel is
			when '0' => Data_out0<=Data_in;
			when '1' => Data_out1<=Data_in;
			when others => Data_out0<=Data_in;
			end case;
	end if;		
	end process;		
end; 