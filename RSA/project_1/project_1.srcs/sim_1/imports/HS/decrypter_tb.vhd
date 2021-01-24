----------------------------------------------------------------------------------
-- Company: University of Florida
-- Engineer: Shang Shi
-- 
-- Create Date: 11/13/2020 05:03:37 PM
-- Design Name: decrypter
-- Module Name: decrypter - Behavioral
-- Project Name: RSA decrypter
-- Description: Perform r = c ^ d mod N
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity decrypter_tb is
end decrypter_tb;

architecture Behavioral of decrypter_tb is
component decrypter is 
    Generic (   w : integer := 8);
    Port ( clk :    in STD_LOGIC;
           rst :    in STD_LOGIC;
           go :     in STD_LOGIC;
           c :      in UNSIGNED(w-1 DOWNTO 0);
           d :      in UNSIGNED(w-1 DOWNTO 0);
           N :      in UNSIGNED(w-1 DOWNTO 0);
           r :      out UNSIGNED(w-1 DOWNTO 0);
           valid :  out STD_LOGIC);
end component;
signal clk :    STD_LOGIC;
signal rst :    STD_LOGIC;
signal go :     STD_LOGIC;
signal c :      UNSIGNED(7 DOWNTO 0);
signal d :      UNSIGNED(7 DOWNTO 0);
signal N :      UNSIGNED(7 DOWNTO 0);
signal r :      UNSIGNED(7 DOWNTO 0);
signal valid :  STD_LOGIC;
begin
    dec: decrypter
        port map(
           clk      =>clk,
           rst      =>rst,
           go       =>go,
           c        =>c,
           d        =>d,
           N        =>N,
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
    rst <= '1';
    go <= '0';
    wait for 10 ns;
    rst <= '0';
    REPORT "Begin test case for c=228, d=144, N=169";
	REPORT "Expected output is 157";
    c <= "11100100";
	d <= "10010000";
	N <= "10101001";
    go <= '1';
    wait for 1000 ns;

    wait;
end process;
end Behavioral;
