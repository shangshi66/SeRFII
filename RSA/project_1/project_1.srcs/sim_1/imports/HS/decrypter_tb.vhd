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
 
REPORT "Expected output is 9107f695022a9c227c9506bf";
    c(47 DOWNTO 0) <= x"9107f695023f";
	d(19 DOWNTO 0) <= x"10001";
	N <= x"adc8d7d46f0309e956ce85685ee8de2713c3655bc5e618d94bc5feda21fb5b87676a18d3f3e8744d04a4e20304433f1ae5b5d4ad3c58c8131c93e48abf94bdfd0b63ff0f5d244948525a78e2ece436c375f0837b0f599e0566015b1d4c941193e04c7142fbf7d9ad58bbd49fd836d6688f2813ee076d4ac034d09e6a2e122269";
    go <= '1';


--    REPORT "Expected output is 9107f695022a9c227c9506bf";
--    c <= x"294b457e2fa141761cadad3b287857cfa874682976c628113fa006f6d60fb8de3cd740dc19223e2a265d1b838a251f2a030da4770bba2941a98828382c03430e875dbda1cd0858f6d6ef9a41fafe7b63953852de0a54c90d0278d70e29df4e625f36d5ae0f3c320ff896f2001f03c8428bcb56b74087f52ab76a8fd94ac039f6";
--	d <= x"85b608573c1deed9ce0bb98f043825ba76ff81a7468313130ab90203bbb4cc59654358faf30374af0cf08dc3542a938d4705799d41088a1a321f12efe5ca4e2ffbd470abe8371dd7530e4b5e61ca6750faa5ae900d10ab083b5b38575e134775ed5a53eca0d957d9323b7f4cdc59230f21999005e2b2815412c54fdcfbfb1fb1";
--	N <= x"b540adeae00a397e08476ae7e13dece61039512ec03bc76aec05a3499ae627b6c4709b1d69fb8fa6f78aad07fab1a05c25c76634262d1eb050df6f8ba3c595b9cd8d3789b96920be42b346b32b0083d00e0c6b92d17f904ef59f7a0558afc33d1c5f94802bde4462fa657325bb742037e283fc7fa9ab148387c0500679c00e6b";
--    go <= '1';
--    wait for 15 ms;
--    ASSERT(r = x"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009107f695022a9c227c9506bf") REPORT "test failed" SEVERITY ERROR;
    
--    REPORT "Begin test case for c=228, d=144, N=169";
--	REPORT "Expected output is 157";
--    c <= x"e4";
--	d <= x"90";
--	N <= x"a9";
--    go <= '1';
--    wait for 1000 ns;
--    ASSERT(r = x"9d") REPORT "test failed" SEVERITY ERROR;
    wait;
end process;
end Behavioral;
