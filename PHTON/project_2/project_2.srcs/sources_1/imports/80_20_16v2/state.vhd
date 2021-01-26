-- Template for the state of AES like priitives
-- shift row offset is done by clocking
-- first column has two inputs, consists of n registers 
-- last column has two inputs, consists of n-1 registers
-- middle part = rows, consists of LFSR with 1 input
--
--	           LFSR 	
--   +--+  +-----+  +--+<-00
-- <-|00|<-| n-2 |<-|05|
--   +--+  +-----+  +--+<-10
--   +--+  +-----+  +--+<-10
-- <-|10|<-| n-2 |<-|15|
--   +--+  +-----+  +--+<-20
--   +--+  +-----+  +--+<-20
-- <-|20|<-| n-2 |<-|25|
--   +--+  +-----+  +--+<-30
--   +--+  +-----+  +--+<-30
-- <-|30|<-| n-2 |<-|35|
--   +--+  +-----+  +--+<-40
--   +--+  +-----+  +--+<-40
-- <-|40|<-| n-2 |<-|45|
--   +--+  +-----+  +--+<-50
--   +--+  +-----+  +--+<-50
-- <-|50|<-| n-2 |<-|55|
--   +--+  +-----+  +--+<-inS
--    c1    rows     lc
-- outS = 00
-- outMC = 00&10&20&30&40&50

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state is
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

end entity state;


architecture dfl of state is

	signal int_D0_c1, int_D1_c1, int_Q_c1 	: std_logic_vector(NBITS_s*NBITS_n- 1 downto 0);
	signal int_D0_lc, int_D1_lc, int_Q_lc 	: std_logic_vector(NBITS_s*NBITS_n- 1 downto 0);
	--last column has only n-1 rows
	signal int_D_rows, int_Q_rows 	: std_logic_vector(NBITS_s*NBITS_n- 1 downto 0);
	--int_Q1_rows only used for test reasons
	signal S00,S10,S20,S30,S40 	: std_logic_vector(NBITS_s- 1 downto 0); --first column
	signal S1l,S2l,S3l,S4l 	: std_logic_vector(NBITS_s- 1 downto 0); --last column
	
	signal test_rows 	: std_logic_vector(NBITS_s*NBITS_n*(NBITS_n-2) downto 0); --last column
	signal row0,row1,row2,row3,row4 	: std_logic_vector(NBITS_s*NBITS_n-1 downto 0); --one row for testing purpose

component dflipfloplw2in is
	generic (NBITS: integer);
	port(
		clk	: in std_logic;
		n_reset	: in std_logic;
		D	: in std_logic_vector(NBITS-1 downto 0);
		D_rst	: in std_logic_vector(NBITS-1 downto 0);
		Q	: out std_logic_vector(NBITS-1 downto 0)
		);
end component dflipfloplw2in;

component LFSR is
	generic (NBITS_D0: integer;
		 NBITS_D1: integer);
	port(
		clk	: in std_logic;
		D0	: in std_logic_vector(NBITS_D0 - 1 downto 0);
		Q0	: out std_logic_vector(NBITS_D0 -1 downto 0);
		Q1	: out std_logic_vector(NBITS_D1 -1 downto 0)
		);
end component LFSR;

begin
-------------------------------------------------------------------------------------
-- wiring, first column
-------------------------------------------------------------------------------------
S00 <= int_Q_c1(NBITS_s*NBITS_n-1 downto NBITS_s*(NBITS_n-1)); 
S10 <= int_Q_c1(NBITS_s*(NBITS_n-1)-1 downto NBITS_s*(NBITS_n-2)); 
S20 <= int_Q_c1(NBITS_s*(NBITS_n-2)-1 downto NBITS_s*(NBITS_n-3)); 
S30 <= int_Q_c1(NBITS_s*(NBITS_n-3)-1 downto NBITS_s*(NBITS_n-4)); 
S40 <= int_Q_c1(NBITS_s*(NBITS_n-4)-1 downto NBITS_s*(NBITS_n-5)); 
-- S50 <= int_Q_c1(NBITS_s*(NBITS_n-5)-1 downto NBITS_s*(NBITS_n-6)); 
-- S60 <= int_Q_c1(NBITS_s*(NBITS_n-6)-1 downto NBITS_s*(NBITS_n-7)); 
--S70 <= int_Q_c1(NBITS_s*(NBITS_n-7)-1 downto NBITS_s*(NBITS_n-8)); 
--S80 <= int_Q_c1(NBITS_s*(NBITS_n-8)-1 downto NBITS_s*(NBITS_n-9)); 

