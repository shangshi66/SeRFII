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

entity decrypter is
    Generic ( w : integer := 1024);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           go : in STD_LOGIC;
           c : in UNSIGNED(w - 1 DOWNTO 0);
           d : in UNSIGNED(w - 1 DOWNTO 0);
           N : in UNSIGNED(w - 1 DOWNTO 0);
           r : out UNSIGNED(w - 1 DOWNTO 0);
           valid : out STD_LOGIC);
end decrypter;

architecture Behavioral of decrypter is
component mod_mul
    Generic ( w : integer := 1024);
    Port ( clk : in STD_LOGIC;
           go : in STD_LOGIC;
           a : in UNSIGNED(w-1 DOWNTO 0);
           b : in UNSIGNED(w-1 DOWNTO 0);
           m : in UNSIGNED(w-1 DOWNTO 0);
           r : out UNSIGNED(w-1 DOWNTO 0);
           valid : out STD_LOGIC);
end component;
signal i : integer;
signal t1 : UNSIGNED(w-1 DOWNTO 0);
--signal c : UNSIGNED(w-1 DOWNTO 0) := (others => '0');
--signal d : UNSIGNED(w-1 DOWNTO 0) := (others => '0');
--signal N : UNSIGNED(w-1 DOWNTO 0) := (others => '0');
--signal r : UNSIGNED(w-1 DOWNTO 0);
signal cn : UNSIGNED(w-1 DOWNTO 0);
signal a1 : UNSIGNED(w-1 DOWNTO 0);
signal b1 : UNSIGNED(w-1 DOWNTO 0);
signal r1 : UNSIGNED(w-1 DOWNTO 0);
signal g1 : STD_LOGIC;
signal v1 : STD_LOGIC;
signal mode : integer;

begin
mm1: mod_mul
    Port map( clk => clk,
           go => g1,
           a => a1,
           b => b1,
           m => N,
           r => r1,
           valid => v1);
process(go, rst, clk)
begin
    if rst = '1' then
        r <= (others => '0');
        i <= 0;
        t1 <= TO_UNSIGNED(1, t1'length);
        cn <= c;
        a1 <= (others => '0');
        b1 <= TO_UNSIGNED(1, b1'length);
        valid <= '0';
        g1 <= '0';
        mode <= 0;
    elsif (rising_edge(clk) and go = '1') then
        if mode = 0 then
            if v1 = '0' then 
                a1 <= c;
                b1 <= TO_UNSIGNED(1, b1'length);
                g1 <= '1';
            else
                cn <= r1;
                mode <= 1;
                g1 <= '0';
            end if;
        elsif mode = 1 then
            if d(i) = '0' then
                i <= i + 1;
                mode <= 2;
            else 
                if v1 = '0' then
                    a1 <= cn;
                    b1 <= t1;
                    g1 <= '1';
                else
                    t1 <= r1;
                    g1 <= '0';
                    mode <= 2;
                    i <= i + 1;
                end if;
            end if;
        elsif mode = 2 then
            if i < w then
                if v1 = '0' then
                    a1 <= cn;
                    b1 <= cn;
                    g1 <= '1';
                else
                    cn <= r1;
                    g1 <= '0';
                    mode <= 1;
                end if;
            else
                mode <= 3;
            end if;
        elsif mode = 3 then
            r <= t1;
            valid <= '1';
        end if;
    end if;
end process;
end Behavioral;
