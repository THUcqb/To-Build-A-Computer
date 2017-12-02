library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.STD_LOGIC_ARITH.ALL;
use ieee.STD_LOGIC_UNSIGNED.ALL;
use work.utils.all;

--  This is the test unit of MemoryRouter with clk automatically refreshing
--  dyp_left <= mem_write = '1' / '0'
--  LED <= address(7 downto 0) & write_data(7 downto 0)
--  sw => mem_write & address(6 downto 0) & write_data(7 downto 0)

entity TestMemoryRouter is
    port(
    -- clock
        clk, rst: in std_logic;

    -- IN
        sw: in std_logic_vector(15 downto 0);

    -- OUT
        -- read_data
        read_data: out std_logic_vector(15 downto 0);

    -- PIN
        -- Data Memory
        ram1_data: inout std_logic_vector(15 downto 0);
        ram1_pin: out type_ram_pin;
        -- Instruction Memory
        ram2_data: inout std_logic_vector(15 downto 0);
        ram2_pin: out type_ram_pin;
        -- Serial port
        serial1_pin_in: in type_serial_pin_in;
        serial1_pin_out: out type_serial_pin_out;

    -- Test
        dyp_left: out std_logic_vector(0 to 6)
        -- LED: out std_logic_vector(15 downto 0)
    );

end entity TestMemoryRouter;

architecture beh of TestMemoryRouter is

    component MemoryRouter is
        port(
        -- clock
            clk, rst: in std_logic;

        -- IN
            -- Data
            address: in std_logic_vector(15 downto 0);
            write_data: in std_logic_vector(15 downto 0);

            -- Control
            control_mem: in type_control_mem;

        -- OUT
            -- read_data
            read_data: out std_logic_vector(15 downto 0);

        -- PIN
            -- Data Memory
            ram1_data: inout std_logic_vector(15 downto 0);
            ram1_pin: out type_ram_pin;
            -- Instruction Memory
            ram2_data: inout std_logic_vector(15 downto 0);
            ram2_pin: out type_ram_pin;
            -- Serial port
            serial1_pin_in: in type_serial_pin_in;
            serial1_pin_out: out type_serial_pin_out
        );
    end component MemoryRouter;

    signal control_in_mem: type_control_mem;
    signal address: std_logic_vector(15 downto 0);
    signal write_data: std_logic_vector(15 downto 0);
begin
    address <= sw(14 downto 8) & "100000000";
    write_data <= "00000000" & sw(7 downto 0);
    control_in_mem.mem_write <= sw(15);
    control_in_mem.mem_read <= not sw(15);

    memory_router: MemoryRouter
        port map(
            clk => clk,
            rst => rst,
            control_mem => control_in_mem,
            address => address,
            write_data => write_data,

            read_data => read_data,

            ram1_pin => ram1_pin,
            ram1_data => ram1_data,
            ram2_pin => ram2_pin,
            ram2_data => ram2_data,
            serial1_pin_in => serial1_pin_in,
            serial1_pin_out => serial1_pin_out
        );


    -- LED(15 downto 8) <= address(7 downto 0);
    -- bind read_data to led 7 downto 0 in ucf
    -- LED(7 downto 0) <= read_data(7 downto 0);
    dyp_left <= "1111110" when control_in_mem.mem_write = '0' else
           "0110000" when control_in_mem.mem_write = '1' else
           "1111111";

end architecture beh;
