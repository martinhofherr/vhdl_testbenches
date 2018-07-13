library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity rom is
    port(clk_i  : in std_ulogic;
         addr_i : in std_ulogic_vector(7 downto 0);
         data_o : out std_ulogic_vector(7 downto 0)
   );
end entity;


architecture BEHAV of rom is
    type memory is array (0 to 255) of std_ulogic_vector(7 downto 0);
    constant romtab : memory := (
        x"00", x"01", x"02", x"03", x"04", x"05", x"06", x"07", x"08", x"09", 
        x"0a", x"0b", x"0c", x"0d", x"0e", x"0f", x"10", x"11", x"12", x"13", 
        x"14", x"15", x"16", x"17", x"18", x"19", x"1a", x"1b", x"1c", x"1d", 
        x"1e", x"1f", x"20", x"21", x"22", x"23", x"24", x"25", x"26", x"27", 
        x"28", x"29", x"2a", x"2b", x"2c", x"2d", x"2e", x"2f", x"30", x"31", 
        x"32", x"33", x"34", x"35", x"36", x"37", x"38", x"39", x"3a", x"3b", 
        x"3c", x"3d", x"3e", x"3f", x"40", x"41", x"42", x"43", x"44", x"45", 
        x"46", x"47", x"48", x"49", x"4a", x"4b", x"4c", x"4d", x"4e", x"4f", 
        x"50", x"51", x"52", x"53", x"54", x"55", x"56", x"57", x"58", x"59", 
        x"5a", x"5b", x"5c", x"5d", x"5e", x"5f", x"60", x"61", x"62", x"63", 
        x"64", x"65", x"66", x"67", x"68", x"69", x"6a", x"6b", x"6c", x"6d", 
        x"6e", x"6f", x"70", x"71", x"72", x"73", x"74", x"75", x"76", x"77", 
        x"78", x"79", x"7a", x"7b", x"7c", x"7d", x"7e", x"7f", x"80", x"81", 
        x"82", x"83", x"84", x"85", x"86", x"87", x"88", x"89", x"8a", x"8b", 
        x"8c", x"8d", x"8e", x"8f", x"90", x"91", x"92", x"93", x"94", x"95", 
        x"96", x"97", x"98", x"99", x"9a", x"9b", x"9c", x"9d", x"9e", x"9f", 
        x"a0", x"a1", x"a2", x"a3", x"a4", x"a5", x"a6", x"a7", x"a8", x"a9", 
        x"aa", x"ab", x"ac", x"ad", x"ae", x"af", x"b0", x"b1", x"b2", x"b3", 
        x"b4", x"b5", x"b6", x"b7", x"b8", x"b9", x"ba", x"bb", x"bc", x"bd", 
        x"be", x"bf", x"c0", x"c1", x"c2", x"c3", x"c4", x"c5", x"c6", x"c7", 
        x"c8", x"c9", x"ca", x"cb", x"cc", x"cd", x"ce", x"cf", x"d0", x"d1", 
        x"d2", x"d3", x"d4", x"d5", x"d6", x"d7", x"d8", x"d9", x"da", x"db", 
        x"dc", x"dd", x"de", x"df", x"e0", x"e1", x"e2", x"e3", x"e4", x"e5", 
        x"e6", x"e7", x"e8", x"e9", x"ea", x"eb", x"ec", x"ed", x"ee", x"ef", 
        x"f0", x"f1", x"f2", x"f3", x"f4", x"f5", x"f6", x"f7", x"f8", x"f9", 
        x"fa", x"fb", x"fc", x"fd", x"fe", x"ff");
begin

    READ_PROC: process(clk_i)
    begin
        if rising_edge(clk_i) then
            data_o <= romtab(to_integer(unsigned(addr_i)));
        end if;
    end process;

end architecture;
