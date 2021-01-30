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
signal t1 : UNSIGNED(w DOWNTO 0);
signal t2 : UNSIGNED(w DOWNTO 0);
signal mode : integer;
signal i : integer;
begin
process(clk, go)
begin
    if go = '0' then
        r <= (others => '0');
        valid <= '0';
        t1 <= (others => '0');
        t2 <= (others => '0');
        mode <= 0;
        i <= 1;
    elsif rising_edge(clk) then
        case mode is
            when 0 =>
                t1(w-1 DOWNTO 0) <= a;
                if b(0) = '1' then
                    t2(w-1 DOWNTO 0) <= a;
                end if;
                mode <= 1;
            when 1 =>
                t1 <= t1 + t1;
                mode <= 2;
            when 2 => 
                if t1 >= m then
                    t1 <= t1 - m;
                else 
                    mode <= 3;
                end if;
            when 3 =>
                if b(i) = '1' then
                    t2 <= t2 + t1;
                    mode <= 4;
                elsif i < w-1 then
                    i <= i + 1;
                    mode <= 1;
                else
                    mode <= 5;
                end if;
            when 4 => 
                if t2 >= m then
                    t2 <= t2 - m;
                elsif i < w-1 then
                    i <= i + 1;
                    mode <= 1;
                else 
                    mode <= 5;
                end if;
            when 5 =>
                r <= t2(w-1 DOWNTO 0);
                valid <= '1';
            when others =>
                mode <= 0;
                
--                if go = '1' then
--                    t1 <= a;
--                    t2 <= b;
--                    t <= (others => '0');
--                    mode <= 1;
--                end if;
--            when 1 =>
--                if t1 > m then
--                    t1 <= t1 - m;
--                elsif t2 > m then
--                    t2 <= t2 - m;
--                else
--                    mode <= 2;
--                end if;
--             when 2 =>
--                if t2 <= 0 then
--                    mode <= 3;
--                else 
--                    if t >= m then
--                        t <= t - m;
--                    else
--                        t <= t + t1;
--                        t2 <= t2 - to_unsigned(1, t2'length);
--                    end if;
--                end if;
--            when 3 =>
--                if t >= m then
--                    t <= t - m;
--                else
--                    r <= t(w - 1 DOWNTO 0) - a;
--                    valid <= '1';
--                end if;
--            when others =>
--                mode <= 0;
        end case;
    end if;
end process;
end Behavioral;
