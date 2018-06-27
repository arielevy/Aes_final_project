library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_for_Controller is
Port(
 Data_in0 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in1 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in2 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in3 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in4 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in5 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in6 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in7 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in8 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in9 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in10 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in11 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in12 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in13 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in14 : in  STD_LOGIC_VECTOR (7 downto 0);
 Data_in15 : in  STD_LOGIC_VECTOR (7 downto 0);
 clock : in STD_LOGIC;
 sel : in STD_LOGIC_VECTOR (3 downto 0);
 Data_out : out  STD_LOGIC_VECTOR (7 downto 0)
);
end Mux_for_Controller;

architecture beavh of Mux_for_Controller is


begin
	process (clock,sel)
	begin
	if (clock'event and clock='0') then
		case sel is
			when "0000" => Data_out<=Data_in0;
			when "0001" => Data_out<=Data_in1;
			when "0010" => Data_out<=Data_in2;
			when "0011" => Data_out<=Data_in3;
			when "0100" => Data_out<=Data_in4;
			when "0101" => Data_out<=Data_in5;
			when "0110" => Data_out<=Data_in6;
			when "0111" => Data_out<=Data_in7;
			when "1000" => Data_out<=Data_in8;
			when "1001" => Data_out<=Data_in9;
			when "1010" => Data_out<=Data_in10;
			when "1011" => Data_out<=Data_in11;
			when "1100" => Data_out<=Data_in12;
			when "1101" => Data_out<=Data_in13;
			when "1110" => Data_out<=Data_in14;
			when "1111" => Data_out<=Data_in15;
			when others => Data_out<=Data_in0;
			end case;
	end if;
	end process;				
end; 