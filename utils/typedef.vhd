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
        alu_op: std_logic_vector(2 downto 0);
        alu_src: std_logic;
        reg_dst: std_logic_vector(1 downto 0);
        rx_src: std_logic_vector(2 downto 0);
        branch_op: std_logic_vector(1 downto 0);
    end record type_control_ex;


    type type_control_mem is record
    -- TODO
        mem_read: std_logic;
        mem_write: std_logic;
    end record type_control_mem;


    type type_control_wb is record
    -- TODO
        placeholder: std_logic;
    end record type_control_wb;

end package utils;
