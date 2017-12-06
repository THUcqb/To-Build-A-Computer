library ieee;
use ieee.STD_LOGIC_1164.ALL;
use work.utils.all;

entity Keyboard is
    port (
        clk, clk_50, rst: in std_logic;
        control_mem: in type_control_mem;
        address: in std_logic_vector(15 downto 0);

        ps2_clk, ps2_data: in std_logic;

        data: out std_logic_vector(15 downto 0)
    );
end Keyboard;

architecture beh of Keyboard is

    SIGNAL ascii_new: std_logic;
    SIGNAL ascii_code: std_logic_vector(6 downto 0);

    signal ready: std_logic;
begin

    keyboard: entity work.ps2_keyboard_to_ascii
    port map(
        clk => clk_50,
        ps2_clk => ps2_clk,
        ps2_data => ps2_data,
        ascii_new => ascii_new,
        ascii_code => ascii_code
    );

    -- For 0xBF03, the lowest bit stands for if keyboard input buffer ready
    -- For 0xBF02, return the bufferred data.
    data <= x"000" & "000" & ready when address = x"BF03" else
            x"00" & '0' & ascii_code when address = x"BF02" else
            (others => 'Z');

    process (ascii_new)
    begin
        if address = x"BF02" and control_mem.mem_read = '1' then
            ready <= '0';
        elsif rising_edge(ascii_new) then
            ready <= '1';
        end if;

    end process;

end beh;
