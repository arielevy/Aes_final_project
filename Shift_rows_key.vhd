library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Shift_rows_key is
Port(
 Key_in : in  STD_LOGIC_VECTOR (127 downto 0);
 Key_out : out  STD_LOGIC_VECTOR (127 downto 0)
);
end Shift_rows_key;

architecture Behavioral of Shift_rows_key is

	signal W0 : std_logic_vector (31 downto 0);
	signal W1 : std_logic_vector (31 downto 0); 
	signal W2 : std_logic_vector (31 downto 0);
	signal W3 : std_logic_vector (31 downto 0);


begin

	w0<=Key_IN (31 downto 0);
	w1<=Key_IN (63 downto 32);
	w2<=Key_IN (95 downto 64);
	w3<=Key_IN (103 downto 96) & Key_IN (127 downto 104); -- shift "up" the last word.

	Key_out<=w3&w2&w1&w0;
	
end Behavioral;