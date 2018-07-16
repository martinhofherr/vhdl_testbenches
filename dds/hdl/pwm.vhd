library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm is
    generic(WIDTH       : natural := 9);
    port(clk_i          : in std_ulogic;
         reset_n_i      : in std_ulogic;

         compare_max_i  : in std_ulogic_vector(WIDTH-1 downto 0);
         compare_i      : in std_ulogic_vector(WIDTH-1 downto 0);
         pwm_o          : out std_ulogic
    );
end entity;

architecture BEHAV of pwm is
    signal counter      : unsigned(WIDTH-1 downto 0);
begin

    CNT_PROC:process(clk_i)
    begin
        if rising_edge(clk_i) then
            if reset_n_i = '0' then
                counter <= (others => '0');
            else
                if counter = to_unsigned(0, counter'length) then
                    counter <= unsigned(compare_max_i);
                else
                    counter <= counter - 1;
                end if;
            end if;
        end if;
   end process;

   pwm_o <= '1' when counter < unsigned(compare_i) else '0';

end architecture;
