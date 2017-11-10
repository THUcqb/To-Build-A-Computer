library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RamController is
    port(
        clk, rst: in std_logic;
        sw: in std_logic_vector(15 downto 0);
        ram1_addr,ram2_addr: out std_logic_vector(17 downto 0);
        ram1_data, ram2_data: inout std_logic_vector(15 downto 0);
        ram1_oe, ram1_we, ram1_en: out std_logic;
        ram2_oe, ram2_we, ram2_en: out std_logic;
        led: out std_logic_vector(15 downto 0);
        dyp: out std_logic_vector(7 downto 0);
        rdn, wrn: out std_logic
    );
end RamController;

architecture Behavioral of RamController is
    type state is (la, ld, w1, w2, w3, r1, r2, w11, w22, w33, r11, r22);
    signal cur_state: state;
    signal tmp_addr: std_logic_vector(17 downto 0);
    signal tmp_data: std_logic_vector(15 downto 0);
    shared variable cnt : Integer := 0;
begin
    process(clk, rst)
    begin
        if (rst = '1') then
            ram1_oe <= '1';
			ram1_we <= '1';
			ram1_en <= '1';
            ram2_oe <= '1';
            ram2_we <= '1';
            ram2_en <= '1';
            wrn <= '1';
			rdn <= '1';
            led <= (Others => '0');
            dyp <= (Others => '0');
            ram1_addr <= (Others => '0');
            ram2_addr <= (Others => '0');
			ram1_data <= (Others => 'Z');
            ram2_data <= (Others => 'Z');
            cur_state <= la;
            dyp <= "00000000";
        elsif (clk'event and clk = '1') then
            case cur_state is
                when la => --读入地址
                    tmp_addr(15 downto 0) <= sw;
                    led(15 downto 8) <= tmp_addr(7 downto 0);
                    cur_state <= ld;
                    dyp <= "00001100";
                when ld => --读入数据
                    tmp_data <= sw;
                    led(7 downto 0) <= tmp_data(7 downto 0);
                    cur_state <= w1;
                    dyp <= "10110110";
                when w1 => --写建�?
                    ram1_addr <= tmp_addr;
                    ram1_data <= tmp_data;
                    led(15 downto 8) <= tmp_addr(7 downto 0);
                    led(7 downto 0) <= tmp_data(7 downto 0);
                    ram1_en <= '0';
                    cur_state <= w2;
                    dyp <= "10011110";
                when w2 => 
                    ram1_we <= '0';
                    cur_state <= w3;
                    dyp <= "11011100";
                when w3 => 
                    ram1_we <= '1';
                    cnt := cnt + 1;
                    dyp <= "11011010";
                    if (cnt = 10) then
                        cnt := 0;
                        cur_state <= r1;
                    else
                        tmp_addr <= tmp_addr + 1;
                        tmp_data <= tmp_data + 1;
                        cur_state <= w1;
                    end if;
                when r1 => 
                    ram1_data <= (Others => 'Z');
                    ram1_oe <= '0';
                    cur_state <= r2;
                    led(15 downto 8) <= tmp_addr(7 downto 0);
					led(7 downto 0) <= tmp_data(7 downto 0);
                    dyp <= "11111010";
                when r2 => 
                    tmp_data <= ram1_data;
                    led(15 downto 8) <= tmp_addr(7 downto 0);
					led(7 downto 0) <= tmp_data(7 downto 0);
                    tmp_addr <= tmp_addr - '1';
                    ram1_addr <= tmp_addr;
                    cnt := cnt + 1;
                    dyp <= "00001110";
                    if (cnt = 10) then 
                        cur_state <= w11;
                        cnt := 0;
                        ram1_addr <= tmp_addr + '1';
                    end if;
                when w11 =>
                    ram1_we <= '1';
                    ram1_oe <= '1';
                    ram2_en <= '0';
                    ram2_data <= tmp_data;
                    ram2_addr <= tmp_addr;
                    led(15 downto 8) <= tmp_addr(7 downto 0);
                    led(7 downto 0) <= tmp_data(7 downto 0);
                    dyp <= "11111110";
                    cur_state <= w22;
                when w22 =>
                    ram2_we <= '0';
                    dyp <= "11011110";
                    cur_state <= w33;
                when w33 => 
                    ram2_we <= '1';
                    cnt := cnt + 1;
                    dyp <= "11101110";
                    if (cnt:=10) then
                        cnt:=0;
                        cur_state <= r11;
                    else 
                        tmp_addr <= tmp_addr + 1;
                        tmp_data <= tmp_data + 1;
                        cur_state <= w11;
                    end if;
                when r11 => 
                    ram2_oe <= '0';
                    ram2_data <= (Others => 'Z');
                    led(15 downto 8) <= tmp_addr(7 downto 0);
                    led(7 downto 0) <= tmp_data(7 downto 0);
                    cur_state <= r22;
                    dyp <= "11110010";
                when r22 =>
                    tmp_data <= ram2_data;
                    led(15 downto 8) <= tmp_addr(7 downto 0);
                    led(7 downto 0) <= tmp_data(7 downto 0);
                    tmp_addr <= tmp_addr - '1';
                    ram2_addr <= tmp_addr;
                    cnt := cnt + 1;
                    dyp <= "01110000";
                    if (cnt = 10) then
                        cnt := 0;
                        cur_state <= la;
                        ram2_addr <= tmp_addr + '1';
                    end if;
                when others =>
            end case;
        end if;
    end process;
end Behavioral;