library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

Package multiplication IS
	Function short02  (input : Std_logic_vector) Return Std_logic_vector;
	Function short09  (input : Std_logic_vector) Return Std_logic_vector;
	Function short0B  (input : Std_logic_vector) Return Std_logic_vector;
	Function short0D  (input : Std_logic_vector) Return Std_logic_vector;
	Function short0E  (input : Std_logic_vector) Return Std_logic_vector;
End multiplication;

Package body multiplication is
			
			Function short02  (input : Std_logic_vector) Return Std_logic_vector is
			Variable result : std_logic_vector (7 downto 0);
			begin
			result := (input(6 downto 0) & '0') XOR ("00011011" And (input(7)& input(7)&input(7)&input(7)&input(7)&input(7)&input(7)&input(7)));
			return result;
			end short02;

			Function short09  (input : Std_logic_vector) Return Std_logic_vector is --(((Ci•2)•2)•2) xor Ci
			Variable part1 : std_logic_vector (7 downto 0);
			Variable part2 : std_logic_vector (7 downto 0);
			Variable part3 : std_logic_vector (7 downto 0);
			Variable result : std_logic_vector (7 downto 0);
			begin
			part1 := short02(input);
			part2 := short02(part1);
			part3 := short02(part2);
			result := part3 xor input;
			return result;
			end short09;
			
			Function short0B  (input : Std_logic_vector) Return Std_logic_vector is -- (((Ci•2)•2 xor  Ci)•2) xor Ci	
			Variable part1 : std_logic_vector (7 downto 0);
			Variable part2 : std_logic_vector (7 downto 0);
			Variable part3 : std_logic_vector (7 downto 0);
			Variable part4 : std_logic_vector (7 downto 0);
			Variable result : std_logic_vector (7 downto 0);
			begin
			part1 := short02(input);
			part2 := short02(part1);
			part3 := part2 xor input;
			part4 := short02(part3);
			result := part4 xor input;
			return result;
			end short0B;
			

			Function short0D  (input : Std_logic_vector) Return Std_logic_vector is -- (((Ci•2 xor Ci)•2)•2) xor Ci		
			Variable part1 : std_logic_vector (7 downto 0);
			Variable part2 : std_logic_vector (7 downto 0);
			Variable part3 : std_logic_vector (7 downto 0);
			Variable part4 : std_logic_vector (7 downto 0);
			Variable result : std_logic_vector (7 downto 0);
			begin
			part1 := short02(input);
			part2 := part1 xor input;
			part3 := short02(part2);
			part4 := short02(part3);
			result := part4 xor input;
			return result;
			end short0D;
			

			Function short0E  (input : Std_logic_vector) Return Std_logic_vector is -- (((Ci•2 xor Ci)•2) xor Ci)•2		
			Variable part1 : std_logic_vector (7 downto 0);
			Variable part2 : std_logic_vector (7 downto 0);
			Variable part3 : std_logic_vector (7 downto 0);
			Variable part4 : std_logic_vector (7 downto 0);
			Variable result : std_logic_vector (7 downto 0);
			begin
			part1 := short02(input);
			part2 := part1 xor input;
			part3 := short02(part2);
			part4 := part3 xor input;
			result := short02(part4);
			return result;
			end short0E;
			
end multiplication;