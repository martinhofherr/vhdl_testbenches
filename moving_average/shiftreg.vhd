library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftreg is
    generic(LENGTH      : natural := 8;
            BIT_WIDTH   : natural := 8
    );
    port(clk_i      : in std_ulogic;
         reset_i    : in std_ulogic;

         data_i     : in std_ulogic_vector(BIT_WIDTH-1 downto 0);
         wr_i       : in std_ulogic;

         data_o     : out std_ulogic_vector(BIT_WIDTH-1 downto 0)
    );
end entity;

architecture BEHAV of shiftreg is
    type ram is array(0 to LENGTH-1) of std_ulogic_vector(BIT_WIDTH-1 downto 0);
    signal memory : ram;

    signal index     : integer range 0 to LENGTH-1;
begin

    FIFO_PROC:process(clk_i)
    begin
        if reset_i = '0' then
            index <= 0;
            data_o <= (others => '0');
        else
            if rising_edge(clk_i) then
                if wr_i = '1' then
                    data_o <= memory(index);
                    memory(index) <= data_i;

                    if index = LENGTH-1 then
                        index <= 0;
                    else
                        index <= index + 1;
                    end if;
                end if;                    
            end if;
        end if;
    end process;

end architecture;
