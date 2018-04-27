library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DMux_for_AES is
Port(
 Data_out0 : out  STD_LOGIC_VECTOR (127 downto 0);
 Data_out1 : out  STD_LOGIC_VECTOR (127 downto 0);
 Data_out2 : out  STD_LOGIC_VECTOR (127 downto 0);
 Data_out3 : out  STD_LOGIC_VECTOR (127 downto 0);
 Data_out4 : out  STD_LOGIC_VECTOR (127 downto 0);
 Data_out5 : out  STD_LOGIC_VECTOR (127 downto 0);
 Data_out6 : out  STD_LOGIC_VECTOR (127 downto 0);
 Data_out7 : out  STD_LOGIC_VECTOR (127 downto 0);
 Data_out8 : out  STD_LOGIC_VECTOR (127 downto 0);
 Data_out9 : out  STD_LOGIC_VECTOR (127 downto 0);
 Data_out10 : out  STD_LOGIC_VECTOR (127 downto 0);
 clock : in STD_LOGIC;
 sel : in STD_LOGIC_VECTOR (3 downto 0);
 Data_in : in  STD_LOGIC_VECTOR (127 downto 0)
);
end DMux_for_AES;

architecture beavh of DMux_for_AES is


begin
	process (sel,clock)
	begin
	if (clock'event and clock='0') then
		case sel is
			when "0000" => Data_out0<=Data_in;
			when "0001" => Data_out1<=Data_in;
			when "0010" => Data_out2<=Data_in;
			when "0011" => Data_out3<=Data_in;
			when "0100" => Data_out4<=Data_in;
			when "0101" => Data_out5<=Data_in;
			when "0110" => Data_out6<=Data_in;
			when "0111" => Data_out7<=Data_in;
			when "1000" => Data_out8<=Data_in;
			when "1001" => Data_out9<=Data_in;
			when "1010" => Data_out10<=Data_in;
			when others => Data_out0<=Data_in;
			end case;
	end if;		
	end process;		
end; 