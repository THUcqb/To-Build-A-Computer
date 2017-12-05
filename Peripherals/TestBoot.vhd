library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.utils.all;

entity TestBoot is

    port
    (
        -- clock
        clk_11: in std_logic;

        -- Instruction memory - RAM 2
        instruction_memory_data: inout std_logic_vector(15 downto 0);
        instruction_memory_pin: out type_ram_pin;

        -- Flash
        flash_pin: out type_flash_pin;
        flash_data : inout std_logic_vector(15 downto 0)
    );

end TestBoot;

architecture beh of TestBoot is

    signal boot_complete: std_logic;
    signal boot_instruction_memory_pin: type_ram_pin;

begin
    
    boot: entity work.boot
        port map (
            clk => clk_11,
            rst => '1',

            instruction_memory_data => instruction_memory_data,
            instruction_memory_pin => instruction_memory_pin,

            flash_pin => flash_pin,
            flash_data => flash_data,

            complete => boot_complete
        );

end beh;
