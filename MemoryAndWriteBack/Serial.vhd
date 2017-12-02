library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.utils.all;

-- This is the implemetation of SerialPort
-- Use as a memory except the pins.

entity Serial is
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
end Serial;

architecture beh of Serial is

    signal state: type_mem_state := mem_st1;

begin

    pin_out.rdn <= '1';
    pin_out.wrn <= '0';

    --  Testing, data_memory_bus will be all '1' if trying to write a serial!
    --  This means being routed successfully
    data <= "1111111111111111" when control_mem.mem_write = '1' else
            (others => 'Z');

end beh;
