library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Inv_SBox128 is
port(
Data_IN :in std_logic_vector (127 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Data_OUT : out std_logic_vector (127 downto 0) --Data out
);
end Inv_SBox128;

architecture Behav of Inv_SBox128 is
component Inv_SBox8 is
port(
Data_IN :in std_logic_vector (7 downto 0); -- Data in
Clock : in std_logic; --Clock in
reset : in std_logic;
Data_OUT : out std_logic_vector (7 downto 0) --Data out
);
end component;

begin
S01 : Inv_SBox8 port map(Data_IN(7 downto 0),Clock,reset,Data_OUT(7 downto 0));
S02 : Inv_SBox8 port map(Data_IN(15 downto 8),Clock,reset,Data_OUT(15 downto 8));
S03 : Inv_SBox8 port map(Data_IN(23 downto 16),Clock,reset,Data_OUT(23 downto 16));
S04 : Inv_SBox8 port map(Data_IN(31 downto 24),Clock,reset,Data_OUT(31 downto 24));
S05 : Inv_SBox8 port map(Data_IN(39 downto 32),Clock,reset,Data_OUT(39 downto 32));
S06 : Inv_SBox8 port map(Data_IN(47 downto 40),Clock,reset,Data_OUT(47 downto 40));
S07 : Inv_SBox8 port map(Data_IN(55 downto 48),Clock,reset,Data_OUT(55 downto 48));
S08 : Inv_SBox8 port map(Data_IN(63 downto 56),Clock,reset,Data_OUT(63 downto 56));
S09 : Inv_SBox8 port map(Data_IN(71 downto 64),Clock,reset,Data_OUT(71 downto 64));
S10 : Inv_SBox8 port map(Data_IN(79 downto 72),Clock,reset,Data_OUT(79 downto 72));
S11 : Inv_SBox8 port map(Data_IN(87 downto 80),Clock,reset,Data_OUT(87 downto 80));
S12 : Inv_SBox8 port map(Data_IN(95 downto 88),Clock,reset,Data_OUT(95 downto 88));
S13 : Inv_SBox8 port map(Data_IN(103 downto 96),Clock,reset,Data_OUT(103 downto 96));
S14 : Inv_SBox8 port map(Data_IN(111 downto 104),Clock,reset,Data_OUT(111 downto 104));
S15 : Inv_SBox8 port map(Data_IN(119 downto 112),Clock,reset,Data_OUT(119 downto 112));
S16 : Inv_SBox8 port map(Data_IN(127 downto 120),Clock,reset,Data_OUT(127 downto 120));

end architecture;