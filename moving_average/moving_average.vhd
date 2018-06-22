library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity moving_average is
    generic(FILTER_LEN      : unsigned := 8;
            BIT_WIDTH       : unsigned := 8
    );
    port(clk_i          : in std_ulogic;
         reset_i        : in std_ulogic;

         data_i         : in std_ulogic_vector(BIT_WIDTH-1 downto 0);
         wr_i           : in std_ulogic;

         mean_o         : out std_ulogic_vector(BIT_WIDTH-1 downto 0)
    );
end entity;

architecture BEHAV of moving_average is
    constant val_max      : unsigned := (2**BIT_WIDTH)-1
    constant acc_max      : unsigned := FILTER_LEN*val_max;
    constant shift        : unsigned := unsigned(log2(real(FILTER_LEN)));
    signal accu           : unsigned range 0 to acc_max;
    
    signal oldest         : unsigned range 0 to val_max;

begin

    FIFO: entity work.shiftreg
    generic_map(LENGTH => FILTER_LEN,
                BIT_WIDTH => BIT_WIDTH
    )
    port map(clk_i => clk_i,
             reset_i => reset_i,
             data_i => data_i,
             wr_i => wr_i,
             data_o => oldest
    );
    
    MAVG_PROC:process(clk_i)
        variable new_accu   : unsigned range 0 to acc_max;
    begin
        if (rising_edge(clk_i)) then
            if (wr_i = '1') then
                new_accu := accu - oldest;
                new_accu := accu + data_i;

                accu <= new_accu;
                mean_o <= std_ulogic_vector(new_accu)(new_accu'left downto shift);
            end if;
    end process;

end architecture;
