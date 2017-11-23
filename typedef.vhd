library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

package utils is

    type ram_pin is record
        address: out std_logic_vector(15 downto 0);
        oe, we, en: out std_logic;
    end record ram_pin;


    type type_control_ex is record
-- TODO
end record type_control_ex;


    type type_control_mem is record
-- TODO
end record type_control_mem;


    type type_control_wb is record
-- TODO
end record type_control_wb;

end package utils;
