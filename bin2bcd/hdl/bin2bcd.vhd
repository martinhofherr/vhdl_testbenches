library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Convert a binary value to BCD using the double dabble algorithm
entity bin2bcd is
	port(clk_i		: in std_ulogic;
		 reset_i 	: in std_ulogic;
		 start_i	: in std_ulogic;
		 data_i		: in std_ulogic_vector(7 downto 0);
		 busy_o		: out std_ulogic;
		 bcd_o		: out std_ulogic_vector(11 downto 0)
	);
end entity;

architecture BEHAV of bin2bcd is
begin

	busy_o <= '0';
	bcd_o <= (others => '0');



end architecture;
