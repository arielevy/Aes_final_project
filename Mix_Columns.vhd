library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Mix_Column is
port(
Data_IN :in std_logic_vector (31 downto 0); -- Data in
clock : in std_logic;
reset : in std_logic;
Data_OUT : out std_logic_vector (31 downto 0) --Data out
);
end Mix_Column;

architecture beavh of Mix_Column is

alias A0 : std_logic_vector (7 downto 0) is Data_IN (7 downto 0); -- alias for data in
alias A1 : std_logic_vector (7 downto 0) is Data_IN (15 downto 8);
alias A2 : std_logic_vector (7 downto 0) is Data_IN (23 downto 16);
alias A3 : std_logic_vector (7 downto 0) is Data_IN (31 downto 24);

signal B0 : std_logic_vector (7 downto 0); -- 
signal B1 : std_logic_vector (7 downto 0);
signal B2 : std_logic_vector (7 downto 0);
signal B3 : std_logic_vector (7 downto 0);

signal D0 : std_logic_vector (7 downto 0); -- 
signal D1 : std_logic_vector (7 downto 0);
signal D2 : std_logic_vector (7 downto 0);
signal D3 : std_logic_vector (7 downto 0);

signal E0 : std_logic_vector (7 downto 0); -- 
signal E1 : std_logic_vector (7 downto 0);
signal E2 : std_logic_vector (7 downto 0);
signal E3 : std_logic_vector (7 downto 0);

signal F0 : std_logic_vector (7 downto 0); -- 
signal F1 : std_logic_vector (7 downto 0);
signal F2 : std_logic_vector (7 downto 0);
signal F3 : std_logic_vector (7 downto 0);

alias C0 : std_logic_vector (7 downto 0) is Data_OUT (7 downto 0); -- alias for data out
alias C1 : std_logic_vector (7 downto 0) is Data_OUT (15 downto 8);
alias C2 : std_logic_vector (7 downto 0) is Data_OUT (23 downto 16);
alias C3 : std_logic_vector (7 downto 0) is Data_OUT (31 downto 24);

begin

process(clock,reset)
	begin
	
	if (reset ='1') then B0<=x"00";B1<=x"00";B2<=x"00";B3<=x"00";
								D0<=x"00";D1<=x"00";D2<=x"00";D3<=x"00";
								E0<=x"00";E1<=x"00";E2<=x"00";E3<=x"00";
								F0<=x"00";F1<=x"00";F2<=x"00";F3<=x"00";
		elsif(clock'event and clock ='0') then
		B0<= (A0(6 downto 0) & '0') XOR ("00011011" And (A0(7)& A0(7)&A0(7)&A0(7)&A0(7)&A0(7)&A0(7)&A0(7))) ; -- rotate_left if A0(7)=1
		B1<= (A1(6 downto 0) & '0') XOR ("00011011" And (A1(7)& A1(7)&A1(7)&A1(7)&A1(7)&A1(7)&A1(7)&A1(7))) XOR A1;
		B2<= A2;
		B3<= A3;
		
		D0<= A0;
		D1<= (A1(6 downto 0) & '0') XOR ("00011011" And (A1(7)& A1(7)&A1(7)&A1(7)&A1(7)&A1(7)&A1(7)&A1(7)));-- rotate_left if A1(7)=1
		D2<= (A2(6 downto 0) & '0') XOR ("00011011" And (A2(7)& A2(7)&A2(7)&A2(7)&A2(7)&A2(7)& A2(7)&A2(7))) XOR A2;
		D3<= A3;
		
		E0<= A0;
		E1<= A1;
		E2<= (A2(6 downto 0) & '0') XOR ("00011011" And (A2(7)& A2(7)&A2(7)&A2(7)&A2(7)&A2(7)& A2(7)&A2(7)));-- rotate_left if A2(7)=1
		E3<= (A3(6 downto 0) & '0') XOR ("00011011" And (A3(7)&A3(7)&A3(7)&A3(7)&A3(7)&A3(7)&A3(7)&A3(7))) XOR A3;
		
		F0<= (A0(6 downto 0) & '0') XOR ("00011011" And (A0(7)&A0(7)&A0(7)&A0(7)&A0(7)&A0(7)&A0(7)&A0(7))) XOR A0;
		F1<= A1;
		F2<= A2;
		F3<= (A3(6 downto 0) & '0') XOR ("00011011" And (A3(7)&A3(7)&A3(7)&A3(7)&A3(7)&A3(7)&A3(7)&A3(7)));-- rotate_left if A3(7)=1
		end if;
end process;
C0 <= B0 XOR B1 XOR B2 XOR B3;
C1 <= D0 XOR D1 XOR D2 XOR D3;
C2 <= E0 XOR E1 XOR E2 XOR E3;
C3 <= F0 XOR F1 XOR F2 XOR F3;
end architecture;