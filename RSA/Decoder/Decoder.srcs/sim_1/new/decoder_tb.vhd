----------------------------------------------------------------------------------
-- Company: University of Florida
-- Engineer: Shang Shi
-- 
-- Create Date: 11/13/2020 05:03:37 PM
-- Design Name: Decoder
-- Module Name: decoder - Behavioral
-- Project Name: RSA decoder
-- Description: Perform r = c ^ d mod N
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity decoder_tb is
end decoder_tb;

architecture Behavioral of decoder_tb is
component decoder is 
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
    dec: decoder
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
    REPORT "Begin test case for c=164, d=9, N=89";
	REPORT "Expected output is 82";
    c <= "10100100";
	d <= "00001001";
	N <= "01011001";
    wait for 10 ns;
    go <= '1';
    wait for 1000 ns;
    ASSERT(r = "01010010") REPORT "test failed" SEVERITY ERROR;

    wait;
end process;
end Behavioral;
