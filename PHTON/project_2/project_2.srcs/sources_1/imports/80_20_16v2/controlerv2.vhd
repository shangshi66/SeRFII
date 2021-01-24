library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.hashpkg.all;
-- n x n is the size of the Matrix
entity controlerv2 is
port(
	clk		: in std_logic;
	nReset  : in std_logic;
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
end entity controlerv2;

	
architecture fsm of controlerv2 is

----------------------------------------------------------
-- component declaration
----------------------------------------------------------

component LFSRcounter5 is
	port(
		clk	: in std_logic;
		selDataIn    : in std_logic;
		q	: out std_logic_vector(2 downto 0)
		);

end component LFSRcounter5;

component LFSRcounter15v2 is
	port(
		clk	: in std_logic;
		selDataIn    : in std_logic;
		q	: out std_logic_vector(3 downto 0)
		);

end component LFSRcounter15v2;

component clock_gate IS
PORT (  clk    : IN std_logic;
        enable : IN std_logic;
        clk_en : OUT std_logic
);
END component clock_gate;

component clock_gatex IS
GENERIC(NBITS : Integer);
PORT (  clk    : IN std_logic;
        enable : IN std_logic_vector(NBITS-1 downto 0);
        clk_en : OUT std_logic_vector(NBITS-1 downto 0)
);
END component clock_gatex;

----------------------------------------------------------
-- finite state stuff
----------------------------------------------------------
	
	type lwh_states is (S_IDLE, S_INIT, S_SB, S_SR1, S_SR2, S_SR3, S_SR4, S_MC, S_MCshift);
 
  	signal lwh_state  		: lwh_states;
  	signal next_state 		: lwh_states;

----------------------------------------------------------
-- signal declaration
----------------------------------------------------------

signal countRound  : std_logic_vector(3 downto 0);
signal countCols : std_logic_vector(2 downto 0);
signal countRows : std_logic_vector(2 downto 0);
signal gclkc1, gclklc : std_logic_vector(n-1 downto 0);
signal en_countRound, rst_countRound : std_logic;
signal en_countCols, rst_countCols : std_logic;
signal en_countRows, rst_countRows : std_logic;
signal clk_countCols, clk_countRound, clk_countRows : std_logic;  

begin

----------------------------------------------------------
-- component instantiation
----------------------------------------------------------
cg_c1: clock_gatex
generic map (NBITS => n)
port map(  clk => clk,
        enable => gclkc1,
        clk_en => clkc1
        );

cg_lc: clock_gatex
generic map (NBITS => n)
port map(  clk => clk,
        enable => gclklc,
        clk_en => clklc
        );


-- col counter
cg_countCols: clock_gate
port map(  clk => clk,
        enable => en_countCols,
        clk_en => clk_countCols
        );

cnt_Cols: LFSRcounter5
  port map(
            clk => clk_countCols,
            selDataIn => rst_countCols,
            q => countCols
            );

-- row counter
cg_countRows: clock_gate
port map(  clk => clk,
        enable => en_countRows,
        clk_en => clk_countRows
        );
        
cnt_Rows: LFSRcounter5
  port map(
            clk => clk_countRows,
            selDataIn => rst_countRows,
            q => countRows
            );
  
-- round counter
cg_countRound: clock_gate
port map(  clk => clk,
        enable => en_countRound,
        clk_en => clk_countRound
        );

cnt_round: LFSRcounter15v2
  port map(
            clk => clk_countRound,
            selDataIn => rst_countRound,
            q => countRound
            );

----------------------------------------------------------
-- finite state stuff
----------------------------------------------------------

ps_state_change:	process(clk)
begin
	if(clk'event and clk = '0') then
		if (nReset = '0') then
			lwh_state <= S_IDLE;
		else
			lwh_state <= next_state;
		end if;
	end if;
end process;


----------------------------------------------------------
-- FSM
----------------------------------------------------------

ps_state_compute:  process(lwh_state, countCols, countRows)

begin

----------------------------------------------------------
-- finite state stuff
----------------------------------------------------------
next_state <= lwh_state;

-- by default all register clock
gclkc1 <= (others=>'1');--"111111";
gclklc <= (others=>'1');--"111111";

-- by default all register shift horizontally
selc1 <= '0';
sellc <= '0';
			
-- by default no reset
rst_countRound <= NOT nBlock;
rst_countCols <= '1';
rst_countRows <= '1';

-- by default no counter counts
en_countRows <= '0';
en_countCols <= '0';
en_countRound <= nBlock;
		
case lwh_state is

        when S_IDLE =>
        --reset counters etc
        --needs to be active low for at least n clock cycles
			rst_countCols <= '0';
			rst_countRows <= '0';
			rst_countRound <= '0';
			en_countRows <= '1';
			en_countCols <= '1';
			en_countRound <= '1';
			next_state <= S_SB;
        
		when S_SB=>
		--n x n clock cycles
		--all register clock
		--all sel in horizontal mode
		en_countCols <= '1';
		
		--0,1,3,6,4
		en_countRows <= countCols(2) AND (countCols(1) NOR countCols(0));--100
			--if(countCols="100" and countRows="100") then 
			if(countCols="000" and countRows="000") then 
			  next_state <= S_SR1;
			end if;
        
        when S_SR1=>
    	--rotate by one
	    	sellc <= '1';
	    	--don't clock row 0
    		gclkc1 <= "11110";
			gclklc <= "11110";
			next_state <= S_SR2;
		
        when S_SR2=>
		--rotate by two
	    	sellc <= '1';
	    	--don't clock row 0, 1
			gclkc1 <= "11100";
			gclklc <= "11100";
			next_state <= S_SR3;
		
        when S_SR3=>
	    --rotate by three
	    	sellc <= '1';
	    	--don't clock row 0, 1, 2
			gclkc1 <= "11000";
			gclklc <= "11000";
			next_state <= S_SR4;
		
    	when S_SR4=>
    	--rotate by four
	    	sellc <= '1';
	    	--don't clock row 0, 1, 2, 3
			gclkc1 <= "10000";
			gclklc <= "10000";
			next_state <= S_MC;
			
		when S_MC =>
			en_countCols <= '1';
			--only first column active
			gclkc1 <= (others=>'1');--"111111";
				-- first column in vertical shifting mode
 				selc1 <= '1';
				--other columns sleep
 				gclklc <= (others=>'0');--"000000";

        	if(countCols="000") then
			en_countRows <= '1';
			  	next_state <= S_MCshift;
			end if;
			
		when S_MCshift =>
			--after n cycles
			--next column, i.e. horizontal rotation 
-- 			en_countCols <= '1';
-- 			en_countRows <= '1';
				selc1 <= '0';
				sellc <= '1';
				gclklc <= (others=>'1');
		
        	if(countRows="000") then
			  	next_state <= S_SB;
			  	en_countRound <= '1';
			else
			  	next_state <= S_MC;
			end if;
        
        when others =>
        next_state <= S_IDLE;
        
end case;
        
end process;

----------------------------------------------------------
-- signal wiring
----------------------------------------------------------

enAdd <= (NOT countCols(2)) AND (countCols(1) NOR countCols(0));--000
round <= countRound;
offset <= '0'&countRows;

-- done when countRound is 0100 = 12 rounds
done <= (NOT countRound(3)) AND countRound(2) AND (countRound(1) NOR countRound(0));

-- done when countRound is 0101 = 12 rounds
--done <= (NOT countRound(3)) AND countRound(2) AND (NOT countRound(1)) AND countRound(0);

end;
