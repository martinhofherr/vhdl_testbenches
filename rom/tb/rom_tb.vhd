library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity;

architecture BEHAV of rom_tb is
    signal clk      : std_ulogic := '0';
    signal address  : std_ulogic_vector(7 downto 0) := (others => '0');
    signal data     : std_ulogic_vector(7 downto 0);

    constant CLK_PERIOD : time := 100 ns;

    component rom is
        port(clk_i  : in std_ulogic;
         addr_i : in std_ulogic_vector(7 downto 0);
         data_o : out std_ulogic_vector(7 downto 0)
        );
    end component;

begin

    DUT: rom
    port map(clk_i => clk,
             addr_i => address,
             data_o => data
    );

    CLK_PROC: process
    begin
        clk <= not clk;
        wait for CLK_PERIOD/2;
    end process;

    STIM_PROC:process
    begin
        wait for 10*CLK_PERIOD;

        for i in 0 to 255 loop
            address <= std_ulogic_vector(to_unsigned(i, address'length));
            wait until rising_edge(clk);
        end loop;

        wait;
    end process;

end architecture;
