--asynchron reset
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LFSRcounter15v2 is
	port(
		clk	: in std_logic;
		selDataIn    : in std_logic;
		q	: out std_logic_vector(3 downto 0)
		);

end entity LFSRcounter15v2;

architecture dfl of LFSRcounter15v2 is

	signal count_reg : std_logic_vector(3 downto 0);
	signal dataIn : std_logic;

begin

process(clk)
begin
	if(clk'event and clk = '1') then
		if selDataIn = '0' then
			count_reg <= "0000";
		else
			count_reg <= count_reg(2 downto 0) & dataIn;
		end if;
	end if;
end process;

dataIn <= count_reg(3) XNOR count_reg(2);

q <= count_reg(2 downto 0) & dataIn;--count_reg
        
end architecture dfl;
