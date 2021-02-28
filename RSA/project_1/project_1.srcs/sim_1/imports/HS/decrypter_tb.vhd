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
use std.env.finish;

entity decrypter_tb is
    Generic (   w : integer := 1024);
end decrypter_tb;

architecture Behavioral of decrypter_tb is
component decrypter is 
    Generic (   w : integer := w);
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
signal c :      UNSIGNED(w-1 DOWNTO 0);
signal d :      UNSIGNED(w-1 DOWNTO 0);
signal N :      UNSIGNED(w-1 DOWNTO 0);
signal r :      UNSIGNED(w-1 DOWNTO 0);
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
    wait for 1 ns;
    clk <= '1';
    wait for 1 ns;
end process;  
process
begin
    rst <= '1';
    go <= '0';
    c <= (others => '0');
    d <= (others => '0');
    wait for 10 ns;
    rst <= '0';
 
REPORT "Expected output is 48656c6c6f20776f726c6421";
    c <= x"0212f43dbbbfabb5190a723a964c4aaf29ad37687d827982db10e30bfe9b1d17e7c40e69a06648822be5d0f192d89795f4dd0590a35e1b7449fa4ab2196f6abb7804f1dbaa7de19e9aef8992fefded09d7baaf459058e4e4d49a95955797f4e34aff02ac33c7b582aa1fc9fa772d8ee9ed115dfa6da73e2ed1a5d5fad029767a";
	d <= x"910ab14da4d0a13943556dcc823d022148e256d316c32e74d1bb288f27a13a9b4146545c8796f7e9631175dd2089a2b3c25b10a92bfc19e0755c6ca513089e89376598a67d268d08d0d8b133367687c5224d8819effdb22884e16a97797c75b5142cd2c304c1c6647f1497fa15aec8b608616c5a706e21e68f6d9637c0669dc9";
	N <= x"be0c246c5aaa8fa3673e7424aadaf367cc62b2f3b03fa82bb0bfae291efe370615c2be2871b9a45035491163c5b4f9000fcc965073bd98513132347e5e54f92370c2e829e27e57be6a1af3e31d5eecfbeeb71f5c946f83d800a3b6348ff229a6ceef75c3b367cf13ff9a39c3ecbf194ede5ca99b63df2a778cc4f31baed2f5c7";
    go <= '1';

    wait until valid = '1';
    wait for 10 ns;
    finish;
end process;
end Behavioral;
