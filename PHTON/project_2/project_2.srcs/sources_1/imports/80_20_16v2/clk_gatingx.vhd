LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY clock_gatex IS
GENERIC(NBITS : Integer);
PORT (  clk    : IN std_logic;
        enable : IN std_logic_vector(NBITS-1 downto 0);
        clk_en : OUT std_logic_vector(NBITS-1 downto 0)
);
END ENTITY clock_gatex;

--
ARCHITECTURE behav OF clock_gatex IS
signal enable_latch, clkx : std_logic_vector(NBITS-1 downto 0);

BEGIN
  -- Latch, on negative clock --
  process (clk, enable) begin
    if (clk = '0') then
     enable_latch <= enable;
  end if;
end process;  
  -- AND Gate
  clkx <= (others => clk);
  clk_en <= enable_latch AND clkx;
END ARCHITECTURE behav;
