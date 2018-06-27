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
 reset: in std_logic;
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
signal Ewire : std_logic_vector (127 downto 0); -- key wire
signal Fwire : std_logic_vector (127 downto 0); -- key wire  
signal Gwire : std_logic_vector (127 downto 0); -- key wire
--signal Jwire : std_logic_vector (127 downto 0); -- key wire

signal sel_mux : std_logic;
signal sel_dmux : std_logic;
signal enb_dmux : std_LOGIC;
signal sel_dmux_key : std_logic_vector( 1 downto 0);
signal first_round_wire : std_logic;

begin

Dnc4 : Decryptor_4Rounds port map (Awire,clock,reset,Fwire,first_round_wire,Bwire);
Mux  : Mux_for_ENC port map (Data_IN,Cwire,clock,sel_mux,Awire);
Dmux : DMux_for_ENC port map (Cwire,Dwire,clock,sel_dmux,enb_dmux,reset,Bwire); --Dwire
DmuxK: DMux_for_ENC_KEY port map (Ewire,Fwire,open,clock,sel_dmux_key,key);

process (clock,reset)
	variable I : integer range 0 to 255;
	constant Delay_time : integer := 80;

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
		elsif (clock'event and clock='0' and I<(Delay_time+3)) then --3
		Round <= "1010";
		sel_dmux_key<="01";
		first_round_wire<='1';
		sel_mux<='0';
		sel_dmux<='0';
		enb_dmux<='0';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+4)) then --4
		enb_dmux<='1';
		first_round_wire<='1';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+5)) then --5
		first_round_wire<='0';
		enb_dmux<='0';
		sel_mux<='1';
--				if ( Fwire = X"8e188f6fcf51e92311e2923ecb5befb4" ) then LedsO(0)<='1'; else LedsO(0)<='0'; end if;
--				if ( Bwire = X"cbec2929477c340e3566a551950efe7f" ) then LedsO(1)<='1'; else LedsO(1)<='0'; end if;
--				if ( Awire = X"2e2b34ca59fa4c883b2c8aefd44be966" ) then LedsO(2)<='1'; else LedsO(2)<='0'; end if;
		I:=i+1;
		
		--Round 9
		elsif (clock'event and clock='0' and I<(Delay_time+6)) then --6
		Round <= "1001";
		first_round_wire<='0';
		sel_dmux_key<="01";
		sel_mux<='1';
		sel_dmux<='0';
		enb_dmux<='0';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+8)) then --8
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+9)) then --9
		enb_dmux<='0';
--				if ( Fwire = X"4149664cdeb37b1ddab97d8ae2d8d4b1" ) then LedsO(0)<='1'; else LedsO(0)<='0'; end if;
--				if ( Bwire = X"95cb032e57c6c0aadb6321133c8ce723" ) then LedsO(1)<='1'; else LedsO(1)<='0'; end if;
--				if ( Awire = X"cbec2929477c340e3566a551950efe7f" ) then LedsO(2)<='1'; else LedsO(2)<='0'; end if;		
		I:=i+1;
		
		--Round 8
		elsif (clock'event and clock='0' and I<(Delay_time+10)) then --10
		Round <= "1000";
		first_round_wire<='0';
		enb_dmux<='0';
		sel_dmux_key<="01";
		sel_mux<='1';
		sel_dmux<='0';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+12)) then --12
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+13)) then --13
		enb_dmux<='0';
--				if ( Fwire = X"9ffa1d51040a06973861a93b3303f90e" ) then LedsO(0)<='1'; else LedsO(0)<='0'; end if;
--				if ( Bwire = X"5081e594810f926c4f2d251dc5e4aab7" ) then LedsO(1)<='1'; else LedsO(1)<='0'; end if;
--				if ( Awire = X"95cb032e57c6c0aadb6321133c8ce723" ) then LedsO(2)<='1'; else LedsO(2)<='0'; end if;		
		I:=i+1;
		
		--Round 7
		elsif (clock'event and clock='0' and I<(Delay_time+14)) then --14
		Round <= "0111";
		first_round_wire<='0';
		enb_dmux<='0';
		sel_dmux_key<="01";
		sel_mux<='1';
		sel_dmux<='0';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+16)) then --16
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+17)) then --17
		enb_dmux<='0';
--				if ( Fwire = X"9bf01bc63c6bafac0b62503587177521" ) then LedsO(0)<='1'; else LedsO(0)<='0'; end if;
--				if ( Bwire = X"10d7c54996012fe24528780797caf204" ) then LedsO(1)<='1'; else LedsO(1)<='0'; end if;
--				if ( Awire = X"5081e594810f926c4f2d251dc5e4aab7" ) then LedsO(2)<='1'; else LedsO(2)<='0'; end if;		
		I:=i+1;
		
		--Round 6
		elsif (clock'event and clock='0' and I<(Delay_time+18)) then --18
		Round <= "0110";
		first_round_wire<='0';
		enb_dmux<='0';
		sel_dmux_key<="01";
		sel_mux<='1';
		sel_dmux<='0';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+20)) then --20
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+21)) then --21
		enb_dmux<='0';
