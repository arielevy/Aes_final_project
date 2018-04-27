library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_for_ENC is
Port(
 Data_in0 : in  STD_LOGIC_VECTOR (127 downto 0);
 Data_in1 : in  STD_LOGIC_VECTOR (127 downto 0);
 clock : in STD_LOGIC;
 sel : in STD_LOGIC ;
 Data_out : out  STD_LOGIC_VECTOR (127 downto 0)
);
end Mux_for_ENC;

architecture beavh of Mux_for_ENC is


begin
	process (clock,sel)
	begin
	if (clock'event and clock='0') then
		case sel is
			when '0' => Data_out<=Data_in0;
			when '1' => Data_out<=Data_in1;
			when others => Data_out<=Data_in0;
			end case;
	end if;
	end process;				
end; 