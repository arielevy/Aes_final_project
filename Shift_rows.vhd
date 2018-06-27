library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Shift_rows is
Port(
 Data_in : in  STD_LOGIC_VECTOR (127 downto 0);
 Data_out : out  STD_LOGIC_VECTOR (127 downto 0)
);
end Shift_rows;

architecture Behavioral of Shift_rows is

signal p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15:std_logic_vector(7 downto 0);

begin
 p0<=Data_in(7 downto 0);	 
 p4<=Data_in(39 downto 32);		 
 p8<=Data_in(71 downto 64);		 
 p12<=Data_in(103 downto 96);	
	 
 p1<=Data_in(15 downto 8);
 p5<=Data_in(47 downto 40);
 p9<=Data_in(79 downto 72);	
 p13<=Data_in(111 downto 104);
	
 p2<=Data_in(23 downto 16);	
 p6<=Data_in(55 downto 48);	
 p10<=Data_in(87 downto 80);	
 p14<=Data_in(119 downto 112);	

 p3<=Data_in(31 downto 24);	
 p7<=Data_in(63 downto 56);	
 p11<=Data_in(95 downto 88);	
 p15<=Data_in(127 downto 120);	

Data_out<=p11&p6&p1&p12&p7&p2&p13&p8&p3&p14&p9&p4&p15&p10&p5&p0;	

end Behavioral;