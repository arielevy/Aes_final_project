library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Key_generator is
port(
Key_IN :in std_logic_vector (127 downto 0); -- Key in
Clock : in std_logic; --Clock in
reset :in std_logic;
Key_req1 : in std_logic_vector(3 downto 0); -- The round key that first moudle of AES is need
Key_req2 : in std_logic_vector(3 downto 0); -- The round key that second module of AES is need
Data_OUT1 : out std_logic_vector (127 downto 0); --Data out for the first moudle of AES
Data_OUT2 : out std_logic_vector (127 downto 0) --Data out for the second moudle of AES
);
end Key_generator;

architecture Behav of Key_generator is

signal Round0 : std_logic_vector (127 downto 0);
signal Round1 : std_logic_vector (127 downto 0); 
signal Round2 : std_logic_vector (127 downto 0);
signal Round3 : std_logic_vector (127 downto 0);
signal Round4 : std_logic_vector (127 downto 0); 
signal Round5 : std_logic_vector (127 downto 0); 
signal Round6 : std_logic_vector (127 downto 0);
signal Round7 : std_logic_vector (127 downto 0); 
signal Round8 : std_logic_vector (127 downto 0); 
signal Round9 : std_logic_vector (127 downto 0); 
signal Round10 : std_logic_vector (127 downto 0);

constant Reset_value : std_logic_vector (127 downto 0):= x"00000000000000000000000000000000" ;

component SBox8 is
port(
Data_IN :in std_logic_vector (7 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Data_OUT : out std_logic_vector (7 downto 0) --Data out
);
end component;

begin

process (clock,reset)
	begin
			if (reset = '1') then
			Round0<=Reset_value;Round1<=Reset_value;Round2<=Reset_value;Round3<=Reset_value;Round4<=Reset_value;
			Round5<=Reset_value;Round6<=Reset_value;Round7<=Reset_value;Round8<=Reset_value;Round9<=Reset_value;
			Round10<=Reset_value;
			
			elsif (clock'event and clock='0') then
			Round0<=Key_IN;
			
			
			
			end if;
			
end process;


process(Key_req1)
	
	begin
	if (clock'event and clock='0') then
		if (Key_req1="000") then Data_OUT1<=Round0;
		end if;
	end if;	
		
end process;

end architecture;