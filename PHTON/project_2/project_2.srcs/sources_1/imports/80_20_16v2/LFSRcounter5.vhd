--asynchron reset
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LFSRcounter5 is
	port(
		clk	: in std_logic;
		selDataIn    : in std_logic;
		q	: out std_logic_vector(2 downto 0)
		);

end entity LFSRcounter5;

architecture dfl of LFSRcounter5 is

	signal count_reg : std_logic_vector(2 downto 0);
	signal dataIn : std_logic;

begin

process(clk)
begin
	if(clk'event and clk = '1') then
			count_reg <= count_reg(1 downto 0) & dataIn;
	end if;
end process;

-----------------------
-- Input MUX
-----------------------
dataIn <= '0' when selDataIn = '0'
			else count_reg(2) NOR count_reg(1);--seq 5 LFSR

q <= count_reg;
        
end architecture dfl;
