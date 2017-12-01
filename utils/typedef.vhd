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
        branch_op: std_logic_vector(2 downto 0);
        rx_src: std_logic_vector(2 downto 0);
        ry_src: std_logic;
        reg_dst: std_logic_vector(2 downto 0);
        alu_op: std_logic_vector(3 downto 0);
        branch: std_logic;
    end record type_control_ex;


    type type_control_mem is record
        mem_read: std_logic;
        mem_write: std_logic;
    end record type_control_mem;


    type type_control_wb is record
        mem_to_reg: std_logic;
        reg_write: std_logic;
    end record type_control_wb;

    type type_instruction is record
        control_ex: type_control_ex;
        control_mem: type_control_mem;
        control_wb: type_control_wb;
    end record type_instruction;
    
    constant delay_in_registers: time := 5 ns;
end package utils;
