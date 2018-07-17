library ieee;
use ieee.std_logic_1164.all;


entity singen is
    port(clk_i          : in std_ulogic;
         reset_n_i      : in std_ulogic;

         enable_i       : in std_ulogic;
         freq_factor_i  : in std_ulogic_vector(7 downto 0);
         pwm_o          : out std_ulogic
    );
end entity;

architecture BEHAV of singen is
    component dds is
        port(clk_i      : in std_ulogic;
             reset_n_i  : in std_ulogic;

             step_i     : in std_ulogic_vector(7 downto 0);
             enable_i   : in std_ulogic;
             dds_o      : out std_ulogic_vector(8 downto 0)
        );
    end component;

    component pwm is
        generic(WIDTH       : natural := 9);
        port(clk_i          : in std_ulogic;
             reset_n_i      : in std_ulogic;

             compare_max_i  : in std_ulogic_vector(WIDTH-1 downto 0);
             compare_i      : in std_ulogic_vector(WIDTH-1 downto 0);
             cycle_start_o  : out std_ulogic;
             pwm_o          : out std_ulogic
        );
    end component;

    constant DDS_MAX_VAL    : std_ulogic_vector(8 downto 0) := "111111110";
    signal pwm_compare      : std_ulogic_vector(8 downto 0);
    signal pwm_cycle_start  : std_ulogic;

begin
    
    DDS0: dds
    port map(clk_i => clk_i,
             reset_n_i => reset_n_i,
             step_i => freq_factor_i,
             enable_i => pwm_cycle_start,
             dds_o => pwm_compare
    );

    PWM0: pwm
    generic map(WIDTH => 9)
    port map(clk_i => clk_i,
             reset_n_i => reset_n_i,
             compare_max_i => DDS_MAX_VAL,
             compare_i => pwm_compare,
             cycle_start_o => pwm_cycle_start,
             pwm_o => pwm_o
    );

end architecture;
