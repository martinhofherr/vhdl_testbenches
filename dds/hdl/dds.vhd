library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dds is
    port(clk_i      : in std_ulogic;
         reset_n_i  : in std_ulogic;

         step_i     : in std_ulogic_vector(7 downto 0);
         enable_i   : in std_ulogic;
         dds_o      : out std_ulogic_vector(8 downto 0)
    );
end entity;

architecture BEHAV of dds is
    component rom is
        port(clk_i      : in std_ulogic;
             addr_i     : in std_ulogic_vector(7 downto 0);
             data_o     : out std_ulogic_vector(7 downto 0)
        );
     end component;

    component up_down_counter is
        generic(WIDTH   : natural := 8);
        port(clk_i      : in std_ulogic;
             reset_n_i  : in std_ulogic;

             enable_i   : in std_ulogic;
             step_i     : in std_ulogic_vector(WIDTH-1 downto 0);
             count_o    : out std_ulogic_vector(WIDTH-1 downto 0);
             dir_o      : out std_ulogic
        );
    end component;

    signal rom_addr     : std_ulogic_vector(7 downto 0);
    signal rom_data     : std_ulogic_vector(7 downto 0);
    signal neg_half     : std_ulogic;
    
    signal cnt_dir      : std_ulogic;
    signal cnt_dir_reg  : std_ulogic;
    signal cnt_dir_falling  : std_ulogic;

    constant offset     : unsigned(8 downto 0) := "011111111";

begin

    LOOKUP_TABLE: rom
    port map(clk_i => clk_i,
             addr_i => rom_addr,
             data_o => rom_data
    );

    ADDR_COUNTER: up_down_counter
    generic map(WIDTH => 8)
    port map(clk_i => clk_i,
             reset_n_i => reset_n_i,
             enable_i  => enable_i,
             step_i => step_i,
             count_o => rom_addr,
             dir_o => cnt_dir
    );

    
    CNT_DIR_REG_PROC: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if reset_n_i = '0' then
                cnt_dir_reg <= '0';
            else
                cnt_dir_reg <= cnt_dir;
            end if;
        end if;
    end process;
    
    cnt_dir_falling <= cnt_dir_reg and (not cnt_dir);

    
    DDS_PROC:process(clk_i)
    begin
        if rising_edge(clk_i) then
            if reset_n_i = '0' then
                neg_half <= '0';
            else
                if neg_half = '0' then
                    dds_o <= std_ulogic_vector(unsigned(rom_data) + offset);
                    if cnt_dir_falling = '1' then
                        -- counter switched from counting down to counting up
                        -- we enter the negative half.
                        neg_half <= '1';
                    end if;
                else
                    dds_o <= std_ulogic_vector(offset - unsigned(rom_data));
                    if cnt_dir_falling = '1' then
                        neg_half <= '0';
                    end if;
                end if;
            end if;
        end if;
   end process;

end architecture;
