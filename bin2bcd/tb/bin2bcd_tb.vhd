library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin2bcd_tb is
end entity;

architecture BEHAV of bin2bcd_tb is
    -- input signals to dut
    signal clk      : std_ulogic := '0';
    signal reset    : std_ulogic := '0';
    signal start    : std_ulogic := '0';
    signal data     : std_ulogic_vector(7 downto 0) := (others => '0');
    
    -- output signals of dut
    signal busy     : std_ulogic;
    signal bcd      : std_ulogic_vector(11 downto 0);

    -- Clock period
    constant CLK_PERIOD : time := 1 us;

    procedure trigger_conversion (
        signal clk_i      : in std_ulogic;
        signal busy_i     : in std_ulogic;
        signal start_o    : out std_ulogic
    ) is
    begin
        start_o <= '1';
        wait until rising_edge(clk_i);
        wait until busy_i = '1';
        wait until rising_edge(clk_i);
        start_o <= '0';
        wait until busy_i = '0';
    end trigger_conversion;


begin

    -- clock process
    CLK_PROC: process
    begin
        clk <= not clk;
        wait for CLK_PERIOD/2;
    end process;

    STIM_PROC: process
    begin
        reset <= '1';
        wait for 10 * CLK_PERIOD;
        reset <= '0';

        for i in 0 to 255 loop
            data <= std_ulogic_vector(to_unsigned(i, data'length));
            trigger_conversion(clk_i => clk,
                               busy_i => busy,
                               start_o => start);
            wait for 10 * CLK_PERIOD;
        end loop;
        
        assert false report "end of test" severity note;
        --  Wait forever; this will finish the simulation.
        wait;
    end process;

    DUT: entity work.bin2bcd 
    port map(clk_i => clk,
             reset_i => reset,
             start_i => start,
             data_i => data, 
             busy_o => busy,
             bcd_o => bcd
    );

end architecture;
