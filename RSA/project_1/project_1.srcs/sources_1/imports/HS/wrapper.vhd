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

entity wrapper is
    Generic ( w : integer := 1024;
              ww : integer := 8);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           go : in STD_LOGIC;
           c : in UNSIGNED(ww - 1 DOWNTO 0);
           d : in UNSIGNED(ww - 1 DOWNTO 0);
           N : in UNSIGNED(ww - 1 DOWNTO 0);
           r : out UNSIGNED(ww - 1 DOWNTO 0);
           valid : out STD_LOGIC);
end wrapper;

architecture Behavioral of wrapper is
component decrypter
    Generic ( w : integer := 1024);
    Port ( clk : in STD_LOGIC;
           go : in STD_LOGIC;
           c : in UNSIGNED(w-1 DOWNTO 0);
           d : in UNSIGNED(w-1 DOWNTO 0);
           N : in UNSIGNED(w-1 DOWNTO 0);
           r : out UNSIGNED(w-1 DOWNTO 0);
           valid : out STD_LOGIC);
end component;
signal i : integer;
signal cc : UNSIGNED(w-1 DOWNTO 0);
signal dd : UNSIGNED(w-1 DOWNTO 0);
signal NN : UNSIGNED(w-1 DOWNTO 0);
signal rr : UNSIGNED(w-1 DOWNTO 0);
--signal t : UNSIGNED(w-1 DOWNTO 0);
signal gg : STD_LOGIC;
signal vv : STD_LOGIC;
signal mode : integer;

begin
d1: decrypter
    Port map( clk => clk,
           go => gg,
           d => dd,
           c => cc,
           N => NN,
           r => rr,
           valid => vv);
process(go, rst, clk)
begin
    if rst = '1' then
        cc <= (others => '0');
        dd <= (others => '0');
        NN <= (others => '0');
--        t <= (others => '0');
        i <= 0;
        valid <= '0';
        gg <= '0';
        mode <= 0;
    elsif (rising_edge(clk) and go = '1') then
        if mode = 0 then
            if i < w / ww then 
                cc((i + 1) * ww - 1 DOWNTO i * ww) <= c;
                dd((i + 1) * ww - 1 DOWNTO i * ww) <= d;
                NN((i + 1) * ww - 1 DOWNTO i * ww) <= N;
                i <= i + 1;
            else
                mode <= 1;
                gg <= '1';
            end if;
        elsif mode = 1 then
            if vv = '1' then
                mode <= 2;
                i <= 0;
--                t <= rr;
            end if;
        elsif mode = 2 then
            if i < w / ww then
                i <= i + 1;
                r <= rr((i + 1) * ww - 1 DOWNTO i * ww);
            else 
                valid <= '1';
                gg <= '0';
            end if;
        end if;
    end if;
end process;
end Behavioral;
