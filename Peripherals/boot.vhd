library ieee;
use ieee.std_logic_1164.all;

library work;
use work.utils.all;

entity boot is
    port (
        clk, rst: in std_logic;

        instruction_memory_data: inout std_logic_vector(15 downto 0);
        instruction_memory_pin: out type_ram_pin;

        flash_pin : out type_flash_pin;
        flash_data : in std_logic_vector(15 downto 0);

        complete: out std_logic
    );
end boot;

architecture beh of boot is

    signal clk_flash, clk_ram: std_logic;

    signal flash_addr_input : std_logic_vector(22 downto 1);
    signal flash_data_output : std_logic_vector(15 downto 0);

    signal im_control : type_control_mem;
    signal im_addr_input : std_logic_vector(15 downto 0) := (others => '0');
    signal im_data_input : std_logic_vector(15 downto 0);

    signal boot_complete : std_logic := '0';
begin

    clk_producer: entity work.clk_1152
    port map (
        clk => clk,
        clk_flash => clk_flash,
        clk5000 => clk_ram
    );

    flash: entity work.flash_io
    port map (
        clk => clk_flash,
        reset => rst,

        addr => flash_addr_input,
        data_out => flash_data_output,

        flash_byte => flash_pin.flash_byte,
        flash_vpen => flash_pin.flash_vpen,
        flash_ce => flash_pin.flash_ce,
        flash_oe => flash_pin.flash_oe,
        flash_we => flash_pin.flash_we,
        flash_rp => flash_pin.flash_rp,
        flash_addr => flash_pin.flash_addr,
        flash_data => flash_data
    );

    im: entity work.Memory
    port map (
        clk => clk_ram,
        rst => rst,
        control_mem => im_control,
        address => im_addr_input,
        write_data => im_data_input,

        pin => instruction_memory_pin,
        data => instruction_memory_data
    );

    boot_complete <= '0' when rst = '0' else
                     '0' when im_addr_input /= x"4000" else
                     '1';
    flash_addr_input <= "000000" & im_addr_input;

    im_control.mem_write <= '1' when boot_complete = '0' else
                            '0';
    im_control.mem_read <= '0';

    im_data_input <= flash_data_output;

    complete <= boot_complete;

    starting_up: process (clk_ram, rst)
    begin
        if rst = '0' then
            im_addr_input <= (others => '0');
        elsif rising_edge(clk_ram) and boot_complete = '0' then
            im_addr_input <= im_addr_input + '1';
        end if;
    end process;
end beh;