-------------------------------------------------------------------------------------
-- wiring, last column
-------------------------------------------------------------------------------------
S1l <= int_Q_lc(NBITS_s*(NBITS_n-1)-1 downto NBITS_s*(NBITS_n-2)); 
S2l<= int_Q_lc(NBITS_s*(NBITS_n-2)-1 downto NBITS_s*(NBITS_n-3)); 
S3l <= int_Q_lc(NBITS_s*(NBITS_n-3)-1 downto NBITS_s*(NBITS_n-4)); 
S4l <= int_Q_lc(NBITS_s*(NBITS_n-4)-1 downto NBITS_s*(NBITS_n-5)); 
-- S5l <= int_Q_lc(NBITS_s*(NBITS_n-5)-1 downto NBITS_s*(NBITS_n-6)); 
-- S6l <= int_Q_lc(NBITS_s*(NBITS_n-6)-1 downto NBITS_s*(NBITS_n-7)); 
--S7l <= int_Q_lc(NBITS_s*(NBITS_n-7)-1 downto NBITS_s*(NBITS_n-8)); 
--S8l <= int_Q_lc(NBITS_s*(NBITS_n-8)-1 downto NBITS_s*(NBITS_n-9)); 

-------------------------------------------------------------------------------------
-- input c1, from middle part to first column
-------------------------------------------------------------------------------------
int_D0_c1 <= int_Q_rows;
-------------------------------------------------------------------------------------
-- input c1, vertical shifting in first column
-------------------------------------------------------------------------------------
int_D1_c1 <= int_Q_c1((NBITS_n-1)*NBITS_s-1 downto 0)&inMC;

-------------------------------------------------------------------------------------
-- c1, first column
-------------------------------------------------------------------------------------
gen_Col1:
FOR i in 1 to NBITS_n GENERATE
gff: dflipfloplw2in
	generic map(NBITS=>NBITS_s)
	port map(
		clk => gclkc1(NBITS_n-i),
		n_reset => selc1,
      	D => int_D1_c1(NBITS_s*i - 1 downto (i-1)*NBITS_s),
  		D_rst => int_D0_c1(NBITS_s*i - 1 downto (i-1)*NBITS_s),
      	Q => int_Q_c1(NBITS_s*i - 1 downto (i-1)*NBITS_s)
		);
END GENERATE gen_Col1;

-------------------------------------------------------------------------------------
-- input lc, normal serial input
-------------------------------------------------------------------------------------
int_D0_lc <= int_Q_c1((NBITS_n-1)*NBITS_s-1 downto 0)&inS; 
-------------------------------------------------------------------------------------
-- input lc, ShiftRows input
-------------------------------------------------------------------------------------
int_D1_lc <= int_Q_c1(NBITS_n*NBITS_s-1 downto 0);

-------------------------------------------------------------------------------------
-- last column
-------------------------------------------------------------------------------------
gen_lastCol:
FOR i in 1 to NBITS_n GENERATE
gff: dflipfloplw2in
	generic map(NBITS=>NBITS_s)
	port map(
		clk => gclklc(NBITS_n-i),
		n_reset => sellc,
      D => int_D1_lc(NBITS_s*i - 1 downto (i-1)*NBITS_s),
  		  D_rst => int_D0_lc(NBITS_s*i - 1 downto (i-1)*NBITS_s),
      Q => int_Q_lc(NBITS_s*i - 1 downto (i-1)*NBITS_s)
		);
END GENERATE gen_lastCol;

-------------------------------------------------------------------------------------
-- input rows, input to middle part
-------------------------------------------------------------------------------------
int_D_rows <= int_Q_lc;

