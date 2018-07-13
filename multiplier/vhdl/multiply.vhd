library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiply is
    port(a_i    : in std_ulogic_vector(7 downto 0);
         b_i    : in std_ulogic_vector(7 downto 0);
         prod_o : out std_ulogic_vector(15 downto 0)
    );
end entity;

architecture STRUCT of multiply is
begin

    MULT_PROC:process(a_i, b_i)
        type shift_type is array(0 to 7) of std_ulogic_vector(15 downto 0);
        variable shifts : shift_type;
        variable prod : std_ulogic_vector(15 downto 0);
    begin
        for i in 0 to 7 loop
            shifts(i) := (others => '0');
            shifts(i)(7+i downto i) := a_i;
        end loop;


        prod := (others => '0');

        for i in 0 to 7 loop
            if(b_i(i) = '1') then
                prod := std_ulogic_vector(unsigned(shifts(i)) + unsigned(prod));
            end if;
        end loop;
        prod_o <= prod;
    end process;


end architecture;
