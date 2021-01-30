----------------------------------------------------------------------------------
-- Company: University of Florida
-- Engineer: Shang Shi
-- 
-- Create Date: 11/13/2020 05:03:37 PM
-- Design Name: decrypter
-- Module Name: mod_mul - Behavioral
-- Project Name: RSA decrypter
-- Description: Perform r = a * b mod m
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mod_mul_tb is
end mod_mul_tb;

architecture Behavioral of mod_mul_tb is
component mod_mul is 
    Generic (   w : integer := 8);
    Port ( clk :    in STD_LOGIC;
           go :     in STD_LOGIC;
           a :      in UNSIGNED(w-1 DOWNTO 0);
           b :      in UNSIGNED(w-1 DOWNTO 0);
           m :      in UNSIGNED(w-1 DOWNTO 0);
           r :      out UNSIGNED(w-1 DOWNTO 0);
           valid :  out STD_LOGIC);
end component;
signal clk :    STD_LOGIC;
signal go :     STD_LOGIC;
signal a :      UNSIGNED(7 DOWNTO 0);
signal b :      UNSIGNED(7 DOWNTO 0);
signal m :      UNSIGNED(7 DOWNTO 0);
signal r :      UNSIGNED(7 DOWNTO 0);
signal valid :  STD_LOGIC;
begin
    dec: mod_mul
        port map(
           clk      =>clk,
           go       =>go,
           a        =>a,
           b        =>b,
           m        =>m,
           r        =>r,
           valid    =>valid
        );
process
begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
end process;  
process
begin
    go <= '0';   
--	a <= "00000010";
--	b <= "00000100";
--	m <= "00000011";
    wait for 15 ns;
    go <= '1';
    REPORT "Begin test case for a=240, b=73, m=153";
	REPORT "Expected output is 78";
    a <= "11110000";
	b <= "01001001";
	m <= "10011001"; 
    wait;
end process;
end Behavioral;
