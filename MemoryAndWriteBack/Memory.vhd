library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.utils.all;

-- This is the implemetation of Memory
-- Can be both data memory and instruction memory

entity Memory is
    port(
    -- IN
        control_mem: in type_control_mem;
        address, write_data: in std_logic_vector(15 downto 0);

    -- OUT
        pin: out type_ram_pin;
        data: inout std_logic_vector(15 downto 0)
    );
end Memory;

architecture memory_bev of Memory is

begin
    -- TODO: remove this placeholder
    data <= write_data;

end memory_bev;
