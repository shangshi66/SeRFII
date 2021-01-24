LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;
USE ieee.numeric_std.ALL;

-- file functions
USE ieee.std_logic_textio.all;
LIBRARY STD;
USE STD.TEXTIO.ALL;

--package
use work.hashpkg.all;
 
ENTITY tb_state IS
END tb_state;
 
ARCHITECTURE bench OF tb_state IS 
 
-- Component Declaration for the Unit Under Test (UUT)
-- component state is
-- 	generic (NBITS_s: integer;
-- 		 	NBITS_n: integer);
-- 	port(
-- 		gclkc1 : in std_logic_vector(NBITS_n-1 downto 0);--gated clock for other columns
-- 		gclklc : in std_logic_vector(NBITS_n-1 downto 0);--gated clock for other columns
-- 		selc1: in std_logic;
-- 		sellc: in std_logic;
-- 		inMC : in std_logic_vector(NBITS_s - 1 downto 0);
-- 		inS	 : in std_logic_vector(NBITS_s - 1 downto 0);
-- 		outS : out std_logic_vector(NBITS_s*NBITS_n -1 downto 0);
-- 		outMC: out std_logic_vector(NBITS_s -1 downto 0)
-- 		);
-- 
-- end component state;

-- component controler is
-- port(
-- 	clk		: in std_logic;
-- 	nReset  : in std_logic;
-- 	gclkc1  : out std_logic_vector(n-1 downto 0);
-- 	gclklc  : out std_logic_vector(n-1 downto 0);
-- 	round   : out std_logic_vector(3 downto 0);
--   	offset  : out std_logic_vector(3 downto 0);
--   	enAdd   : out std_logic;
-- 	done    : out std_logic
-- );
-- end component controler;

component lwhv2 is
        port(
        		clk			: in std_logic;
        		init		: in std_logic;
        		nReset		: in std_logic;
        		nBlock		: in std_logic;
                input       : in std_logic_vector(s-1 downto 0);
                output      : out std_logic_vector(s-1 downto 0);
        		outReady	: out std_logic
                );

end component lwhv2;

   --Inputs
   signal clk : std_logic := '0';
--    signal gclklcx, gclkc1x, clkx : std_logic_vector(n-1 downto 0) :=(others => clk);
--    signal gclklc, gclkc1 : std_logic_vector(n-1 downto 0);
--    signal selc1, sellc : std_logic := '0';
--   signal inS : std_logic_vector(s-1 downto 0) := (others => '0');
--  signal inMC: std_logic_vector(s-1 downto 0) := (others => '1');
 
   signal input, output : std_logic_vector(s-1 downto 0);
   signal nReset, nBlock, outReady, init : std_logic;
   
 	--Outputs
--    signal outS : std_logic_vector(s-1 downto 0);
--    signal outMC: std_logic_vector(s*n-1 downto 0);
--    signal enAdd : std_logic;

--    signal round, offset : std_logic_vector(3 downto 0);
   
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
-- uut: state
--   GENERIC MAP(NBITS_s=>s,NBITS_n=>n)
-- 	PORT MAP (
-- 			   gclkc1 => gclkc1x,
-- 			   gclklc => gclklcx,
-- 			   selc1 => selc1,
-- 			   sellc => sellc,
-- 			   inMC => inMc,
-- 			   inS => inS,
-- 			   outS => outS,
-- 			   outMC => outMC
-- 			   );

-- UUT: controler 
-- port map(
-- 	clk	=> clk,
-- 	nReset => nReset,
-- 	gclkc1  => gclkc1,
-- 	gclklc => gclklc,
-- 	round  => round,
--   	offset  => offset,
--   	enAdd => enAdd,
--   	done => out_ready
-- );

UUT: lwhv2
     port map(
     			clk		 => clk, 
        		init	 => init,
        		nReset	 => nReset,
        		nBlock	 => nBlock,
                input    => input,
                output   => output,
        		outReady => outReady
                );


   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
--       clkx <= (others => clk);
-- 		  gclkc1x <= gclkc1 AND clkx;
-- 		  gclklcx <= gclklc AND clkx;

	check_results : process
		begin
-- 		  wait for 0.5*clk_period;
-- 		  n_reset <= '0';
-- 		  wait for 7*clk_period;
-- 		  n_reset <= '1';
-- 		  wait for 130*clk_period;
-- 		  
-- 		  n_reset <='0';
-- 		  gclkc1 <= (others => '1');
-- 		  gclklc <= (others => '1');

			-- start cipher with new input
-- 			selc1 <= '0';
-- 			sellc <= '0';
			

--start here!--
init <= '0';
nBlock <= '0';
input <= x"F";
--reset for min n clk cycles
nReset <= '0';
wait for n*clk_period;
nBlock <= '0';
input <= x"F";
init <= '0';
wait for n*n*clk_period;

--reset done, input initial data
wait for 0.5*clk_period;
nReset <= '1';
 wait for 0.5*clk_period;

			--test normal serialized mode of operation
