library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.STD_LOGIC_ARITH.ALL;
use ieee.STD_LOGIC_UNSIGNED.ALL;
use work.utils.all;

--  This is Memory Manager
--  Act as a address router
--  RAM2(IM) 0x0000 - 0x7FFF
--  RAM1(DM) 0x8000 - 0xFFFF except 0xBF00~0xBF01
--  SerialPort1 0xBF00, 0xBF01

entity MemoryRouter is
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
        read_data: buffer std_logic_vector(15 downto 0);

    -- PIN
        -- Data Memory
        ram1_data: inout std_logic_vector(15 downto 0);
        ram1_pin: out type_ram_pin;
        -- Instruction Memory
        ram2_data: inout std_logic_vector(15 downto 0);
        instruction_memory_control: out type_control_mem;
        -- Serial port
        serial1_pin_in: in type_serial_pin_in;
        serial1_pin_out: out type_serial_pin_out
    );

end entity MemoryRouter;

architecture beh of MemoryRouter is

    component Memory is
        port(
        -- IN
            clk, rst: in std_logic;
            control_mem: in type_control_mem;
            address, write_data: in std_logic_vector(15 downto 0);

        -- OUT
            pin: out type_ram_pin;
            data: inout std_logic_vector(15 downto 0)
        );
    end component Memory;

    component Serial is
        port(
        -- IN
            clk, rst: in std_logic;
            control_mem: in type_control_mem;
            address, write_data: in std_logic_vector(15 downto 0);
            pin_in: in type_serial_pin_in;

        -- OUT
            pin_out: out type_serial_pin_out;
            data: inout std_logic_vector(15 downto 0)
        );
    end component Serial;

    signal data_memory_control, serial1_control
           : type_control_mem;

begin

    --  Route the memmory or serial port wish to operate with input address
    instruction_memory_control.mem_write <='1' when address(15 downto 14) = "01"
                                                and control_mem.mem_write = '1'
                                            else '0';
    instruction_memory_control.mem_read <= '0' when address(15 downto 14) = "01"
                                                and control_mem.mem_write = '1'
                                            else '1';

    data_memory_control <= control_mem when (address(15) = '1' and
                        address /= x"BF00" and address /= x"BF01" ) else
                                  type_control_mem_zero;

    serial1_control <= control_mem when
                            (address = x"BF00" or address = x"BF01") else
                           type_control_mem_zero;

    --  Select the read out data with address
    read_data <= ram2_data when address(15) = '0' else
                 ram1_data;

    data_memory: Memory
        port map(
            clk => clk,
            rst => rst,
            control_mem => data_memory_control,
            address => address,
            write_data => write_data,

            pin => ram1_pin,
            data => ram1_data
        );

    serial1: Serial
        port map(
            clk => clk,
            rst => rst,
            control_mem => serial1_control,
            address => address,
            write_data => write_data,

            pin_in => serial1_pin_in,
            pin_out => serial1_pin_out,
            data => ram1_data
        );

end architecture beh;
