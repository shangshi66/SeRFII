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

entity decoder is
    Generic (   w : integer);
    Port ( clk :    in STD_LOGIC;
           rst :    in STD_LOGIC;
           go :     in STD_LOGIC;
           c :      in UNSIGNED(w-1 DOWNTO 0);
           d :      in UNSIGNED(w-1 DOWNTO 0);
           N :      in UNSIGNED(w-1 DOWNTO 0);
           r :      out UNSIGNED(w-1 DOWNTO 0);
           valid :  out STD_LOGIC);
end decoder;

architecture Behavioral of decoder is
signal i : integer := 0;
signal f : integer := 1;
begin
process(clk, rst)
begin
    if rst = '1' then
        r       <= (others => '0');
        valid   <= '0';
        i <= 0;
        f <= 1;
    elsif(rising_edge(clk) and go = '1') then
        if (i < to_integer(d) and f /= 0) then
            f <= (to_integer(c) * f) mod to_integer(N);
            i <= i + 1;
        elsif (i = to_integer(d) or f = 0) then
            r       <= to_unsigned(f, r'length);
            valid   <= '1';
        end if;
    end if;
end process;
end Behavioral;
