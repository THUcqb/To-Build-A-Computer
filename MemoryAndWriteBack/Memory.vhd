library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- This is the implemetation of the EX/MEM stage register file

entity EXMEM is

    port (
        -- From EX
        ex_data_memory_address,
        ex_data_memory_write_data: in std_logic_vector(15 downto 0);

        -- To Mem
        mem_data_memory_address,
        mem_data_memory_write_data: out std_logic_vector(15 downto 0)

    );


end EXMEM;
