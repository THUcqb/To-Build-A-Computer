library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- This is the implemetation of Memory
-- Can be both data memory and instruction memory

entity Memory is

    port (
        clk: in std_logic;
        --  Data signal (black wire)
        address: in std_logic_vector(15 downto 0);
        read_write_data: out std_logic_vector(15 downto 0);
        --  Control signal (blue wire)
        mem_read, mem_write: in std_logic;
        -- Device enable (pin)
        oe, we, en: out std_logic
    );

end Memory;

architecture memory_bev of Memory is

begin

    if (clk'event and clk = '1') then
        
    end if;

end memory_bev;
