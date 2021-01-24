-- serial-MixColumns
-- computes 1 nibble
-- 1, x, x^3, x^2+1, x^3, x
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.hashpkg.all;

entity MC5 is
        port(
                input       : in std_logic_vector(n*s-1 downto 0);
                output      : out std_logic_vector(s-1 downto 0)
                );

end entity MC5;

architecture dfl of MC5 is

component times2 is
        port(
                input       : in std_logic_vector(s-1 downto 0);
                output      : out std_logic_vector(s-1 downto 0)
                );

end component times2;

component times8 is
        port(
                input       : in std_logic_vector(s-1 downto 0);
                output      : out std_logic_vector(s-1 downto 0)
                );

end component times8;

   signal S0,S1,S2,S3,S4 : std_logic_vector(s-1 downto 0);
   signal S12,S28,S38,S42 : std_logic_vector(s-1 downto 0);

begin

---------------------------------------------------------------------
-- | S0 | S1 | S2 | S3 | S4 |

--   1   x   x3+x  x3+x  x
--   1   2     9    9    2
---------------------------------------------------------------------
S0 <= input(19 downto 16);
S1 <= input(15 downto 12);
S2 <= input(11 downto 8);
S3 <= input(7 downto 4);
S4 <= input(3 downto 0);

xS1: times2
port map(
	input => S1,
	output => S12
	);

x3S2: times8
port map(
	input => S2,
	output => S28
	);


x3S3: times8
port map(
	input => S3,
	output => S38
	);
	
xS4: times2
port map(
	input => S4,
	output => S42
	);

output <= S0 XOR S12 XOR S28 XOR S2 XOR S38 XOR S3 XOR S42; 

end architecture dfl;