library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Key_generator is
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
end Key_generator;

architecture Behav of Key_generator is

signal Round0_o : std_logic_vector (127 downto 0);
signal Round1_o : std_logic_vector (127 downto 0); 
signal Round2_o : std_logic_vector (127 downto 0);
signal Round3_o : std_logic_vector (127 downto 0);
signal Round4_o : std_logic_vector (127 downto 0); 
signal Round5_o : std_logic_vector (127 downto 0); 
signal Round6_o : std_logic_vector (127 downto 0);
signal Round7_o : std_logic_vector (127 downto 0); 
signal Round8_o : std_logic_vector (127 downto 0); 
signal Round9_o : std_logic_vector (127 downto 0); 
signal Round10_o : std_logic_vector (127 downto 0);

signal Round1_in : std_logic_vector (127 downto 0); 
signal Round2_in : std_logic_vector (127 downto 0);
signal Round3_in : std_logic_vector (127 downto 0);
signal Round4_in : std_logic_vector (127 downto 0); 
signal Round5_in : std_logic_vector (127 downto 0); 
signal Round6_in : std_logic_vector (127 downto 0);
signal Round7_in : std_logic_vector (127 downto 0); 
signal Round8_in : std_logic_vector (127 downto 0); 
signal Round9_in : std_logic_vector (127 downto 0); 
signal Round10_in : std_logic_vector (127 downto 0);

signal wire_enable0 : std_logic:='1';
signal wire_enable1 : std_logic:='0';
signal wire_enable2 : std_logic:='0';
signal wire_enable3 : std_logic:='0';
signal wire_enable4 : std_logic:='0';
signal wire_enable5 : std_logic:='0';
signal wire_enable6 : std_logic:='0';
signal wire_enable7 : std_logic:='0';
signal wire_enable8 : std_logic:='0';
signal wire_enable9 : std_logic:='0';
signal wire_enable10 : std_logic:='0';


signal wire_sel_mux : std_logic_vector (3 downto 0);
signal wire_sel_dmux : std_logic_vector (3 downto 0);

signal wire_in : std_logic_vector (127 downto 0);
signal wire_out : std_logic_vector (127 downto 0);

constant Reset_value : std_logic_vector (127 downto 0):= x"00000000000000000000000000000000" ;