--				if ( Fwire = X"A79BB46A3709FF998C752514854B61EC" ) then LedsO(0)<='1'; else LedsO(0)<='0'; end if;
--				if ( Bwire = X"23de79793dbb057e3396b8556c4f6fd4" ) then LedsO(1)<='1'; else LedsO(1)<='0'; end if;
--				if ( Awire = X"10d7c54996012fe24528780797caf204" ) then LedsO(2)<='1'; else LedsO(2)<='0'; end if;	
		I:=i+1;
	
		--Round 5
		elsif (clock'event and clock='0' and I<(Delay_time+22)) then --22
		Round <= "0101";
		first_round_wire<='0';
		enb_dmux<='0';
		sel_dmux_key<="01";
		sel_mux<='1';
		sel_dmux<='0';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+24)) then --24
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+25)) then --25
		enb_dmux<='0';
--				if ( Fwire = X"90924bf3bb7cda8d093e44f8882b2e7f" ) then LedsO(0)<='1'; else LedsO(0)<='0'; end if;
--				if ( Bwire = X"5f6a9a75c0afa05049b55a37fecdd2ab" ) then LedsO(1)<='1'; else LedsO(1)<='0'; end if;
--				if ( Awire = X"23de79793dbb057e3396b8556c4f6fd4" ) then LedsO(2)<='1'; else LedsO(2)<='0'; end if;
		I:=i+1;
		
		--Round 4
		elsif (clock'event and clock='0' and I<(Delay_time+26)) then --26
		Round <= "0100";
		first_round_wire<='0';
		enb_dmux<='0';
		sel_dmux_key<="01";
		sel_mux<='1';
		sel_dmux<='0';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+28)) then --28
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+29)) then --29
		enb_dmux<='0';
--				if ( Fwire = X"2bee917eb2429e7581156a877bda06ee" ) then LedsO(0)<='1'; else LedsO(0)<='0'; end if;
--				if ( Bwire = X"46e59008a7904e4a2586f36ac4f32d28" ) then LedsO(1)<='1'; else LedsO(1)<='0'; end if;
--				if ( Awire = X"5f6a9a75c0afa05049b55a37fecdd2ab" ) then LedsO(2)<='1'; else LedsO(2)<='0'; end if;
		I:=i+1;
		
		--Round 3
		elsif (clock'event and clock='0' and I<(Delay_time+30)) then --30
		Round <= "0011";
		first_round_wire<='0';
		enb_dmux<='0';
		sel_dmux_key<="01";
		sel_mux<='1';
		sel_dmux<='0';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+32)) then --32
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+33)) then --33
		enb_dmux<='0';
--				if ( Fwire = X"99ac0f0b3357f4f2facf6c6950349790" ) then LedsO(0)<='1'; else LedsO(0)<='0'; end if;
--				if ( Bwire = X"e88787a48be4e4c6e88787a48be4e4c6" ) then LedsO(1)<='1'; else LedsO(1)<='0'; end if;
--				if ( Awire = X"46e59008a7904e4a2586f36ac4f32d28" ) then LedsO(2)<='1'; else LedsO(2)<='0'; end if;
		I:=i+1;
		
		--Round 2
		elsif (clock'event and clock='0' and I<(Delay_time+34)) then --34
		Round <= "0010";
		first_round_wire<='0';
		enb_dmux<='0';
		sel_dmux_key<="01";
		sel_mux<='1';
		sel_dmux<='0';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+36)) then --36
		I:=i+1;
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+37)) then --37
		enb_dmux<='0';
--				if ( Fwire = X"AAFBFBF9C998989BAAFBFBF9C998989B" ) then LedsO(0)<='1'; else LedsO(0)<='0'; end if;
--				if ( Bwire = X"00000001000000010000000100000001" ) then LedsO(1)<='1'; else LedsO(1)<='0'; end if;
--				if ( Awire = X"e88787a48be4e4c6e88787a48be4e4c6" ) then LedsO(2)<='1'; else LedsO(2)<='0'; end if;
		I:=i+1;
		
		--Round 1
		elsif (clock'event and clock='0' and I<(Delay_time+38)) then --38
		Round <= "0001";
		first_round_wire<='0';
		enb_dmux<='0';
		sel_dmux_key<="01";
		sel_mux<='1';
		sel_dmux<='0';
		I:=i+1;
		elsif (clock'event and clock='0' and I<(Delay_time+40)) then --40
		I:=i+1;
		sel_dmux<='1';
		enb_dmux<='1';
		elsif (clock'event and clock='0' and I<(Delay_time+41)) then --41
		enb_dmux<='0';
--				if ( Fwire = X"63636362636363626363636263636362" ) then LedsO(0)<='1'; else LedsO(0)<='0'; end if;
--				if ( Bwire = X"00000000000000000000000000000000" ) then LedsO(1)<='1'; else LedsO(1)<='0'; end if;
--				if ( Awire = X"00000001000000010000000100000001" ) then LedsO(2)<='1'; else LedsO(2)<='0'; end if;
		I:=i+1;

		--Round 0
		elsif (clock'event and clock='0' and I<(Delay_time+42)) then
		Round <= "0000";
		sel_dmux_key<="00";
--		I:=i+

	end if;
	end process;
	
Data_OUT<= Ewire xor Dwire;
end architecture;