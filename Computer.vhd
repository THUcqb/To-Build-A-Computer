library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.utils.all;

entity Computer is

    generic
    (
        N: integer := 1;
        period: time := 20 ns;
        delay_in_registers: time := 5 ns
    );

    port
    (
        -- clock
        clk, rst: in std_logic;

        -- Instruction memory - RAM 2
        instruction_memory_data: inout std_logic_vector(15 downto 0);

        instruction_memory_pin: out type_ram_pin;

        -- Data memory - RAM 1
        data_memory_data: inout std_logic_vector(15 downto 0);

        data_memory_pin: out type_ram_pin

        -- serial port

        --

    );

end Computer;

architecture Computer_beh of Computer is

    component InstructionFetch is
        port (
            -- clock
            clk: in std_logic;

            -- pc value in branch instructions
            branch_pc: in std_logic_vector(15 downto 0);

            -- control signals
            pc_select: in std_logic;
            pc_write: in std_logic;
            if_id_write: in std_logic;

            -- stage register outputs
            pc: out std_logic_vector(15 downto 0);
            instruction: out std_logic_vector(15 downto 0);


            -- Device pin
            -- data and address cable of instruction memory
            ram2_data: inout std_logic_vector(15 downto 0);
            ram2_pin: out type_ram_pin
        );
    end component InstructionFetch;

    component InstructionDecode is
        generic
        (
            delay: time
        );
        port
        (
            clk: in std_logic;

        -- IN
            -- From IF stage
            if_pc: in std_logic_vector(15 downto 0);
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
            reg_t_val, reg_sp_val, reg_ih_val: out std_logic_vector(15 downto 0);
            id_pc: out std_logic_vector(15 downto 0);

            -- IMM
            immediate: out std_logic_vector(15 downto 0);

            -- Control
            pc_select: out std_logic;

            control_out_ex: out type_control_ex;
            control_out_mem: out type_control_mem;
            control_out_wb: out type_control_wb

            -- Hazard detection
            id_branch: out std_logic
        );
    end component InstructionDecode;

    component Execute is
        port (
        -- clock
            clk: in std_logic;

        -- IN
            -- Data (black)
            rx, ry, rz: in std_logic_vector(2 downto 0);
            rx_val, ry_val: in std_logic_vector(15 downto 0);
            immediate: in std_logic_vector(15 downto 0);

            -- Control (blue)
            control_in_ex: in type_control_ex;
            control_in_mem: out type_control_mem;
            control_in_wb: out type_control_wb;

            -- Forwarding data
            forward_data_from_mem: in std_logic_vector(15 downto 0);
            forward_data_from_wb: in std_logic_vector(15 downto 0);
            -- Forwarding control
            forward_control_x: in std_logic_vector(1 downto 0);
            forward_control_y: in std_logic_vector(1 downto 0);

        -- OUT
            -- data
            alu_result: out std_logic_vector(15 downto 0);
            write_data: out std_logic_vector(15 downto 0);
            -- register destination
            id_ex_rd: out std_logic_vector(2 downto 0);
            ex_mem_rd: out std_logic_vector(2 downto 0);

            -- control
            control_out_mem: out type_control_mem;
            control_out_wb: out type_control_wb

        );
    end component Execute;

    component Memory is
        port(
        -- clock
            clk: in std_logic;

        -- IN
            -- Data
            alu_result: in std_logic_vector(15 downto 0);
            write_data: in std_logic_vector(15 downto 0);
            ex_mem_rd: in std_logic_vector(2 downto 0);

            -- Control
            control_in_mem: in type_control_mem;
            control_in_wb: in type_control_wb;

        -- MID - write back
            -- data
            -- data_from_memory: out std_logic_vector(15 downto 0);
            -- data_from_alu_result: out std_logic_vector(15 downto 0);

        -- OUT
            -- data
            data_to_write_back: out std_logic_vector(15 downto 0);
            --
            mem_wb_rd: out std_logic_vector(2 downto 0);
            -- Control
            control_out_wb: out type_control_wb
            -- Device
            ram1_data: inout std_logic_vector(15 downto 0);
            ram1_pin: out type_ram_pin
        );
    end component Memory;

    component Forwarding is
        port(
            -- IN
            id_ex_rx: in std_logic_vector(2 downto 0);
            id_ex_ry: in std_logic_vector(2 downto 0);
            ex_mem_rd: in std_logic_vector(2 downto 0);
            mem_wb_rd: in std_logic_vector(2 downto 0);
            control_ex_mem_wb: in type_control_wb;
            control_mem_wb_wb: in type_control_wb;

            -- OUT
            forward_control_x: out std_logic_vector(1 downto 0);
            forward_control_y: out std_logic_vector(1 downto 0)
        );
    end component Forwarding;

    component HazardDetection is
        port(
        -- IN
            if_id_rx: in std_logic_vector(2 downto 0);
            if_id_ry: in std_logic_vector(2 downto 0);
            id_ex_rd: in std_logic_vector(2 downto 0);
            id_ex_control_mem: in type_control_mem;

        -- OUT
            pc_write: out std_logic;
            if_id_write: out std_logic;
            bubble_select: out std_logic
        );
    end component HazardDetection;
begin

end Computer_beh;
