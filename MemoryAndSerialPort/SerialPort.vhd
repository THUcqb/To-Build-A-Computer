library IEEE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SerialPort is
    port(
        clk, rst: in std_logic;
        sw: in std_logic_vector(15 downto 0);
        flags: out std_logic_vector(2 downto 0);
        rdn, wrn, ram1_en, ram1_oe, ram1_we: out std_logic;
        tbre, tsre, ready: in std_logic;
        ram1Addr: out std_logic_vector(17 downto 0);
        ram1Data: inout std_logic_vector(15 downto 0);
        dyp: out std_logic_vector(0 to 6)
    );
end SerialPort;

architecture Behavioral of SerialPort is
    component RAMReadWrite is
    port(
        --  clock and reset
        clk, rst: in std_logic;
        ram1Begin: in std_logic;
        ram1Started, ram1End: out std_logic;
        --  switch
        sw: in std_logic_vector(15 downto 0);
        --  RAM control signal
        ram1Addr: out std_logic_vector(17 downto 0);
        ram1Data: inout std_logic_vector(15 downto 0);
        ram1OE, ram1WE, ram1EN: out std_logic;
        --  Showing current state for debugging use.
        dyp: out std_logic_vector(0 to 6)
    );
    end component;
    
    type state is(
        w1, w2, w3, w4, r1, r2, startMem, waitMem, r3
    );
    shared variable cur_state: state;
    shared variable tmp_data: std_logic_vector(15 downto 0);
    signal ram1Begin, ram1Started, ram1End: std_logic;
    
begin
    ram1: RAMReadWrite port map
    (
        clk => clk, rst => rst,
        ram1Begin => ram1Begin, ram1Started => ram1Started, ram1End => ram1End,
        sw => sw,
        ram1Addr => ram1Addr, ram1Data => ram1Data,
        ram1OE => ram1_oe, ram1WE => ram1_we, ram1EN => ram1_en,
        dyp => dyp
    );

    process (clk, rst)
    begin
        if (rst = '0') then
            wrn <= '1';
            rdn <= '1';
            ram1Begin <= '0';
            flags <= "000";
            cur_state := r1;
        elsif (clk'event and clk = '0') then
            case cur_state is
                when w1 =>
                    flags <= "100";
                    ram1Data <= tmp_data + 1;
                    wrn <= '0';
                    cur_state := w2;
                when w2 =>
                    flags <= "101";
                    wrn <= '1';
                    cur_state := w3;
                when w3 =>
                    flags <= "110";
                    if (tbre = '1') then cur_state := w4;
                    end if;
                when w4 =>
                    flags <= "111";
                    if (tsre = '1') then cur_state := r1;
                    end if;
                when r1 =>
                    rdn <= '1';
                    ram1Data <= (others => 'Z');
                    flags <= "001";
                    cur_state := r2;
                when r2 =>
                    flags <= "010";
                    if (ready = '1') then
                        rdn <= '0';
                        cur_state := startMem;
                    else cur_state := r1;
                    end if;
                when startMem =>
                    ram1Begin <= '1';
                    if (ram1Started = '1') then
                        cur_state := waitMem;
                    end if;
                when waitMem =>
                    ram1Begin <= '0';
                    if (ram1End = '1') then
                        cur_state := r3;
                    end if;
                when r3 =>
                    flags <= "011";
                    tmp_data := ram1Data;
                    rdn <= '1';
                    cur_state := w1;
                when others =>
                    flags <= "000";
                    null;
            end case;
        end if;
    end process;
end Behavioral;