library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Decryptor is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Key : in std_logic_vector (127 downto 0); -- Key in
Round : out std_logic_vector(3 downto 0); -- The round key that Decryptor is need
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end Decryptor;

architecture Behav of Decryptor is

component Decryptor_4Rounds is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Key : in std_logic_vector (127 downto 0); -- Key in
first_round : in std_logic;
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end component Decryptor_4Rounds;


component Mux_for_ENC is
Port(
 Data_in0 : in  STD_LOGIC_VECTOR (127 downto 0);
 Data_in1 : in  STD_LOGIC_VECTOR (127 downto 0);
 clock : in STD_LOGIC;
 sel : in STD_LOGIC ;
 Data_out : out  STD_LOGIC_VECTOR (127 downto 0)
);
end component;

component DMux_for_ENC is
Port(
 Data_out0 : out  STD_LOGIC_VECTOR (127 downto 0);
 Data_out1 : out  STD_LOGIC_VECTOR (127 downto 0);
 clock : in STD_LOGIC;
 sel : in STD_LOGIC;
 enable : std_LOGIC;
 Data_in : in  STD_LOGIC_VECTOR (127 downto 0)
);
end component;

component DMux_for_ENC_KEY is
Port(
 Data_out0 : out  STD_LOGIC_VECTOR (127 downto 0);
 Data_out1 : out  STD_LOGIC_VECTOR (127 downto 0);
 Data_out2 : out  STD_LOGIC_VECTOR (127 downto 0);
 clock : in STD_LOGIC;
 sel : in STD_LOGIC_VECTOR (1 downto 0);
 Data_in : in  STD_LOGIC_VECTOR (127 downto 0)
);
end component;

signal Awire : std_logic_vector (127 downto 0); -- out from mux
signal Bwire : std_logic_vector (127 downto 0); -- out from 4round decryptor
signal Cwire : std_logic_vector (127 downto 0); 
signal Dwire : std_logic_vector (127 downto 0);
signal Ewire : std_logic_vector (127 downto 0); 
signal Fwire : std_logic_vector (127 downto 0); -- key wire  
signal Gwire : std_logic_vector (127 downto 0); -- key wire
signal Jwire : std_logic_vector (127 downto 0); -- key wire

signal sel_mux : std_logic;
signal sel_dmux : std_logic;
signal enb_dmux : std_LOGIC;
signal sel_dmux_key : std_logic_vector( 1 downto 0);
signal first_round_wire : std_logic;

begin

Dnc4 : Decryptor_4Rounds port map (Awire,clock,reset,Fwire,first_round_wire,Bwire);
Mux  : Mux_for_ENC port map (Data_IN,Cwire,clock,sel_mux,Awire);
Dmux : DMux_for_ENC port map (Cwire,Dwire,clock,sel_dmux,enb_dmux,Bwire); --Dwire
DmuxK: DMux_for_ENC_KEY port map (Ewire,Fwire,Jwire,clock,sel_dmux_key,key);

	process (clock,reset)
	variable I : integer range 0 to 196;
	constant Delay_time : integer := 80;--19

	begin
		if (reset='1') then
		I:=0;
		Round <= "1010";
		sel_mux<='0';
		sel_dmux<='0';
		enb_dmux<='0';
		sel_dmux_key<="01";
		first_round_wire<='1';
		
		-- Round 10
		elsif (clock'event and clock='0' and I<(Delay_time+3)) then
		Round <= "1010";
		sel_mux<='0';
		sel_dmux<='0';
		enb_dmux<='0';
		sel_dmux_key<="01";
		I:=i+1;
		first_round_wire<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+4)) then
		enb_dmux<='1';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+5)) then
		enb_dmux<='0';
		I:=i+1;
		
		--Round 9
		elsif (clock'event and clock='0' and I<(Delay_time+8)) then
		Round <= "1001";
		first_round_wire<='0';
		sel_mux<='1';
		sel_dmux<='0';
		enb_dmux<='0';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+9)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+10)) then
		enb_dmux<='0';
		I:=i+1;
		
		--Round 8
		elsif (clock'event and clock='0' and I<(Delay_time+13)) then
		Round <= "1000";
		enb_dmux<='0';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+14)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+15)) then
		enb_dmux<='0';
		I:=i+1;
		
		--Round 7
		elsif (clock'event and clock='0' and I<(Delay_time+18)) then
		Round <= "0111";
		enb_dmux<='0';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+19)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+20)) then
		enb_dmux<='0';
		I:=i+1;
		
		--Round 6
		elsif (clock'event and clock='0' and I<(Delay_time+23)) then
		Round <= "0110";
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+24)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+25)) then
		enb_dmux<='0';
		I:=i+1;
	
		--Round 5
		elsif (clock'event and clock='0' and I<(Delay_time+28)) then
		Round <= "0101";
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+29)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+30)) then
		enb_dmux<='0';
		I:=i+1;
		
		--Round 4
		elsif (clock'event and clock='0' and I<(Delay_time+33)) then
		Round <= "0100";
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+34)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+35)) then
		enb_dmux<='0';
		I:=i+1;
		
		--Round 3
		elsif (clock'event and clock='0' and I<(Delay_time+38)) then
		Round <= "0011";
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+39)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+40)) then
		enb_dmux<='0';
		I:=i+1;
		
		--Round 2
		elsif (clock'event and clock='0' and I<(Delay_time+43)) then
		Round <= "0010";
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+44)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+45)) then
		enb_dmux<='0';
		I:=i+1;
		
		--Round 1
		elsif (clock'event and clock='0' and I<(Delay_time+48)) then
		Round <= "0001";
		sel_dmux<='1';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+49)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+50)) then
		enb_dmux<='0';
		Round <= "0000";
		I:=i+1;
		
		--Round 0
		elsif (clock'event and clock='0' and I<(Delay_time+51)) then
		sel_dmux_key<="00";
		I:=i+1;
		end if;
	
	end process;
Data_OUT<= Ewire xor Dwire;
end architecture;