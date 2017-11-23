library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity InstructionDecode is
    generic (
        delay: time
    );
    port (
        clk: in std_logic;

    -- IN
        -- From IF stage
        pc: in std_logic_vector(15 downto 0);
        instruction: in std_logic_vector(15 downto 0);

        -- From Hazard control
        bubble_select: in std_logic;

        -- From write back
        register_from_write_back: in std_logic_vector(2 downto 0);
        data_from_write_back: in std_logic_vector(15 downto 0);
        reg_write: in std_logic;

    -- OUT
        -- Register file
        rx, ry, rz: out std_logic_vector(2 downto 0);
        rx_val, ry_val: out std_logic_vector(15 downto 0);
        -- IMM
        immediate: out std_logic_vector(15 downto 0);

        -- Control
        pc_select: out std_logic;
        branch_pc: out std_logic_vector(15 downto 0);

        control_out_ex: out type_control_ex;
        control_out_mem: out type_control_mem;
        control_out_wb: out type_control_wb
    );
end InstructionDecode;

architecture InstructionDecode_bhv of InstructionDecode is
    component BranchControl is
        port (
        -- IN
            branch_op: in std_logic_vector(4 downto 0);
            zero_flag: in std_logic;

        -- OUT
            pc_select: out std_logic
        );
    end component;

    component BubbleMaker is
        port (
        -- IN
            control_in_ex: in type_control_ex;
            control_in_mem: in type_control_mem;
            control_in_wb: in type_control_wb

            bubble_select: in std_logic;

        -- OUT
            control_out_ex: out type_control_ex;
            control_out_mem: out type_control_mem;
            control_out_wb: out type_control_wb
        );
    end component;

    component Control is
        port (
        -- IN
            op: in std_logic_vector(4 downto 0);

        -- OUT
            control_out_ex: out type_control_ex;
            control_out_mem: out type_control_mem;
            control_out_wb: out type_control_wb

            branch_op: out std_logic_vector(4 downto 0)
        );
    end component;

    component Registers is
        generic (
            delay: time
        );
        port (
            clk: in std_logic;
            
        -- IN
            rx, ry: in std_logic_vector(2 downto 0);
            write_register: in std_logic_vector(2 downto 0);
            write_data: in std_logic_vector(2 downto 0);

            control_reg_write: in std_logic;

        -- OUT
            rx_val: out std_logic_vector(15 downto 0);
            ry_val: out std_logic_vector(15 downto 0)
        );
    end component;
begin
end InstructionDecode_bhv;