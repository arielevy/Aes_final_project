library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use STD.ENV.ALL;

entity AES_tb is
end AES_tb;

architecture Behav of AES_tb is

component AES is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
Behavior : in std_logic; -- if Behavior=0 act as Encryptor. if Behavior=1 act as Decryptor
reset : in std_logic;
enable_aes: in std_LOGIC;
Round : out std_logic_vector(3 downto 0); -- The round key that AES is need
Key : in std_logic_vector (127 downto 0); -- Key in
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end component;

component Key_generator is
port(
Key_IN :in std_logic_vector (127 downto 0); -- Key in
Clock : in std_logic; --Clock in
reset :in std_logic;
start :in std_logic;
enable_aes: out std_LOGIC;
Key_req1 : in std_logic_vector(3 downto 0); -- The round key that first moudle of AES is need
Key_req2 : in std_logic_vector(3 downto 0); -- The round key that second module of AES is need
Data_OUT1 : out std_logic_vector (127 downto 0); --Data out for the first moudle of AES
Data_OUT2 : out std_logic_vector (127 downto 0) --Data out for the second moudle of AES
);
end component;

signal Data_IN,Data_OUT:STD_LOGIC_VECTOR(127 downto 0);
signal Behavior:std_LOGIC;
signal enable_aes_t:std_logic;
signal Round_t:std_logic_vector(3 downto 0);

signal Key_IN:STD_LOGIC_VECTOR(127 downto 0);
signal Data_OUT1,Data_OUT2:STD_LOGIC_VECTOR(127 downto 0);
signal Key_req1,Key_req2: std_logic_vector (3 downto 0);
signal start:std_logic:='0';


signal Clock:std_logic:='0';
signal reset:std_logic:='1';
constant clk:time :=10ns;

begin

Key1 : Key_generator port map(Key_IN=>Key_IN,Clock=>Clock,reset=>reset,start=>start,enable_aes=>enable_aes_t
							,Key_req1=>Round_t,Key_req2=>Key_req2,Data_OUT1=>Data_OUT1,Data_OUT2=>Data_OUT2);
Aes1 : AES port map(Data_IN=>Data_IN,Clock=>Clock,Behavior=>Behavior,reset=>reset,enable_aes=>enable_aes_t,Round=>Round_t
							,Key=>Data_OUT1,Data_OUT=>Data_OUT);
							
	process
	begin
	Clock<=not Clock;
	wait for 20 ns;
	end process;
	
	process
	begin
	wait for clk;
	reset<='0';
	wait for clk;
--	Key_IN<=x"00000000000000000000000000000000";
--	Data_IN<=x"00000000000000000000000000000000"; -- data_OUT = 2E2B34CA59FA4C883B2C8AEFD44BE966
--	Key_IN<=x"00000000000000000000000000000000";
--	Data_IN<=x"2E2B34CA59FA4C883B2C8AEFD44BE966"; -- data_OUT = 00000000000000000000000000000000
--	Key_IN<=x"3c4fcf098815f7aba6d2ae2816157e2b";
--	Data_IN<=x"340737e0a29831318d305a88a8f64332"; -- data_OUT = 320B6A19978511DCFB09DC021D842539
--	Key_IN<=x"3c4fcf098815f7aba6d2ae2816157e2b";
--	Data_IN<=x"320B6A19978511DCFB09DC021D842539"; -- data_OUT = 340737e0a29831318d305a88a8f64332
	start<='1';
	Behavior<='1';
	wait for 300*clk;
--	stop(0);
	end process;

end architecture;