-------------------------------------------------------------------------------------
-- rows, middle part, rows 1 to n-1 
-------------------------------------------------------------------------------------
gen_rows:
FOR i in 1 to NBITS_n GENERATE
gff: LFSR
	generic map(NBITS_D0=>NBITS_s,
				NBITS_D1=>NBITS_s*(NBITS_n-2))
	port map(
		clk => gclklc(NBITS_n-i),
	     D0 => int_D_rows(NBITS_s*i - 1 downto (i-1)*NBITS_s),
      	 Q0 => int_Q_rows(NBITS_s*i - 1 downto (i-1)*NBITS_s),
      	 Q1 => test_rows(i*NBITS_s*(NBITS_n-2)-1 downto (i-1)*NBITS_s*(NBITS_n-2))
		);
END GENERATE gen_rows;

-------------------------------------------------------------------------------------
-- output, outMC is concatenation of first column
-------------------------------------------------------------------------------------
outMC <= int_Q_c1;
outS <= int_Q_c1(NBITS_n*NBITS_s-1 downto (NBITS_n-1)*NBITS_s); 
-------------------------------------------------------------------------------------
-- signals for debugging purpose
-------------------------------------------------------------------------------------
row0 <= int_Q_c1(NBITS_n*NBITS_s-1 downto (NBITS_n-1)*NBITS_s)&test_rows((NBITS_n-2)*NBITS_n*NBITS_s-1 downto (NBITS_n-2)*(NBITS_n-1)*NBITS_s)&int_Q_lc(NBITS_n*NBITS_s-1 downto (NBITS_n-1)*NBITS_s);
row1 <= int_Q_c1((NBITS_n-1)*NBITS_s-1 downto (NBITS_n-2)*NBITS_s)&test_rows((NBITS_n-2)*(NBITS_n-1)*NBITS_s-1 downto (NBITS_n-2)*(NBITS_n-2)*NBITS_s)&int_Q_lc((NBITS_n-1)*NBITS_s-1 downto (NBITS_n-2)*NBITS_s);
row2 <= int_Q_c1((NBITS_n-2)*NBITS_s-1 downto (NBITS_n-3)*NBITS_s)&test_rows((NBITS_n-2)*(NBITS_n-2)*NBITS_s-1 downto (NBITS_n-2)*(NBITS_n-3)*NBITS_s)&int_Q_lc((NBITS_n-2)*NBITS_s-1 downto (NBITS_n-3)*NBITS_s);
row3 <= int_Q_c1((NBITS_n-3)*NBITS_s-1 downto (NBITS_n-4)*NBITS_s)&test_rows((NBITS_n-2)*(NBITS_n-3)*NBITS_s-1 downto (NBITS_n-2)*(NBITS_n-4)*NBITS_s)&int_Q_lc((NBITS_n-3)*NBITS_s-1 downto (NBITS_n-4)*NBITS_s);
row4 <= int_Q_c1((NBITS_n-4)*NBITS_s-1 downto (NBITS_n-5)*NBITS_s)&test_rows((NBITS_n-2)*(NBITS_n-4)*NBITS_s-1 downto (NBITS_n-2)*(NBITS_n-5)*NBITS_s)&int_Q_lc((NBITS_n-4)*NBITS_s-1 downto (NBITS_n-5)*NBITS_s);
-- row5 <= int_Q_c1((NBITS_n-5)*NBITS_s-1 downto (NBITS_n-6)*NBITS_s)&test_rows((NBITS_n-2)*(NBITS_n-5)*NBITS_s-1 downto (NBITS_n-2)*(NBITS_n-6)*NBITS_s)&int_Q_lc((NBITS_n-5)*NBITS_s-1 downto (NBITS_n-6)*NBITS_s);
-- row6 <= int_Q_c1((NBITS_n-6)*NBITS_s-1 downto (NBITS_n-7)*NBITS_s)&test_rows((NBITS_n-2)*(NBITS_n-6)*NBITS_s-1 downto (NBITS_n-2)*(NBITS_n-7)*NBITS_s)&int_Q_lc((NBITS_n-6)*NBITS_s-1 downto (NBITS_n-7)*NBITS_s);
--row7 <= int_Q_c1((NBITS_n-7)*NBITS_s-1 downto (NBITS_n-8)*NBITS_s)&test_rows((NBITS_n-2)*(NBITS_n-7)*NBITS_s-1 downto (NBITS_n-2)*(NBITS_n-8)*NBITS_s)&int_Q_lc((NBITS_n-7)*NBITS_s-1 downto (NBITS_n-8)*NBITS_s);
end architecture;