component SBox8 is
port(
Data_IN :in std_logic_vector (7 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Data_OUT : out std_logic_vector (7 downto 0) --Data out
);
end component;

component subkey_generator is
port(
Key_IN :in std_logic_vector (127 downto 0); -- Key in
Clock : in std_logic; --Clock in
reset :in std_logic;
Rcon_index: in std_logic_vector (3 downto 0);
Key_out : out std_logic_vector (127 downto 0)
);
end component;

component Mux_for_AES is
Port(
 Data_in0 : in  STD_LOGIC_VECTOR (127 downto 0);
 Data_in1 : in  STD_LOGIC_VECTOR (127 downto 0);
 Data_in2 : in  STD_LOGIC_VECTOR (127 downto 0);
 Data_in3 : in  STD_LOGIC_VECTOR (127 downto 0);
 Data_in4 : in  STD_LOGIC_VECTOR (127 downto 0);
 Data_in5 : in  STD_LOGIC_VECTOR (127 downto 0);
 Data_in6 : in  STD_LOGIC_VECTOR (127 downto 0);
 Data_in7 : in  STD_LOGIC_VECTOR (127 downto 0);
 Data_in8 : in  STD_LOGIC_VECTOR (127 downto 0);
 Data_in9 : in  STD_LOGIC_VECTOR (127 downto 0);
 Data_in10 : in  STD_LOGIC_VECTOR (127 downto 0);
 clock : in STD_LOGIC;
 sel : in STD_LOGIC_VECTOR (3 downto 0);
 Data_out : out  STD_LOGIC_VECTOR (127 downto 0)
);
end component;

component DMux_for_AES is
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
end component;

component reg is
Generic (size: integer:=128);
port(input :in std_logic_vector(size-1 downto 0);
	  output:out std_logic_vector(size-1 downto 0);
	  clock: in std_logic;
	  reset: in std_logic;
	  enable:in std_logic
);
end component;


begin
	
	register0 : reg generic map (size=>128) port map (Key_IN,Round0_o,clock,reset,wire_enable0);
	register1 : reg generic map (size=>128) port map (Round1_in,Round1_o,clock,reset,wire_enable1);
	register2 : reg generic map (size=>128) port map (Round2_in,Round2_o,clock,reset,wire_enable2);
	register3 : reg generic map (size=>128) port map (Round3_in,Round3_o,clock,reset,wire_enable3);
	register4 : reg generic map (size=>128) port map (Round4_in,Round4_o,clock,reset,wire_enable4);
	register5 : reg generic map (size=>128) port map (Round5_in,Round5_o,clock,reset,wire_enable5);
	register6 : reg generic map (size=>128) port map (Round6_in,Round6_o,clock,reset,wire_enable6);
	register7 : reg generic map (size=>128) port map (Round7_in,Round7_o,clock,reset,wire_enable7);
	register8 : reg generic map (size=>128) port map (Round8_in,Round8_o,clock,reset,wire_enable8);
	register9 : reg generic map (size=>128) port map (Round9_in,Round9_o,clock,reset,wire_enable9);
	register10 : reg generic map (size=>128) port map (Round10_in,Round10_o,clock,reset,wire_enable10);
	
	
	test : subkey_generator port map (wire_in,clock,reset,wire_sel_dmux,wire_out);
	mux_in : mux_for_AES port map (Round0_o,Round1_o,Round2_o,Round3_o,Round4_o
								,Round5_o,Round6_o,Round7_o,Round8_o,Round9_o,Round10_o,clock,wire_sel_mux,wire_in);
	mux_out : DMux_for_AES port map (open,Round1_in,Round2_in,Round3_in,Round4_in,Round5_in
									,Round6_in,Round7_in,Round8_in,Round9_in,Round10_in,clock,wire_sel_dmux,wire_out);

process (clock,reset)
	variable I : integer range 0 to 70;
	begin

			if (reset = '1') then
			I:=0;
			wire_enable0<='1';
			enable_aes<='0';
			--Round 1
			elsif (clock'event and clock='0' and I<6 and start='1') then
			I:=i+1;
			wire_enable0<='0';
			wire_sel_mux<="0000";
			wire_sel_dmux<="0001";
			elsif (clock'event and clock='0' and I=6 and start='1') then
			I:=i+1;
			wire_enable1<='1';
			--Round 2
			elsif (clock'event and clock='0' and I<13 and start='1') then
			I:=i+1;
			wire_enable1<='0';
			wire_sel_mux<="0001";
			wire_sel_dmux<="0010";
			elsif (clock'event and clock='0' and I=13 and start='1') then
			I:=i+1;
			wire_enable2<='1';
			--Round 3
			elsif (clock'event and clock='0' and I<20 and start='1') then
			I:=i+1;
			wire_enable2<='0';
			wire_sel_mux<="0010";
			wire_sel_dmux<="0011";
			elsif (clock'event and clock='0' and I=20 and start='1') then
			I:=i+1;
			wire_enable3<='1';
			--Round 4
			elsif (clock'event and clock='0' and I<27 and start='1') then
			I:=i+1;
			wire_enable3<='0';
			wire_sel_mux<="0011";
			wire_sel_dmux<="0100";
			elsif (clock'event and clock='0' and I=27 and start='1') then
			I:=i+1;
			wire_enable4<='1';
			--Round 5
			elsif (clock'event and clock='0' and I<34 and start='1') then
			I:=i+1;
			wire_enable4<='0';
			wire_sel_mux<="0100";
			wire_sel_dmux<="0101";
			elsif (clock'event and clock='0' and I=34 and start='1') then
			I:=i+1;
			wire_enable5<='1';
			--Round 6
			elsif (clock'event and clock='0' and I<41 and start='1') then
			I:=i+1;
			wire_enable5<='0';
			wire_sel_mux<="0101";
			wire_sel_dmux<="0110";
			elsif (clock'event and clock='0' and I=41 and start='1') then
			I:=i+1;
			wire_enable6<='1';
			--Round 7
			elsif (clock'event and clock='0' and I<48 and start='1') then
			I:=i+1;
			wire_enable6<='0';
			wire_sel_mux<="0110";
			wire_sel_dmux<="0111";
			elsif (clock'event and clock='0' and I=48 and start='1') then
			I:=i+1;
			wire_enable7<='1';
			--Round 8
			elsif (clock'event and clock='0' and I<55 and start='1') then
			I:=i+1;
			wire_enable7<='0';
			wire_sel_mux<="0111";
			wire_sel_dmux<="1000";
			elsif (clock'event and clock='0' and I=55 and start='1') then
			I:=i+1;
			wire_enable8<='1';
			--Round 9
			elsif (clock'event and clock='0' and I<62 and start='1') then
			I:=i+1;
			wire_enable8<='0';
			wire_sel_mux<="1000";
			wire_sel_dmux<="1001";
			elsif (clock'event and clock='0' and I=62 and start='1') then
			I:=i+1;
			wire_enable9<='1';
			--Round 10
			elsif (clock'event and clock='0' and I<69 and start='1') then
			I:=i+1;
			wire_enable9<='0';
			wire_sel_mux<="1001";
			wire_sel_dmux<="1010";
			elsif (clock'event and clock='0' and I=69 and start='1') then
			I:=i+1;
			wire_enable10<='1';
			elsif (clock'event and clock='0' and I=70 and start='1') then
			wire_enable10<='0';
			enable_aes<='1';
			end if;
		
end process;

	
	Data_out1 <=Round0_o when Key_req1="0000" else
					Round1_o when Key_req1="0001" else
					Round2_o when Key_req1="0010" else
					Round3_o when Key_req1="0011" else
					Round4_o when Key_req1="0100" else
					Round5_o when Key_req1="0101" else
					Round6_o when Key_req1="0110" else
					Round7_o when Key_req1="0111" else
					Round8_o when Key_req1="1000" else
					Round9_o when Key_req1="1001" else
					Round10_o;

end architecture;