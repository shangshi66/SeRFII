library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity sha_tb is
end sha_tb;

architecture BHV of sha_tb is
	signal clk, rst, go, done : std_logic := '0';
	signal data_in : std_logic_vector(511 downto 0);
	signal data_out : std_logic_vector(255 downto 0);
begin

	UUT : entity work.SHA_IP
		port map(
				clk => clk,
				rst => rst,
				go => go,
				data_in => data_in,
				data_out => data_out,				
				done => done);
	
	clk <= not clk after 5 ns;
	 
	process 
	begin
		rst <= '1';
			for i in 0 to 20 loop 
				wait until rising_edge(clk);
			end loop;
			
			rst <= '0';
			for i in 0 to 20 loop 
				wait until rising_edge(clk);
			end loop;
		data_in <= x"1234FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
		wait until rising_edge(clk);
		go <= '1';
		
		wait until done = '1';
		wait until rising_edge(clk);
		rst <= '1';
		go <= '0';
				wait until rising_edge(clk);
		rst <= '0';
		data_in <= x"1234FFFFF5FFFFFFFFFFFFFFF8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
		go <= '1';
		wait until done = '1';
		wait;	
	end process;
end BHV;