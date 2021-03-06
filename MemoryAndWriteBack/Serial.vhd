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

begin

    --  Serial port read and write control signals
    --  Disable when resetting or not selecting serial port
    pin_out.wrn <= '0' when address = x"BF00" and
                            control_mem.mem_write = '1' and clk = '0'
                    else '1';

    pin_out.rdn <= '0' when address = x"BF00" and
                            control_mem.mem_read = '1'
                    else '1';

    --  Data memory bus
    data <= "00000000000000" & pin_in.ready & (pin_in.tsre and pin_in.tbre)
                when address = x"BF01" else
            write_data when control_mem.mem_write = '1' else
            (others => 'Z');

end beh;
