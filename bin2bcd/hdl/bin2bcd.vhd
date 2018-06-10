library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Convert a binary value to BCD using the double dabble algorithm
entity bin2bcd is
	port(clk_i		: in std_ulogic;
	     reset_i 	        : in std_ulogic;
	     start_i	        : in std_ulogic;
	     data_i		: in std_ulogic_vector(7 downto 0);
	     busy_o		: out std_ulogic;
	     bcd_o		: out std_ulogic_vector(11 downto 0)
	);
end entity;

architecture BEHAV of bin2bcd is
    signal busy         : std_ulogic;
    signal conv_reg     : std_ulogic_vector(19 downto 0);
    signal ones          : std_ulogic_vector(3 downto 0);
    signal tens          : std_ulogic_vector(3 downto 0);
    signal hundreds      : std_ulogic_vector(3 downto 0);
    signal loop_cnt     : integer range 0 to 8;
    --type state_t is (shift, check_ones, check_tens);
    --signal state : state_t;
    signal state      : integer range 0 to 2;

    signal one_incr     : std_ulogic_vector(19 downto 0);
    signal ten_incr     : std_ulogic_vector(19 downto 0);
begin


    -- map slices of conversion register for convenience
    ones <= conv_reg(11 downto 8);
    tens <= conv_reg(15 downto 12);
    hundreds <= conv_reg(19 downto 16);

    -- convenience increment signals
    one_incr(19 downto 12) <= (others => '0');
    one_incr(11 downto 8) <= "0011";
    one_incr(7 downto 0) <= (others => '0');

    ten_incr(19 downto 16) <= (others => '0');
    ten_incr(15 downto 12) <= "0011";
    ten_incr(11 downto 0) <= (others => '0');

    -- map internal signals to outputs
    busy_o <= busy;
    bcd_o <= conv_reg(19 downto 8);
    
    process(clk_i)
    begin
        if reset_i = '1' then
            busy <= '0';
        else
            if rising_edge(clk_i) then
                if busy = '0' then
                    if start_i = '1' then
                        busy <= '1';
                        conv_reg(7 downto 0) <= data_i;
                        conv_reg(19 downto 8) <= (others => '0');
                        loop_cnt <= 8;
                        --state <= shift;
                        state <= 0;
                    end if;
                else
                    if loop_cnt = 0 then
                        busy <= '0';
                    else
                        case state is
                                                        
                            when 0 =>
                                if ones > "0100" then
                                    conv_reg <= std_ulogic_vector(unsigned(conv_reg) + unsigned(one_incr));
                                end if;
                                --state <= check_tens;
                                state <= 1;

                            when 1 =>
                                if tens > "0100" then
                                    conv_reg <= std_ulogic_vector(unsigned(conv_reg) + unsigned(ten_incr));
                                end if;

                                --state <= shift;
                                state <= 2;

                            when 2 =>
                                conv_reg <= conv_reg(18 downto 0) & '0';
                                --state <= check_ones;
                                state <= 0;
                                loop_cnt <= loop_cnt - 1;

                            when others => state <= 0;

                        end case;
                    end if;
                end if;
            end if;
        end if;
    end process;

end architecture;
