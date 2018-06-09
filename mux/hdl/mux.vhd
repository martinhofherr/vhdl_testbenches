library ieee;
use ieee.std_logic_1164.all;

entity mux is
	port(data_i		: in std_ulogic_vector(3 downto 0);
		 sel_i		: in std_ulogic_vector(1 downto 0);
		 data_o		: out std_ulogic
	);
end entity;


architecture BEHAV of mux is
begin
	data_o <= data_i(0) when sel_i = "00" else
			  data_i(1) when sel_i = "01" else
 			  data_i(2) when sel_i = "10" else
			  data_i(3) when sel_i = "11";
end architecture;
