library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Encryptor is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Key : in std_logic_vector (127 downto 0); -- Key in
Round : out std_logic_vector(3 downto 0); -- The round key that Encryptor is need
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end Encryptor;

architecture Behav of Encryptor is

component Encryptor_4Rounds is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Key : in std_logic_vector (127 downto 0); -- Key in
last_round : in std_logic;
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end component Encryptor_4Rounds;


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

signal Awire : std_logic_vector (127 downto 0); 
signal Bwire : std_logic_vector (127 downto 0); 
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
signal last_round_wire : std_logic;
begin

Enc4 : Encryptor_4Rounds port map (Bwire,clock,reset,Gwire,last_round_wire,Cwire);
Mux  : Mux_for_ENC port map (Ewire,Awire,clock,sel_mux,Bwire);
Dmux : DMux_for_ENC port map (Awire,Data_OUT,clock,sel_dmux,enb_dmux,Cwire); --Dwire
DmuxK: DMux_for_ENC_KEY port map (Fwire,Gwire,Jwire,clock,sel_dmux_key,key);

	process (clock,reset)
	variable I : integer range 0 to 110;
	constant Delay_time : integer := 19;

	begin
		if (reset='1') then
		I:=0;
		Round <= "0000";
		sel_mux<='0';
		sel_dmux<='0';
		enb_dmux<='0';
		sel_dmux_key<="00";
		last_round_wire<='0';
		-- Round 0
		elsif (clock'event and clock='0' and I<(Delay_time+4)) then
		Ewire <= Data_IN XOR Fwire;
		Round <= "0000";
		sel_mux<='0';
		sel_dmux<='0';
		enb_dmux<='0';
		sel_dmux_key<="00";
		I:=i+1;
		
		--Round 1
		elsif (clock'event and clock='0' and I<(Delay_time+6)) then
		Round <= "0001";
		sel_dmux_key<="01";
		sel_mux<='0';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+7)) then
		I:=i+1;
		sel_mux<='1';
		sel_dmux<='0';
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+10)) then
		enb_dmux<='0';
		I:=i+1;
		
		-- Round 2
		elsif (clock'event and clock='0' and I<(Delay_time+11)) then
		Round <= "0010";
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+13)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+15)) then
		enb_dmux<='0';
		I:=i+1;
		
		-- Round 3
		elsif (clock'event and clock='0' and I<(Delay_time+16)) then
		Round <= "0011";
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+18)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+20)) then
		enb_dmux<='0';
		I:=i+1;
		
		-- Round 4
		elsif (clock'event and clock='0' and I<(Delay_time+21)) then
		Round <= "0100";
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+23)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+25)) then
		enb_dmux<='0';
		I:=i+1;
		
		-- Round 5
		elsif (clock'event and clock='0' and I<(Delay_time+26)) then
		Round <= "0101";
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+28)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+30)) then
		enb_dmux<='0';
		I:=i+1;
		
		-- Round 6
		elsif (clock'event and clock='0' and I<(Delay_time+31)) then
		Round <= "0110";
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+33)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+35)) then
		enb_dmux<='0';
		I:=i+1;
		
		-- Round 7
		elsif (clock'event and clock='0' and I<(Delay_time+36)) then
		Round <= "0111";
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+38)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+40)) then
		enb_dmux<='0';
		I:=i+1;
		
		-- Round 8
		elsif (clock'event and clock='0' and I<(Delay_time+41)) then
		Round <= "1000";
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+43)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+45)) then
		enb_dmux<='0';
		I:=i+1;
		
		-- Round 9
		elsif (clock'event and clock='0' and I<(Delay_time+46)) then
		Round <= "1001";
		sel_dmux<='0';--'1'
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+48)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+50)) then
		enb_dmux<='0';
		I:=i+1;
		
		-- Round 10
		elsif (clock'event and clock='0' and I<(Delay_time+51)) then
		Round <= "1010";
		sel_dmux<='1';
		--sel_dmux_key<="10";
		last_round_wire<='1';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+53)) then
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+55)) then
		enb_dmux<='0';
		I:=i+1;
		end if;
	
	
	end process;

end architecture;