library IEEE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SerialPort is 
    port(
        clk, rst: in std_logic;
        sw: in std_logic_vector(7 downto 0);
        led: out std_logic_vector(7 downto 0);
        rdn, wrn, ram1_en, ram1_oe, ram1_we: out std_logic;
        tbre, tsre, ready: in std_logic;
        ram1_data: inout std_logic_vector(7 downto 0)
    );
end SerialPort;

architecture Behavioral of SerialPort is
    type state is(
        w1, w2, w3, w4, r1, r2, r3
    );
    signal cur_state: state;
    signal tmp_data: std_logic_vector(7 downto 0);
begin
    process (clk, rst)
    begin
        if (rst = '1') then
            ram1_en <= '1';
            ram1_oe <= '1';
            ram1_we <= '1';
            wrn <= '1';
            rdn <= '1';
            cur_state <= r1;
        elsif (clk'event and clk = '0') then
            case cur_state is
                when w1 =>
                    ram1_data <= tmp_data + 1;
                    wrn <= '0';
                    cur_state <= w2;
                when w2 =>
                    wrn <= '1';
                    cur_state <= w3;
                when w3 =>
                    if (tbre = '1') then cur_state <= w4;
                    end if;
                when w4 =>
                    if (tsre = '1') then cur_state <= r1;
                    end if;
                when r1 =>
                    rdn <= '1';
                    ram1_data <= (others => 'Z');
                    cur_state <= r2;
                when r2 =>
                    if (ready = '1') then
                        rdn <= '0';
                        cur_state <= r3;
                    else cur_state <= r1;
                    end if;
                when r3 =>
                    led <= ram1_data;
                    tmp_data <= ram1_data;
                    rdn <= '1';
                    cur_state <= w1;
            end case;
        end if;
    end process;    
end Behavioral;   