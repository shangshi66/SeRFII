----------------------------------------------------------------------------------
-- Company: University of Florida
-- Engineer: Shang Shi
-- 
-- Create Date: 11/13/2020 05:03:37 PM
-- Design Name: decrypter
-- Module Name: mod_mul - Behavioral
-- Project Name: RSA decrypter
-- Description: Perform r = a * b mod m assuming a < m
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mod_mul is
    Generic ( w : integer := 8);
    Port ( clk : in STD_LOGIC;
           go : in STD_LOGIC;
           a : in UNSIGNED(w-1 DOWNTO 0);
           b : in UNSIGNED(w-1 DOWNTO 0);
           m : in UNSIGNED(w-1 DOWNTO 0);
           r : out UNSIGNED(w-1 DOWNTO 0);
           valid : out STD_LOGIC);
end mod_mul;

architecture Behavioral of mod_mul is
signal t : UNSIGNED(w DOWNTO 0);
signal i : UNSIGNED(w - 1 DOWNTO 0);
begin
process(clk, go)
begin
    if go = '0' then
        r <= (others => '0');
        valid <= '0';
        t <= (others => '0');
        i <= (others => '0');
    elsif rising_edge(clk) then
        if i <= b then
            if t >= m then
                t <= t - m;
            else
                t <= t + a;
                i <= i + to_unsigned(1, i'length);
            end if;
        else
--            if t < m then
                r <= t(w - 1 DOWNTO 0) - a;
                valid <= '1';
--            else
--                t <= t - m;
--            end if;
        end if;
    end if;
end process;
end Behavioral;
