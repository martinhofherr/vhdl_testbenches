library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity up_down_counter is
    generic(WIDTH   : natural := 8);
    port(clk_i      : in std_ulogic;
         reset_n_i  : in std_ulogic;

         step_i     : in std_ulogic_vector(WIDTH-1 downto 0);
         count_o    : out std_ulogic_vector(WIDTH-1 downto 0);
         dir_o      : out std_ulogic
    );
end entity;


architecture BEHAV of up_down_counter is
    signal cnt_reg  : std_ulogic_vector(WIDTH-1 downto 0);
    signal cnt_dn   : std_logic;
begin
    CNT_PROC:process(clk_i)
        variable cnt_val    : std_ulogic_vector(WIDTH downto 0);
        variable cnt_next   : std_ulogic_vector(WIDTH downto 0);
    begin
        if rising_edge(clk_i) then
            if reset_n_i = '0' then
                cnt_reg <= (others => '0');
                cnt_dn <= '0';
            else
                cnt_val := '0' & cnt_reg;

                if cnt_dn = '0' then
                    cnt_val := std_ulogic_vector(unsigned(cnt_val) + unsigned(step_i));
                    cnt_next := std_ulogic_vector(unsigned(cnt_val) + unsigned(step_i));
                    -- Check guard bit
                    if cnt_next(WIDTH) = '1' then
                        cnt_dn <= '1';
                    end if;
                else
                    cnt_val := std_ulogic_vector(unsigned(cnt_val) - unsigned(step_i));
                    cnt_next := std_ulogic_vector(unsigned(cnt_val) - unsigned(step_i));
                    if cnt_next(WIDTH) = '1' then
                        cnt_dn <= '0';
                    end if;
               end if;
               cnt_reg <= cnt_val(WIDTH-1 downto 0);
           end if;
        end if;
    end process;

    count_o <= cnt_reg;
    dir_o <= cnt_dn;

end architecture;            
