library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

package utils is

    type type_ram_pin is record
        address: std_logic_vector(15 downto 0);
        oe, we, en: std_logic;
    end record type_ram_pin;


    type type_control_ex is record
    -- TODO
        placeholder: std_logic;
    end record type_control_ex;


    type type_control_mem is record
    -- TODO
        placeholder: std_logic;
    end record type_control_mem;


    type type_control_wb is record
    -- TODO
        placeholder: std_logic;
    end record type_control_wb;

end package utils;
