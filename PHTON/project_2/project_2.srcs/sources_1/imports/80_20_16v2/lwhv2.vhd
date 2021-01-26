-- D-Flip-Flop lightweight
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.hashpkg.all;

entity lwhv2 is
        port(
        		clk			: in std_logic;
        		init		: in std_logic;
        		nReset		: in std_logic;
        		nBlock		: in std_logic;
                input       : in std_logic_vector(s-1 downto 0);
                output      : out std_logic_vector(s-1 downto 0);
        		outReady	: out std_logic
                );

end entity lwhv2;

architecture dfl of lwhv2 is

---------------------------------------------------------------------------
-- Component declaration
---------------------------------------------------------------------------
component killerIO is
	generic (NBITS: integer);
        port(
                a       : in std_logic_vector(NBITS-1 downto 0);
                b       : in std_logic_vector(NBITS-1 downto 0);
                nReset  : in std_logic;
                nb	    : in std_logic;
                output  : out std_logic_vector(NBITS-1 downto 0)
                );

end component killerIO;

component controlerv2 is
port(
	clk		: in std_logic;
	nReset : in std_logic;
	nBlock  : in std_logic;
	clkc1  : out std_logic_vector(n-1 downto 0);
	clklc  : out std_logic_vector(n-1 downto 0);
	round   : out std_logic_vector(3 downto 0);
  	offset  : out std_logic_vector(3 downto 0);
  	selc1   : out std_logic;
	sellc   : out std_logic;
	enAdd   : out std_logic;
	done    : out std_logic
);
end component controlerv2;

component State is
	generic (NBITS_s: integer;
		 	NBITS_n: integer);
	port(
		gclkc1 : in std_logic_vector(NBITS_n-1 downto 0);--gated clock for first column
		gclklc : in std_logic_vector(NBITS_n-1 downto 0);--gated clock for other columns
		selc1: in std_logic;
		sellc: in std_logic;
		inMC : in std_logic_vector(NBITS_s - 1 downto 0);
		inS	 : in std_logic_vector(NBITS_s - 1 downto 0);
		outS : out std_logic_vector(NBITS_s -1 downto 0);
		outMC: out std_logic_vector(NBITS_s*NBITS_n -1 downto 0)
		);
end component State;

component SboxDAO is
    Port ( sboxIn : in  STD_LOGIC_VECTOR (3 downto 0);
           sboxOut : out  STD_LOGIC_VECTOR (3 downto 0)
           );
end component SboxDAO;

component MC5 is
        port(
                input       : in std_logic_vector(s*n-1 downto 0);
                output      : out std_logic_vector(s-1 downto 0)
                );
end component MC5;

---------------------------------------------------------------------------
-- Signal declaration
---------------------------------------------------------------------------
        signal MCin : std_logic_vector(n*s-1 downto 0);
        signal MCout, CAin : std_logic_vector(s-1 downto 0);
        signal round, offset, enAddx : std_logic_vector(s-1 downto 0);
        
        signal StateIn, StateOut, SboxIn, SboxOut : std_logic_vector(s-1 downto 0);
        signal gclkc1, gclklc : std_logic_vector(n-1 downto 0);
        signal selc1, sellc : std_logic;
        signal enAdd : std_logic;
        
begin

---------------------------------------------------------------------------
-- I/O
---------------------------------------------------------------------------
IO: killerIO
	generic map(NBITS=>s)
    port map(
                a => stateOut,--SboxOut,--stateOut,
                b => input,
                nReset  => init,
                nb	    => nBlock,
                output  => CAin--StateIn--CAin
                );

---------------------------------------------------------------------------
-- Finite State Machine
---------------------------------------------------------------------------
fsm: controlerv2
	port map(
	clk	=> clk,
	nReset => nReset,
	nBlock => nBlock,
	clkc1  => gclkc1,
	clklc => gclklc,
	round  => round,
  	offset  => offset,
  	selc1 => selc1,
  	sellc => sellc,
  	enAdd => enAdd,
  	done => outReady
		);

---------------------------------------------------------------------------
-- State array
---------------------------------------------------------------------------
mem: state
	generic map (NBITS_s => s,
		 	NBITS_n => n)
	port map(
		gclkc1 => gclkc1, 
		gclklc => gclklc, 
		selc1  => selc1,
		sellc  => sellc,
		inMC   => MCout,
		inS	   => StateIn,
		outS   => StateOut,
		outMC  => MCin
		);

---------------------------------------------------------------------------
-- Sbox
---------------------------------------------------------------------------
SB: SboxDAO
port map(
	sboxIn => SboxIn,
	sboxOut => SboxOut
	);

---------------------------------------------------------------------------
-- MixColumns
---------------------------------------------------------------------------
MC: MC5
port map(
	input => MCin,
	output => MCout
	);
       
---------------------------------------------------------------------------
-- Wiring
---------------------------------------------------------------------------
StateIn <= SboxOut;
---------------------------------------------------------------------------
-- Constant Addition
---------------------------------------------------------------------------
enAddx <= (others => enAdd);
SboxIn <= CAin XNOR (enAddx NAND (round XOR offset));
--SboxIn <= StateOut XNOR (enAddx NAND (round XOR offset));

---------------------------------------------------------------------------
-- output is direct from register
---------------------------------------------------------------------------
output <= StateOut;

end architecture dfl;