-- 			FOR i in 0 to n*n-1 loop
-- 				input <= conv_std_logic_vector(i,s);
-- 				init <= '0';
-- 				nBlock <= '1';
-- 				-- wait one cycle to load data
-- 				wait for clk_period;
-- 			end loop;

--  		  wait for 0.5*clk_period;

-- input all 0's 
				input <= x"0";
				init <= '0';
				nBlock <= '1';
				wait for (n*n-6)*clk_period;
-- input IV 
				input <= x"1";
				wait for clk_period;
				input <= x"4";
				wait for clk_period;
				input <= x"1";
				wait for clk_period;
				input <= x"4";
				wait for clk_period;
				input <= x"1";
				wait for clk_period;
				input <= x"0";
				wait for clk_period;
		
--S-box feedback instead of 0
init <= '1';
nBlock <= '0';

wait for 12*(2*n*(n+1)-1)*clk_period;

-- for r in 1 to 12 loop
-- --SB/INIT--
-- 			--test normal serialized mode of operation
-- 			FOR i in 0 to n*n-1 loop
-- 				inS <= conv_std_logic_vector(i,s);
-- 				-- wait one cycle to load data
-- 				wait for clk_period;
-- 			end loop;
-- 	
-- --SR--		
-- 			wait for (n-1)*clk_period;	
-- --MC--
-- 			wait for (n+1)*n*clk_period;
-- end loop;
-- 
-- wait for n*clk_period;

	--to feedback the same row
-- 			sellc <= '1';
    --rotate by one
-- 			gclkc1 <= "111110";
-- 			gclklc <= "111110";
-- 			wait for clk_period;
-- 
-- 			--rotate by two
-- 			gclkc1 <= "111100";
-- 			gclklc <= "111100";
-- 			wait for clk_period;
-- 
--     --rotate by three
-- 			gclkc1 <= "111000";
-- 			gclklc <= "111000";
-- 			wait for clk_period;
-- 
--     --rotate by four
-- 			gclkc1 <= "110000";
-- 			gclklc <= "110000";
-- 			wait for clk_period;
-- 
--     --rotate by five
-- 			gclkc1 <= "100000";
-- 			gclklc <= "100000";
-- 			wait for clk_period;
-- 
--     --sleep
-- 			gclkc1 <= "000000";
-- 			gclklc <= "000000";
-- 			wait for 10*clk_period;


--simulate MC
--n times rotating vertically
-- 			inMC <= x"F";
-- 			selc1 <= '1';
-- 			gclkc1 <= "111111";
-- 			gclklc <= "000000";			
-- 			wait for n*clk_period;
-- 
-- -- 1 clock shifting horizontally
-- 			sellc <= '1';
-- 			selc1 <= '0';
-- 			gclklc <= "111111";
-- 			wait for clk_period;
-- 			
-- --n times rotating vertically
-- 			inMC <= x"F";
-- 			selc1 <= '1';
-- 			gclkc1 <= "111111";
-- 			gclklc <= "000000";			
-- 			wait for n*clk_period;
-- 
-- -- 1 clock shifting horizontally
-- 			sellc <= '1';
-- 			selc1 <= '0';
-- 			gclklc <= "111111";
-- 			wait for clk_period;
-- 			
-- --n times rotating vertically
-- 			inMC <= x"F";
-- 			selc1 <= '1';
-- 			gclkc1 <= "111111";
-- 			gclklc <= "000000";			
-- 			wait for n*clk_period;
-- 
-- -- 1 clock shifting horizontally
-- 			sellc <= '1';
-- 			selc1 <= '0';
-- 			gclklc <= "111111";
-- 			wait for clk_period;
-- 			
-- --n times rotating vertically
-- 			inMC <= x"F";
-- 			selc1 <= '1';
-- 			gclkc1 <= "111111";
-- 			gclklc <= "000000";			
-- 			wait for n*clk_period;
-- 
-- -- 1 clock shifting horizontally
-- 			sellc <= '1';
-- 			selc1 <= '0';
-- 			gclklc <= "111111";
-- 			wait for clk_period;
-- 			
-- --n times rotating vertically
-- 			inMC <= x"F";
-- 			selc1 <= '1';
-- 			gclkc1 <= "111111";
-- 			gclklc <= "000000";			
-- 			wait for n*clk_period;
-- 
-- -- 1 clock shifting horizontally
-- 			sellc <= '1';
-- 			selc1 <= '0';
-- 			gclklc <= "111111";
-- 			wait for clk_period;
-- 			
-- --n times rotating vertically
-- 			inMC <= x"F";
-- 			selc1 <= '1';
-- 			gclkc1 <= "111111";
-- 			gclklc <= "000000";			
-- 			wait for n*clk_period;
-- 
-- -- 1 clock shifting horizontally
-- 			sellc <= '1';
-- 			selc1 <= '0';
-- 			gclklc <= "111111";
-- 			wait for clk_period;
-- 			
-- --normal serial operation
-- 			selc1 <= '0';
-- 			sellc <= '0';
-- 			gclkc1 <= "111111";
-- 			gclklc <= "111111";			
-- 			wait for n*n*clk_period;
-- 			
		
			end process check_results;	
END;